import 'package:iron_fit/componants/Styles.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'add_debts_model.dart';
export 'add_debts_model.dart';

class AddDebtsWidget extends StatefulWidget {
  const AddDebtsWidget({
    super.key,
    this.isDebtRemoval = false,
  });

  final bool isDebtRemoval;

  @override
  State<AddDebtsWidget> createState() => _AddDebtsWidgetState();
}

class _AddDebtsWidgetState extends State<AddDebtsWidget> {
  late AddDebtsModel _model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddDebtsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                DebtTitleInputField(model: _model),
                DebtInputField(model: _model),
                _buildSaveButton(context),
              ].divide(const SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FFLocalizations.of(context).getText('sc2jlg7l' /* Edit  Debt */),
          style: AppStyles.textCairo(
            context,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.safePop();
          },
          child: Icon(
            Icons.close,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FFButtonWidget(
          onPressed: () async {
            if (_formKey.currentState == null ||
                !_formKey.currentState!.validate()) {
              return;
            }
            Navigator.pop(context, {
              'debt': double.tryParse(
                  _model.debtValueController?.text.replaceAll(',', '') ?? '0'),
              'title': _model.debtTitleController?.text ?? ''
            });
          },
          text: FFLocalizations.of(context).getText(
            'apqx7rpg' /* Save */,
          ),
          options: FFButtonOptions(
            width: 100.0,
            height: 40.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(
              context,
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).info,
            ),
            elevation: 0.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ].divide(const SizedBox(width: 12.0)),
    );
  }
}

class DebtTitleInputField extends StatelessWidget {
  const DebtTitleInputField({
    super.key,
    required this.model,
  });

  final AddDebtsModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
          child: Text(
            FFLocalizations.of(context).getText('debt_title' /* Debt Title */),
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          // onTap: () {
          //   // Move cursor to end of text
          //   model.debtTitleController!.selection = TextSelection.fromPosition(
          //     TextPosition(offset: model.debtTitleController.text.length),
          //   );
          // },
          controller: model.debtTitleController,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            model.debtValueFocusNode?.requestFocus();
          },
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Icon(
                Icons.title,
                size: 24,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: FFLocalizations.of(context)
                .getText('enter_debt_title' /* 50 */),
            hintStyle: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          ),
          style: AppStyles.textCairo(context, fontSize: 16),
          textAlign: TextAlign.start,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return FFLocalizations.of(context)
                  .getText('enter_debt_title' /* Enter Debt Title */);
            }
            return null;
          },
        ),
      ],
    );
  }
}

class DebtInputField extends StatelessWidget {
  const DebtInputField({
    super.key,
    required this.model,
  });

  final AddDebtsModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
          child: Text(
            FFLocalizations.of(context).getText('enkjrdua' /* Debt */),
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          // onTap: () {
          //   // Move cursor to end of text
          //   model.debtTextController!.selection = TextSelection.fromPosition(
          //     TextPosition(offset: model.debtTextController.text.length),
          //   );
          // },
          controller: model.debtValueController,
          focusNode: model.debtValueFocusNode,
          obscureText: false,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
              child: Text(
                '\$',
                style: AppStyles.textCairo(
                  context,
                  fontSize: 18,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: FFLocalizations.of(context).getText('n51nli3x' /* 50 */),
            hintStyle: FlutterFlowTheme.of(context).labelSmall,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
          ),
          style: AppStyles.textCairo(context, fontSize: 16),
          textAlign: TextAlign.start,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return FFLocalizations.of(context).getText('enter_amount');
            }
            final parsedValue = value.replaceAll(',', '');
            if (double.tryParse(parsedValue) == null) {
              return FFLocalizations.of(context)
                  .getText('pleaseEnterAValidNumber');
            }
            final doubleValue = double.parse(parsedValue);
            if (doubleValue < 0) {
              return FFLocalizations.of(context)
                  .getText('error_invalid_number');
            }
            if (doubleValue > 10000) {
              return FFLocalizations.of(context).getText('value_too_high');
            }
            return null;
          },
        ),
      ],
    );
  }
}
