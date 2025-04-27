import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class FormValidators {
  static String? validateRequired(
      BuildContext context, String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context)
          .getText('error_empty_field')
          .replaceAll('{field}', fieldName);
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context).getText('error_empty_email');
    }
    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
      return FFLocalizations.of(context).getText('error_invalid_email');
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context).getText('error_empty_password');
    }
    if (value.length < 6) {
      return FFLocalizations.of(context).getText('error_password_length');
    }
    return null;
  }

  static String? validateNumeric(
      BuildContext context, String? value, String fieldName,
      {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context)
          .getText('invalid')
          .replaceAll('{field}', fieldName);
    }

    final number = double.tryParse(value);
    if (number == null) {
      return FFLocalizations.of(context)
          .getText('invalidNumber')
          .replaceAll('{field}', fieldName);
    }

    if (min != null && number < min) {
      return FFLocalizations.of(context)
          .getText('invalidNumber')
          .replaceAll('{field}', fieldName)
          .replaceAll('{min}', min.toString());
    }

    if (max != null && number > max) {
      return FFLocalizations.of(context)
          .getText('invalidNumber')
          .replaceAll('{field}', fieldName)
          .replaceAll('{max}', max.toString());
    }
    return null;
  }

  static String? validateDate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context).getText('error_empty');
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return FFLocalizations.of(context).getText('invalid');
    }
  }
}
