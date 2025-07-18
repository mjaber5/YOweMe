import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int index;
  final Function(String, int) onChanged;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: controller.text.isNotEmpty
              ? AppColors.primaryBlue
              : AppColors.borderColor(context, opacity: 0.3),
          width: controller.text.isNotEmpty ? 2 : 1,
        ),
        color: AppColors.surfaceColor(context, opacity: 0.08),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor(context),
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          onChanged(value, index);
        },
      ),
    );
  }
}