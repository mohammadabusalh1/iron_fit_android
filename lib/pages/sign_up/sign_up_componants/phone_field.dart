import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextEditingController countryCodeController;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Function(String)? onFieldSubmitted;

  const PhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.countryCodeController,
    required this.fadeAnimation,
    required this.slideAnimation,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntlPhoneField(
                cursorColor: FlutterFlowTheme.of(context).primary,
                pickerDialogStyle: PickerDialogStyle(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  countryCodeStyle: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: onFieldSubmitted,
                key: const Key('sign_up_phone'),
                controller: controller,
                focusNode: focusNode,
                languageCode: FFLocalizations.of(context).languageCode,
                dropdownDecoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2)),
                  ],
                ),
                decoration: InputDecoration(
                  labelText: FFLocalizations.of(context).getText('phone'),
                  hintText: FFLocalizations.of(context).getText('phone'),
                  hintStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                dropdownTextStyle: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                initialCountryCode: 'PS',
                onChanged: (phone) {
                  countryCodeController.text = phone.countryCode;
                  controller.text = phone.number;
                },
                validator: (value) {
                  if (value == null || value.number.isEmpty) {
                    return FFLocalizations.of(context).getText('phoneRequired');
                  }

                  // Remove any spaces or special characters
                  final cleanNumber =
                      value.number.replaceAll(RegExp(r'[^0-9]'), '');

                  // Check minimum length (usually 9-10 digits without country code)
                  if (cleanNumber.length < 9) {
                    return FFLocalizations.of(context)
                        .getText('phoneNumberTooShort');
                  }

                  // Check maximum length (usually not more than 15 digits with country code)
                  if (cleanNumber.length > 15) {
                    return FFLocalizations.of(context)
                        .getText('phoneNumberTooLong');
                  }

                  // Check if number contains only digits
                  if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
                    return FFLocalizations.of(context)
                        .getText('invalidPhoneNumber');
                  }

                  return null;
                },
                disableLengthCheck:
                    true, // We'll handle length validation ourselves
                showDropdownIcon: true,
                invalidNumberMessage:
                    FFLocalizations.of(context).getText('invalidPhoneNumber'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
