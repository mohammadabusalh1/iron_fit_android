import 'package:iron_fit/componants/Styles.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'select_sets_model.dart';
export 'select_sets_model.dart';
import '/utils/responsive_utils.dart';

class SelectSetsWidget extends StatefulWidget {
  const SelectSetsWidget({
    super.key,
    this.initialSets,
    this.initialReps,
    this.initialTime,
    this.timeType,
  });

  final int? initialSets;
  final int? initialReps;
  final int? initialTime;
  final String? timeType;

  @override
  State<SelectSetsWidget> createState() => _SelectSetsWidgetState();
}

class _SelectSetsWidgetState extends State<SelectSetsWidget> {
  late SelectSetsModel _model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const double _padding = 16.0;
  static const double _spacing = 24.0;

  String _selectedInputType = 'reps';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectSetsModel());
    _initializeControllers();
  }

  void _initializeControllers() {
    _model.setsTextController ??= TextEditingController(
      text: widget.initialSets != null ? widget.initialSets.toString() : '',
    );
    _model.setsFocusNode ??= FocusNode();

    _model.repsTextController ??= TextEditingController(
      text: widget.initialReps != null ? widget.initialReps.toString() : '',
    );
    _model.repsFocusNode ??= FocusNode();

    _model.timeTextController ??= TextEditingController(
      text: widget.initialTime != null ? widget.initialTime.toString() : '',
    );
    _model.timeFocusNode ??= FocusNode();

    // Set initial input type based on whether time or reps was provided
    if (widget.initialTime != null && widget.initialTime! > 0) {
      _selectedInputType = widget.timeType == 's' ? 'timeSeconds' : 'time';
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _updateInputType(String value) {
    setState(() => _selectedInputType = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveUtils.height(context, 350),
      decoration: _buildContainerDecoration(context),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                _buildInputFields(context),
                _buildSubmitButton(context),
              ].divide(SizedBox(height: ResponsiveUtils.height(context, _spacing))),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: FlutterFlowTheme.of(context).secondaryBackground,
      borderRadius: BorderRadius.circular(12.0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FFLocalizations.of(context).getText('odal1r8y'),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 18),
            fontWeight: FontWeight.w600,
          ),
        ),
        closeButton(),
      ],
    );
  }

  Widget _buildInputFields(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final fieldWidth = screenWidth / 2 - ResponsiveUtils.width(context, 36);

    return Column(
      children: [
        _buildInputTypeSelector(),
        SizedBox(height: ResponsiveUtils.height(context, _spacing)),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            numberFiled(
              width: fieldWidth,
              label: FFLocalizations.of(context).getText('7eljwytw'),
              controller: _model.setsTextController!,
              focusNode: _model.setsFocusNode!,
              hintText: '4',
              validator: _validateNumber,
            ),
            if (_selectedInputType == 'reps')
              numberFiled(
                width: fieldWidth,
                label: FFLocalizations.of(context).getText('wkyczine'),
                controller: _model.repsTextController!,
                focusNode: _model.repsFocusNode!,
                hintText: '12',
                validator: _validateNumber,
              ),
            if (_selectedInputType == 'time' ||
                _selectedInputType == 'timeSeconds')
              numberFiled(
                width: fieldWidth,
                label: _selectedInputType == 'time'
                    ? FFLocalizations.of(context).getText('time')
                    : FFLocalizations.of(context).getText('time_seconds'),
                controller: _model.timeTextController!,
                focusNode: _model.timeFocusNode!,
                hintText: '2',
                validator: _validateNumber,
              ),
          ].divide(SizedBox(width: ResponsiveUtils.width(context, _padding))),
        ),
      ],
    );
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return FFLocalizations.of(context).getText('please_enter_a_value');
    }
    if (int.tryParse(value) == null) {
      return FFLocalizations.of(context).getText('invalid');
    }
    if (int.tryParse(value)! <= 0) {
      return FFLocalizations.of(context).getText('invalid');
    }
    if (int.tryParse(value)! > 10000) {
      return FFLocalizations.of(context)
          .getText('please_enter_a_number_less_than_100');
    }
    return null;
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FFButtonWidget(
          onPressed: _handleSubmit,
          text: FFLocalizations.of(context).getText('0p2fuvxm'),
          options: FFButtonOptions(
            width: ResponsiveUtils.width(context, 150.0),
            height: ResponsiveUtils.height(context, 40.0),
            padding: EdgeInsetsDirectional.symmetric(horizontal: ResponsiveUtils.width(context, 16)),
            iconPadding: EdgeInsets.zero,
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairoButton(ResponsiveUtils.fontSize(context, 16.0)),
            elevation: 0.0,
            borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ].divide(SizedBox(width: ResponsiveUtils.width(context, 12.0))),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      SetStruct(
        sets: int.tryParse(_model.setsTextController.text),
        reps: _selectedInputType == 'reps'
            ? int.tryParse(_model.repsTextController.text)
            : null,
        time:
            _selectedInputType == 'time' || _selectedInputType == 'timeSeconds'
                ? int.tryParse(_model.timeTextController.text)
                : null,
        timeType: _selectedInputType == 'timeSeconds' ? 's' : 'm',
      ),
    );
  }

  Widget closeButton() {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.safePop(),
      child: Icon(
        Icons.close,
        color: FlutterFlowTheme.of(context).primaryText,
        size: ResponsiveUtils.iconSize(context, 24.0),
      ),
    );
  }

  Widget numberFiled({
    label,
    controller,
    focusNode,
    hintText,
    validator,
    width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  letterSpacing: 0.0,
                ),
          ),
          TextFormField(
            onTap: () {
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            },
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            obscureText: false,
            decoration: _buildInputDecoration(hintText),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                ),
            minLines: 1,
            keyboardType: TextInputType.number,
            validator: validator,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    const borderRadius = 8.0;

    return InputDecoration(
      hintText: FFLocalizations.of(context).getText(hintText),
      hintStyle: FlutterFlowTheme.of(context).labelSmall.override(
            fontFamily: 'Inter',
            fontSize: ResponsiveUtils.fontSize(context, 12),
            letterSpacing: 0.0,
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.8),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.width(context, 10),
        vertical: ResponsiveUtils.height(context, 12),
      ),
    );
  }

  Widget _buildInputTypeSelector() {
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<String>(
              value: 'reps',
              groupValue: _selectedInputType,
              onChanged: (value) => _updateInputType(value!),
            ),
            Text(FFLocalizations.of(context).getText('wkyczine'),
                style: AppStyles.textCairo(
                  context, 
                  fontSize: ResponsiveUtils.fontSize(context, 14)
                )),
          ],
        ),
        SizedBox(width: ResponsiveUtils.width(context, 20)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<String>(
              value: 'time',
              groupValue: _selectedInputType,
              onChanged: (value) => _updateInputType(value!),
            ),
            Text(FFLocalizations.of(context).getText('time'),
                style: AppStyles.textCairo(
                  context, 
                  fontSize: ResponsiveUtils.fontSize(context, 14)
                )),
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Radio<String>(
              value: 'timeSeconds',
              groupValue: _selectedInputType,
              onChanged: (value) => _updateInputType(value!),
            ),
            Text(FFLocalizations.of(context).getText('time_seconds'),
                style: AppStyles.textCairo(
                  context, 
                  fontSize: ResponsiveUtils.fontSize(context, 14)
                )),
          ],
        ),
      ],
    );
  }
}
