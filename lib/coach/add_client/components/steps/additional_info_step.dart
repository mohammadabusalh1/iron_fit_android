import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';
import '/widgets/build_text_filed.dart';
import '../../add_client_model.dart';

class AdditionalInfoStep extends StatelessWidget {
  final AddClientModel model;
  final bool isFirstStep;

  const AdditionalInfoStep({
    super.key,
    required this.model,
    required this.isFirstStep,
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
            FFLocalizations.of(context).getText('c11xb84v'),
            style: AppStyles.textCairo(
              context,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            FFLocalizations.of(context).getText('client_more_desc'),
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
            _buildPaidField(context),
            const SizedBox(height: 12),
            _buildDebtsField(context),
          ] else ...[
            _buildNotesField(context),
          ],
        ],
      ),
    );
  }

  Widget _buildPaidField(BuildContext context) {
    return buildTextField(
      keyboardType: TextInputType.number,
      controller: model.paidTextController,
      focusNode: model.paidFocusNode,
      context: context,
      hintText: FFLocalizations.of(context).getText('aigyqqsb'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return FFLocalizations.of(context)
              .getText('error_paid_amount_required');
        }
        if (double.tryParse(value) == null) {
          return FFLocalizations.of(context)
              .getText('error_invalid_paid_amount');
        }
        if (double.parse(value) < 0) {
          return FFLocalizations.of(context).getText('error_negative_number');
        }
        return null;
      },
      labelText: FFLocalizations.of(context).getText('s3kxq2nc'),
      prefixIcon: Icons.attach_money,
      // onTap: () {
      //   // Move cursor to end of text
      //   model.paidTextController.selection = TextSelection.fromPosition(
      //     TextPosition(offset: model.paidTextController.text.length),
      //   );
      // },
    );
  }

  Widget _buildDebtsField(BuildContext context) {
    return buildTextField(
      keyboardType: TextInputType.number,
      controller: model.debtsTextController,
      focusNode: model.debtsFocusNode,
      context: context,
      hintText: FFLocalizations.of(context).getText('vvgu6u6f'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return FFLocalizations.of(context)
              .getText('error_debts_amount_required');
        }
        if (double.tryParse(value) == null) {
          return FFLocalizations.of(context)
              .getText('error_invalid_debts_amount');
        }
        if (double.parse(value) < 0) {
          return FFLocalizations.of(context).getText('error_negative_number');
        }
        return null;
      },
      labelText: FFLocalizations.of(context).getText('kcmdk6wv'),
      prefixIcon: Icons.money_off,
      // onTap: () {
      //   // Move cursor to end of text
      //   model.debtsTextController.selection = TextSelection.fromPosition(
      //     TextPosition(offset: model.debtsTextController.text.length),
      //   );
      // },
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return buildTextField(
      // onTap: () {
      //   // Move cursor to end of text
      //   model.notesController.selection = TextSelection.fromPosition(
      //     TextPosition(offset: model.notesController.text.length),
      //   );
      // },
      controller: model.notesController,
      focusNode: model.notesFocusNode,
      context: context,
      hintText: FFLocalizations.of(context).getText('notes_hint'),
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        return null;
      },
      labelText: FFLocalizations.of(context).getText('notes'),
      prefixIcon: Icons.description_outlined,
      maxLines: 3,
    );
  }
}
