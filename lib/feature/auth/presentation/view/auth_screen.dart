// lib/features/auth/presentation/view/auth_screen.dart
import 'package:fawtara/features/auth/presentation/view_model/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../screens/main_screen.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../l10n/localization_extension.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_progress_indicator.dart';
import 'widgets/phone_input_step.dart';
import 'widgets/otp_verification_step.dart';
import 'widgets/name_input_step.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(), 
      child: const _AuthScreenContent(),
    );
  }
}

class _AuthScreenContent extends StatefulWidget {
  const _AuthScreenContent();

  @override
  State<_AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<_AuthScreenContent> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onPhoneChanged(String phoneNumber) {
    context.read<AuthCubit>().validatePhoneNumber(phoneNumber);
  }

  void _goToOtpStep() async {
    FocusScope.of(context).unfocus();
    await context.read<AuthCubit>().sendOtp();
  }

  void _goBackToPhone() {
    context.read<AuthCubit>().goBackToPhone();
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Clear OTP controllers
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  void _goToNameStep() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void _goBackToOtp() {
    context.read<AuthCubit>().goBackToOtp();
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _verifyOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    context.read<AuthCubit>().updateOtp(otp);
    await context.read<AuthCubit>().verifyOtp();
  }

  void _createUser() async {
    final name = _nameController.text.trim();
    await context.read<AuthCubit>().createUser(name);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          context.l10n.error,
          style: TextStyle(
            color: AppColors.textColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.subtitleColor(context, opacity: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().clearError();
            },
            child: Text(
              context.l10n.ok,
              style: const TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    if (index == 3 && value.isNotEmpty) {
      String otp = _otpControllers.map((controller) => controller.text).join();
      if (otp.length == 4) {
        _verifyOtp();
      }
    }
  }

  void _onNameChanged(String name) {
    // Handle name validation if needed
  }

  void _resendOtp() async {
    await context.read<AuthCubit>().resendOtp();
    // Clear OTP controllers after resend
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        } else if (state is AuthError) {
          _showErrorDialog(state.message);
        } else if (state is OtpSentState) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          Future.delayed(const Duration(milliseconds: 300), () {
            _otpFocusNodes[0].requestFocus();
          });
        } else if (state is NameRequiredState) {
          _goToNameStep();
        } else if (state is OtpResentState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.codeResentSuccessfully),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final authCubit = context.read<AuthCubit>();
          final isLoading = state is AuthLoading;
          
          return Scaffold(
            backgroundColor: AppColors.backgroundColor(context),
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const AuthHeader(),
                      AuthProgressIndicator(authCubit: authCubit),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            PhoneInputStep(
                              phoneController: _phoneController,
                              authCubit: authCubit,
                              isLoading: isLoading,
                              onPhoneChanged: _onPhoneChanged,
                              onContinue: _goToOtpStep,
                            ),
                            OtpVerificationStep(
                              otpControllers: _otpControllers,
                              otpFocusNodes: _otpFocusNodes,
                              authCubit: authCubit,
                              isLoading: isLoading,
                              onOtpChanged: _onOtpChanged,
                              onVerify: _verifyOtp,
                              onResend: _resendOtp,
                              onGoBack: _goBackToPhone,
                            ),
                            NameInputStep(
                              nameController: _nameController,
                              authCubit: authCubit,
                              isLoading: isLoading,
                              onNameChanged: _onNameChanged,
                              onContinue: _createUser,
                              onGoBack: _goBackToOtp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}