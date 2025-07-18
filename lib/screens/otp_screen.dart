// lib/screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoweme/main.dart';
import 'package:yoweme/screens/otp_verification_screen.dart';
import '../core/utils/constants/colors.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  void _changeTheme(ThemeMode themeMode) {
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isBiometricLoading = false;
  bool _isBiometricAvailable = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _biometricController;
  late Animation<double> _biometricScaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _biometricController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _biometricScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _biometricController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _biometricController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics();

      setState(() {
        _isBiometricAvailable =
            canCheckBiometrics && availableBiometrics.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _biometricController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String value) {
    // Remove all non-digit characters
    String cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

    // Add Jordan country code if not present
    if (cleaned.isNotEmpty && !cleaned.startsWith('962')) {
      if (cleaned.startsWith('0')) {
        cleaned = '962${cleaned.substring(1)}';
      } else {
        cleaned = '962$cleaned';
      }
    }

    // Format: +962 X XXXX XXXX
    if (cleaned.length >= 3) {
      String formatted = '+${cleaned.substring(0, 3)}';
      if (cleaned.length > 3) {
        formatted +=
            ' ${cleaned.substring(3, cleaned.length > 4 ? 4 : cleaned.length)}';
      }
      if (cleaned.length > 4) {
        formatted +=
            ' ${cleaned.substring(4, cleaned.length > 8 ? 8 : cleaned.length)}';
      }
      if (cleaned.length > 8) {
        formatted +=
            ' ${cleaned.substring(8, cleaned.length > 12 ? 12 : cleaned.length)}';
      }
      return formatted;
    }

    return cleaned.isNotEmpty ? '+$cleaned' : '';
  }

  void _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.mediumImpact();

      try {
        // Simulate API call delay
        await Future.delayed(const Duration(milliseconds: 1500));

        // Store phone number for later use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('phoneNumber', _phoneController.text);

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
                          'OTP Sent Successfully!',
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
              backgroundColor: AppColors.positiveGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 4),
            ),
          );

          // Navigate to verification screen
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  OTPVerificationScreen(phoneNumber: _phoneController.text),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
                      ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showErrorSnackBar('Failed to send OTP. Please try again.');
        }
      }
    }
  }

  void _handleBiometricLogin() async {
    if (!_isBiometricAvailable) {
      _showErrorSnackBar(
        'Biometric authentication is not available on this device',
      );
      return;
    }

    final LocalAuthentication auth = LocalAuthentication();
    setState(() => _isBiometricLoading = true);

    try {
      final bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please verify your identity to access YOweMe',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginMethod', 'biometric');

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(LucideIcons.checkCircle, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Biometric authentication successful!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              backgroundColor: AppColors.positiveGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Navigate to main screen
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MainNavigationScreen(onThemeChanged: _changeTheme),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Biometric authentication failed');
      }
    } catch (e) {
      _showErrorSnackBar('Authentication error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isBiometricLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
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

                    // App Logo/Brand Section
                    _buildBrandHeader(),

                    const SizedBox(height: 40),

                    // Welcome Header
                    _buildWelcomeCard(),

                    const SizedBox(height: 32),

                    // Phone Input Form
                    _buildPhoneInputCard(),

                    const SizedBox(height: 32),

                    // Biometric Authentication (if available)
                    if (_isBiometricAvailable) ...[
                      _buildDivider(),
                      const SizedBox(height: 32),
                      _buildBiometricSection(),
                      const SizedBox(height: 32),
                    ],

                    // Security Info
                    _buildSecurityInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.getPrimaryGradient(context),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(LucideIcons.wallet, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 16),
        Text(
          'YOweMe',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.getPrimaryTextColor(context),
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Smart Expense Splitting',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.getSecondaryTextColor(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.smartphone,
              color: AppColors.primaryTeal,
              size: 24,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your phone number to continue to your account and start managing expenses with friends.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getSecondaryTextColor(context),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInputCard() {
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
              'Phone Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
            const SizedBox(height: 16),
            _buildPhoneTextField(),
            const SizedBox(height: 24),
            _buildSendOTPButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getSurfaceColor(context), width: 1),
      ),
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: AppColors.getPrimaryTextColor(context),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (value) {
          final formatted = _formatPhoneNumber(value);
          if (formatted != value) {
            _phoneController.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        },
        decoration: InputDecoration(
          hintText: '+962 X XXXX XXXX',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.getPrimaryGradient(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.phone, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primaryTeal,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.negativeRed,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.negativeRed,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: TextStyle(
            color: AppColors.getSecondaryTextColor(context),
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }

          // Remove formatting for validation
          String cleaned = value.replaceAll(RegExp(r'[^\d]'), '');

          if (cleaned.length < 12) {
            return 'Please enter a valid Jordanian phone number';
          }

          if (!cleaned.startsWith('962')) {
            return 'Please use Jordanian format (+962)';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildSendOTPButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.getPrimaryGradient(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _handleSendOTP,
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
                      const Icon(
                        LucideIcons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Send Verification Code',
                        style: TextStyle(
                          color: Colors.white,
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.getSecondaryTextColor(context).withOpacity(0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.getSecondaryTextColor(context),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.getSecondaryTextColor(context).withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricSection() {
    return AnimatedBuilder(
      animation: _biometricScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _biometricScaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryTeal.withOpacity(0.08),
                  AppColors.positiveGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primaryTeal.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: GestureDetector(
                        onTap: _isBiometricLoading
                            ? null
                            : _handleBiometricLogin,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryTeal,
                                AppColors.positiveGreen,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryTeal.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _isBiometricLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Icon(
                                  Icons.fingerprint,
                                  size: 36,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Quick Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use your fingerprint or face to sign in securely',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.shield,
              color: AppColors.primaryTeal,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Private',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'We use bank-level security with OTP verification. Your data is encrypted and never shared with third parties.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.getSecondaryTextColor(context),
                    height: 1.4,
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
