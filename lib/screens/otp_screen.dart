import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:yoweme/main.dart';
import 'package:yoweme/screens/otp_verification_screen.dart';
import '../core/utils/constants/colors.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isBiometricLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _scaleController;
  late Animation<double> _biometricScaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _biometricScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleSendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      HapticFeedback.mediumImpact();

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OTP sent to your phone!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationScreen(phoneNumber: _phoneController.text),
          ),
        );
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isAuthenticated = false;

    setState(() => _isBiometricLoading = true);

    try {
      if (canCheckBiometrics) {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'يرجى التحقق من البصمة للدخول',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "البصمة غير مدعومة على هذا الجهاز");
      }

      if (isAuthenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      } else {
        Fluttertoast.showToast(msg: "فشل التحقق بالبصمة");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "حدث خطأ: $e");
    } finally {
      setState(() => _isBiometricLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome to YOweMe',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your phone number to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: LucideIcons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\+?[1-9]\d{1,14}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildSendOTPButton(),
                          const SizedBox(height: 24),
                          AnimatedBuilder(
                            animation: _biometricScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _biometricScaleAnimation.value,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.primaryText.withOpacity(0.1),
                                          AppColors.neutralBlue.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.primaryText.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                                  width: 70,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                      colors: [
                                                        AppColors.primaryText,
                                                        AppColors.neutralBlue,
                                                      ],
                                                    ),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors.primaryText
                                                            .withOpacity(0.3),
                                                        blurRadius: 15,
                                                        offset: const Offset(0, 6),
                                                      ),
                                                    ],
                                                  ),
                                                  child: _isBiometricLoading
                                                      ? const Center(
                                                          child: CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.fingerprint,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'تسجيل دخول سريع',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.positiveGreen,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'اضغط لتسجيل الدخول بالبصمة',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.primaryText,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryTeal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelStyle: TextStyle(color: AppColors.secondaryText),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSendOTPButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _isLoading ? null : _handleSendOTP,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                : const Text(
                    'Send OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
