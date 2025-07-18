// lib/features/auth/presentation/view/widgets/name_input_step.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../l10n/localization_extension.dart';
import '../../../../../l10n/rtl_helpers.dart';

class NameInputStep extends StatefulWidget {
  final TextEditingController nameController;
  final AuthCubit authCubit;
  final bool isLoading;
  final Function(String) onNameChanged;
  final VoidCallback onContinue;
  final VoidCallback onGoBack;

  const NameInputStep({
    super.key,
    required this.nameController,
    required this.authCubit,
    required this.isLoading,
    required this.onNameChanged,
    required this.onContinue,
    required this.onGoBack,
  });

  @override
  State<NameInputStep> createState() => _NameInputStepState();
}

class _NameInputStepState extends State<NameInputStep> {
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_validateName);
    super.dispose();
  }

  void _validateName() {
    final name = widget.nameController.text.trim();
    final isValid = name.length >= 2;
    
    if (_isNameValid != isValid) {
      setState(() {
        _isNameValid = isValid;
      });
    }
    
    widget.onNameChanged(name);
  }

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
                    "Welcome to Fawtara!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor(context),
                    ),
                    textAlign: context.startAlign,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter your name to complete your account setup.",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.subtitleColor(context, opacity: 0.7),
                      height: 1.5,
                    ),
                    textAlign: context.startAlign,
                  ),
                  const SizedBox(height: 32),
                  
                  // Name input field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor(context, opacity: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isNameValid
                            ? AppColors.primaryGreen
                            : AppColors.borderColor(context, opacity: 0.2),
                        width: _isNameValid ? 2 : 1,
                      ),
                    ),
                    child: TextField(
                      controller: widget.nameController,
                      textAlign: context.startAlign,
                      style: TextStyle(
                        color: AppColors.textColor(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        hintStyle: TextStyle(
                          color: AppColors.subtitleColor(context, opacity: 0.5),
                          fontSize: 16,
                        ),
                        suffixIcon: _isNameValid
                            ? Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\u0600-\u06FF\s]')),
                      ],
                      onSubmitted: (_) {
                        if (_isNameValid) {
                          widget.onContinue();
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Helper text
                  Text(
                    "This name will be displayed on your invoices and documents.",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.subtitleColor(context, opacity: 0.6),
                    ),
                    textAlign: context.startAlign,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Back button
                  Center(
                    child: TextButton(
                      onPressed: widget.isLoading ? null : widget.onGoBack,
                      child: RTLAwareRow(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RTLAwareIcon(
                            icon: Icons.arrow_back_ios,
                            color: AppColors.primaryBlue.withOpacity(0.8),
                            size: 16,
                            shouldFlip: true,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Back to verification",
                            style: TextStyle(
                              color: AppColors.primaryBlue.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Continue button
        Container(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : (_isNameValid ? widget.onContinue : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isNameValid
                    ? AppColors.primaryGreen
                    : AppColors.surfaceColor(context, opacity: 0.2),
                foregroundColor: _isNameValid
                    ? Colors.white
                    : AppColors.textColor(context).withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: _isNameValid ? 3 : 0,
                shadowColor: _isNameValid
                    ? AppColors.primaryGreen.withOpacity(0.3)
                    : null,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : RTLAwareRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _isNameValid
                                ? Colors.white
                                : AppColors.textColor(context).withOpacity(0.5),
                          ),
                        ),
                        if (_isNameValid) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}