import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../l10n/localization_extension.dart';
import '../../../../../l10n/rtl_helpers.dart';

class PhoneInputStep extends StatelessWidget {
  final TextEditingController phoneController;
  final AuthCubit authCubit;
  final bool isLoading;
  final Function(String) onPhoneChanged;
  final VoidCallback onContinue;

  const PhoneInputStep({
    super.key,
    required this.phoneController,
    required this.authCubit,
    required this.isLoading,
    required this.onPhoneChanged,
    required this.onContinue,
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
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.enterYourPhoneNumber,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor(context),
                    ),
                    textAlign: context.startAlign,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.phoneVerificationDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.subtitleColor(context, opacity: 0.7),
                      height: 1.5,
                    ),
                    textAlign: context.startAlign,
                  ),
                  const SizedBox(height: 32),
                  IntlPhoneField(
                    cursorColor: AppColors.textColor(context),
                    controller: phoneController,
                    textAlign: context.startAlign,
                    decoration: InputDecoration(
                      hintText: context.l10n.enterPhoneNumberPlaceholder,
                      hintStyle: TextStyle(
                        color: AppColors.subtitleColor(context, opacity: 0.5),
                        fontSize: 16,
                      ),
                      suffixIcon:
                          authCubit.isPhoneValid
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
                      filled: true,
                      fillColor: AppColors.surfaceColor(context, opacity: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.borderColor(context, opacity: 0.2),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.borderColor(context, opacity: 0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color:
                              authCubit.isPhoneValid
                                  ? AppColors.primaryBlue
                                  : AppColors.borderColor(
                                    context,
                                    opacity: 0.4,
                                  ),
                          width: authCubit.isPhoneValid ? 2 : 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    style: TextStyle(
                      color: AppColors.textColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    flagsButtonPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    flagsButtonMargin: const EdgeInsets.only(right: 8),
                    showCountryFlag: true,
                    showDropdownIcon: true,
                    dropdownIconPosition: IconPosition.trailing,
                    dropdownIcon: Icon(
                      Icons.expand_more,
                      color: AppColors.iconColor(context, opacity: 0.8),
                      size: 20,
                    ),
                    dropdownTextStyle: TextStyle(
                      color: AppColors.textColor(context),
                      fontSize: 16,
                    ),
                    pickerDialogStyle: PickerDialogStyle(
                      backgroundColor: AppColors.backgroundColor(context),
                      searchFieldInputDecoration: InputDecoration(
                        hintText: context.l10n.searchCountries,
                        hintStyle: TextStyle(
                          color: AppColors.subtitleColor(context, opacity: 0.5),
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.iconColor(context, opacity: 0.7),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceColor(
                          context,
                          opacity: 0.08,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderColor(context, opacity: 0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderColor(context, opacity: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                      searchFieldCursorColor: AppColors.primaryBlue,
                      countryCodeStyle: TextStyle(
                        color: AppColors.textColor(context),
                        fontSize: 16,
                      ),
                      countryNameStyle: TextStyle(
                        color: AppColors.textColor(context).withOpacity(0.9),
                        fontSize: 16,
                      ),
                      listTileDivider: Divider(
                        color: AppColors.borderColor(context, opacity: 0.1),
                        height: 1,
                      ),
                      listTilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                    initialCountryCode: 'JO',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    invalidNumberMessage: null,
                    disableLengthCheck: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    onChanged: (phone) {
                      onPhoneChanged(phone.completeNumber);
                    },
                    onSubmitted: (_) {
                      if (authCubit.isPhoneValid) {
                        onContinue();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : (authCubit.isPhoneValid ? onContinue : null),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    authCubit.isPhoneValid
                        ? AppColors.primaryBlue
                        : AppColors.surfaceColor(context, opacity: 0.2),
                foregroundColor:
                    authCubit.isPhoneValid
                        ? Colors.white
                        : AppColors.textColor(context).withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: authCubit.isPhoneValid ? 3 : 0,
                shadowColor:
                    authCubit.isPhoneValid
                        ? AppColors.primaryBlue.withOpacity(0.3)
                        : null,
              ),
              child:
                  isLoading
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
                            context.l10n.continueButton,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color:
                                  authCubit.isPhoneValid
                                      ? Colors.white
                                      : AppColors.textColor(
                                        context,
                                      ).withOpacity(0.5),
                            ),
                          ),
                          if (authCubit.isPhoneValid) ...[
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
