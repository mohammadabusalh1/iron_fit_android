import 'package:flutter/material.dart';
import 'package:iron_fit/coach/add_client/add_client_model.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/widgets/build_text_filed.dart';
import 'package:intl/intl.dart';

class ClientInfoStep extends StatelessWidget {
  final AddClientModel model;
  final bool isFirstStep;
  final Function(String) onStartDateSelected;
  final Function(String) onEndDateSelected;

  const ClientInfoStep({
    super.key,
    required this.model,
    required this.isFirstStep,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildFormFields(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Text(
            FFLocalizations.of(context).getText('client_information'),
            style: AppStyles.textCairo(
              context,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            FFLocalizations.of(context).getText('client_information_desc'),
            textAlign: TextAlign.center,
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFirstStep) ...[
            _buildEmailField(context),
            const SizedBox(height: 16),
            _buildNameField(context),
          ] else ...[
            _buildStartDateField(context),
            const SizedBox(height: 16),
            _buildEndDateField(context),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return buildTextField(
      // onTap: () {
      //   // Move cursor to end of text
      //   model.emailTextController.selection = TextSelection.fromPosition(
      //     TextPosition(offset: model.emailTextController.text.length),
      //   );
      // },
      keyboardType: TextInputType.emailAddress,
      controller: model.emailTextController,
      focusNode: model.emailFocusNode,
      context: context,
      hintText: 'abc@xyz',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return FFLocalizations.of(context).getText('error_email_required');
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return FFLocalizations.of(context).getText('error_invalid_email');
        }
        return null;
      },
      labelText: FFLocalizations.of(context).getText('label_email'),
      prefixIcon: Icons.email_outlined,
    );
  }

  Widget _buildNameField(BuildContext context) {
    return buildTextField(
      // onTap: () {
      //   // Move cursor to end of text
      //   model.nameTextController.selection = TextSelection.fromPosition(
      //     TextPosition(offset: model.nameTextController.text.length),
      //   );
      // },
      controller: model.nameTextController,
      focusNode: model.nameFocusNode,
      context: context,
      hintText: FFLocalizations.of(context).getText('hint_enter_name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return FFLocalizations.of(context).getText('error_name_required');
        }
        return null;
      },
      labelText: FFLocalizations.of(context).getText('ziwjm0v1'),
      prefixIcon: Icons.person_outline,
    );
  }

  Widget _buildStartDateField(BuildContext context) {
    return buildTextField(
      controller: model.startDateTextController,
      focusNode: model.startDateFocusNode,
      labelText: FFLocalizations.of(context).getText('1qacacys'),
      hintText: FFLocalizations.of(context).getText('prqg6mlg'),
      prefixIcon: Icons.calendar_today_rounded,
      readOnly: true,
      onTap: () => onStartDateSelected(model.startDateTextController.text),
      validator: (val) {
        if (val?.isEmpty ?? true) {
          return FFLocalizations.of(context)
              .getText('error_start_date_required');
        }

        // Validate that end date is after start date
        if (model.endDateTextController.text.isNotEmpty) {
          final startDate = DateFormat('yyyy-MM-dd')
              .parse(model.startDateTextController.text);
          final endDate = DateFormat('yyyy-MM-dd').parse(val!);

          if (endDate.isBefore(startDate)) {
            return FFLocalizations.of(context)
                .getText('error_start_before_end');
          }
        }

        return null;
      },
      context: context,
    );
  }

  Widget _buildEndDateField(BuildContext context) {
    return buildTextField(
      controller: model.endDateTextController,
      focusNode: model.endDateFocusNode,
      labelText: FFLocalizations.of(context).getText('r448i96u'),
      hintText: FFLocalizations.of(context).getText('prqg6mlg'),
      prefixIcon: Icons.calendar_today_rounded,
      readOnly: true,
      onTap: () => onEndDateSelected(model.endDateTextController.text),
      validator: (val) {
        if (val?.isEmpty ?? true) {
          return FFLocalizations.of(context).getText('error_end_date_required');
        }

        // Validate that end date is after start date
        if (model.startDateTextController.text.isNotEmpty) {
          final startDate = DateFormat('yyyy-MM-dd')
              .parse(model.startDateTextController.text);
          final endDate = DateFormat('yyyy-MM-dd').parse(val!);

          if (endDate.isBefore(startDate)) {
            return FFLocalizations.of(context)
                .getText('error_start_before_end');
          }
        }

        return null;
      },
      context: context,
    );
  }
}
