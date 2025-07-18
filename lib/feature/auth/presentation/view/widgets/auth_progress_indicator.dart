// lib/features/auth/presentation/view/widgets/auth_progress_indicator.dart
import 'package:flutter/material.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../l10n/rtl_helpers.dart';

class AuthProgressIndicator extends StatelessWidget {
  final AuthCubit authCubit;

  const AuthProgressIndicator({
    super.key,
    required this.authCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: RTLAwareRow(
        children: [
          // Step 1: Phone
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Step 2: OTP
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: authCubit.currentStep == AuthStep.phone
                    ? AppColors.borderColor(context, opacity: 0.3)
                    : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Step 3: Name (conditional)
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: authCubit.currentStep == AuthStep.name
                    ? AppColors.primaryGreen
                    : AppColors.borderColor(context, opacity: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}