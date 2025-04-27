import 'package:iron_fit/componants/Styles.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'create_meal_model.dart';
export 'create_meal_model.dart';

class CreateMealWidget extends StatefulWidget {
  /// create component for create meal that has name and description.
  const CreateMealWidget({super.key});

  @override
  State<CreateMealWidget> createState() => _CreateMealWidgetState();
}

class _CreateMealWidgetState extends State<CreateMealWidget> {
  late CreateMealModel _model;
  final _formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateMealModel());
    _initializeControllers();
  }

  void _initializeControllers() {
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  // Static constants for reusable widgets to avoid unnecessary rebuilds
  static const _sizedBox8 = SizedBox(height: 8);
  static const _sizedBox20 = SizedBox(height: 20.0);
  static const _sizedBox4 = SizedBox(height: 4.0);
  static const _divider = Divider(height: 24);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8.0,
                color: Color(0x29000000),
                offset: Offset(0.0, 2.0),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  _sizedBox20,
                  _buildMealNameField(context),
                  _sizedBox20,
                  _buildDescriptionField(context),
                  _sizedBox8,
                  _buildCreateMealButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              FFLocalizations.of(context).getText(
                '8ia30fhi' /* Create New Meal */,
              ),
              style: AppStyles.textCairo(
                context,
                fontSize: 18,
                fontWeight: FontWeight.w700,
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
        ),
        _divider,
      ],
    );
  }

  Widget _buildMealNameField(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
          child: Text(
            FFLocalizations.of(context).getText(
              'gjl6p81h' /* Meal Name */,
            ),
            style: AppStyles.textCairo(
              context,
            ),
          ),
        ),
        _sizedBox4,
        TextFormField(
          onTap: () {
            // Move cursor to end of text
            _model.textController1!.selection = TextSelection.fromPosition(
              TextPosition(offset: _model.textController1!.text.length),
            );
          },
          controller: _model.textController1,
          focusNode: _model.textFieldFocusNode1,
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          obscureText: false,
          decoration: InputDecoration(
            labelText:
                FFLocalizations.of(context).getText('gjl6p81h' /* Meal Name */),
            hintText:
                FFLocalizations.of(context).getText('sp6604fg' /* Breakfast */),
            prefixIcon: const Icon(Icons.restaurant_menu),
            hintStyle: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
          ),
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
          ),
          minLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return FFLocalizations.of(context).getText('thisFieldIsRequired');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
          child: Text(
            FFLocalizations.of(context).getText(
              'vcre8yrp' /* Description */,
            ),
            style: AppStyles.textCairo(
              context,
            ),
          ),
        ),
        _sizedBox4,
        TextFormField(
          onTap: () {
            // Move cursor to end of text
            _model.textController2!.selection = TextSelection.fromPosition(
              TextPosition(offset: _model.textController2!.text.length),
            );
          },
          controller: _model.textController2,
          focusNode: _model.textFieldFocusNode2,
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          obscureText: false,
          decoration: InputDecoration(
            labelText: FFLocalizations.of(context)
                .getText('vcre8yrp' /* Description */),
            hintText: FFLocalizations.of(context)
                .getText('ddf60crs' /* One loaf of bread... */),
            prefixIcon: const Icon(Icons.description),
            hintStyle: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0x00000000),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
          ),
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
          ),
          maxLines: 5,
          minLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return FFLocalizations.of(context).getText('thisFieldIsRequired');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCreateMealButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Navigator.pop(
              context,
              MealStruct(
                name: _model.textController1.text,
                desc: _model.textController2.text,
              ));
        }
      },
      text: FFLocalizations.of(context).getText(
        'fag7uot9' /* Create Meal */,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 56.0,
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: FlutterFlowTheme.of(context).info,
        ),
        elevation: 2.0,
        borderRadius: BorderRadius.circular(28.0),
      ),
    );
  }
}
