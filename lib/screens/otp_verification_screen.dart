// lib/screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../core/utils/constants/colors.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _resendTimer;
  int _attemptCount = 0;
  final int _maxAttempts = 3;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startResendTimer();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _handleOTPInput(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }

    // Auto-verify when all 4 digits are entered
    if (_otpCode.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _handleVerifyOTP();
      });
    }
  }

  void _handleBackspace(int index) {
    if (index > 0 && _otpControllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _clearOTP() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _shakeOTPFields() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _handleVerifyOTP() async {
    if (_otpCode.length != 4) {
      _showErrorSnackBar('Please enter the complete 4-digit code');
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      // Simulate API verification delay
      await Future.delayed(const Duration(milliseconds: 1200));

      // Check if OTP is correct (0000 for demo)
      if (_otpCode == '0000') {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginMethod', 'otp');
        await prefs.setString('verifiedPhone', widget.phoneNumber);

        if (mounted) {
          setState(() => _isLoading = false);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Verification Successful!',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Welcome to YOweMe',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.positiveGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );

          // Navigate to main screen
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            }
          });
        }
      } else {
        // Incorrect OTP
        setState(() {
          _isLoading = false;
          _attemptCount++;
        });

        _shakeOTPFields();
        _clearOTP();

        if (_attemptCount >= _maxAttempts) {
          _showErrorSnackBar(
            'Too many failed attempts. Please request a new code.',
            duration: 4,
          );
          setState(() => _attemptCount = 0);
        } else {
          _showErrorSnackBar(
            'Invalid code. ${_maxAttempts - _attemptCount} attempt${_maxAttempts - _attemptCount == 1 ? '' : 's'} remaining.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Verification failed. Please try again.');
      }
    }
  }

  void _handleResendOTP() async {
    if (!_canResend) return;

    HapticFeedback.selectionClick();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      _startResendTimer();
      _clearOTP();
      setState(() => _attemptCount = 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.send, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'New code sent!',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Check your messages for the verification code',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Failed to resend code. Please try again.');
    }
  }

  void _showErrorSnackBar(String message, {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.negativeRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: AppColors.getPrimaryTextColor(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify Phone',
          style: TextStyle(
            color: AppColors.getPrimaryTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Header Section
                    _buildHeaderSection(),

                    const SizedBox(height: 40),

                    // OTP Input Section
                    _buildOTPInputSection(),

                    const SizedBox(height: 20),

                    // Verify Button
                    _buildVerifyButton(),

                    const SizedBox(height: 20),

                    // Resend Section
                    _buildResendSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.getPrimaryGradient(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.shield,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Verify Your Number',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: AppColors.getSecondaryTextColor(context),
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'We sent a verification code to\n'),
                TextSpan(
                  text: widget.phoneNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPInputSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => _buildOTPField(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _otpControllers[index].text.isNotEmpty
              ? AppColors.primaryTeal
              : AppColors.getSurfaceColor(context),
          width: 2,
        ),
        boxShadow: _otpControllers[index].text.isNotEmpty
            ? [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.getPrimaryTextColor(context),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) => _handleOTPInput(value, index),
        onTap: () {
          if (_otpControllers[index].text.isNotEmpty) {
            _otpControllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _otpControllers[index].text.length),
            );
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _otpCode.length == 4
            ? AppColors.getPrimaryGradient(context)
            : LinearGradient(
                colors: [
                  AppColors.getSecondaryTextColor(context).withOpacity(0.3),
                  AppColors.getSecondaryTextColor(context).withOpacity(0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: _otpCode.length == 4
            ? [
                BoxShadow(
                  color: AppColors.primaryTeal.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: (_isLoading || _otpCode.length != 4) ? null : _handleVerifyOTP,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.checkCircle,
                        color: _otpCode.length == 4
                            ? Colors.white
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Verify Code',
                        style: TextStyle(
                          color: _otpCode.length == 4
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          Text(
            'Didn\'t receive the code?',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getSecondaryTextColor(context),
            ),
          ),
          const SizedBox(height: 16),
          if (_canResend)
            GestureDetector(
              onTap: _handleResendOTP,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryTeal.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.refreshCw,
                      color: AppColors.primaryTeal,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Resend Code',
                      style: TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.getSecondaryTextColor(
                  context,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.clock,
                    color: AppColors.getSecondaryTextColor(context),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Resend in ${_resendCountdown}s',
                    style: TextStyle(
                      color: AppColors.getSecondaryTextColor(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
