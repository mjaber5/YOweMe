import 'package:fawtara/features/auth/presentation/view/widgets/otp_input_field.dart';
import 'package:flutter/material.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../l10n/localization_extension.dart';
import '../../../../../l10n/rtl_helpers.dart';
import 'auth_button.dart';

class OtpVerificationStep extends StatelessWidget {
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final AuthCubit authCubit;
  final bool isLoading;
  final Function(String, int) onOtpChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onGoBack;

  const OtpVerificationStep({
    super.key,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.authCubit,
    required this.isLoading,
    required this.onOtpChanged,
    required this.onVerify,
    required this.onResend,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.enterVerificationCode,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor(context),
                    ),
                    textAlign: context.startAlign,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: context.startAlign,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.subtitleColor(context, opacity: 0.7),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: '${context.l10n.otpSentTo} '),
                        TextSpan(
                          text: authCubit.phoneNumber,
                          style: TextStyle(
                            color: AppColors.textColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  RTLAwareRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return OtpInputField(
                        controller: otpControllers[index],
                        focusNode: otpFocusNodes[index],
                        index: index,
                        onChanged: onOtpChanged,
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        _buildResendButton(context),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: isLoading ? null : onGoBack,
                          child: Text(
                            context.l10n.wrongNumber,
                            style: TextStyle(
                              color: AppColors.primaryBlue.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AuthButton(
          text: context.l10n.verifyAndContinue,
          onPressed: onVerify,
          isLoading: isLoading,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          isEnabled: true,
        ),
      ],
    );
  }

  Widget _buildResendButton(BuildContext context) {
    if (authCubit.canResendOtp) {
      // Show normal resend button when timer is finished
      return TextButton(
        onPressed: isLoading ? null : onResend,
        child: Text(
          context.l10n.didntReceiveCode,
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      // Show disabled button with timer when countdown is active
      return TextButton(
        onPressed: null, // Disabled during countdown
        child: Text(
          'Resend code in ${_formatTime(authCubit.resendCountdown)}',
          style: TextStyle(
            color: AppColors.subtitleColor(context, opacity: 0.5),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds.toString().padLeft(2, '0')}s';
    } else {
      return '${remainingSeconds}s';
    }
  }
}