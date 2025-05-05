import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

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
  static Widget _sizedBox8(BuildContext context) =>
      SizedBox(height: ResponsiveUtils.height(context, 24));
  static Widget _sizedBox20(BuildContext context) =>
      SizedBox(height: ResponsiveUtils.height(context, 20));
  static Widget _sizedBox4(BuildContext context) =>
      SizedBox(height: ResponsiveUtils.height(context, 4));
  static const _divider = Divider(height: 24);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: ResponsiveUtils.width(context, 500)),
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
            padding:
                ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  _sizedBox20(context),
                  _buildMealNameField(context),
                  _sizedBox20(context),
                  _buildDescriptionField(context),
                  _sizedBox8(context),
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
                fontSize: ResponsiveUtils.fontSize(context, 18),
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
                size: ResponsiveUtils.iconSize(context, 24.0),
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
          padding: EdgeInsetsDirectional.fromSTEB(
              0.0, 0.0, 0.0, ResponsiveUtils.height(context, 4.0)),
          child: Text(
            FFLocalizations.of(context).getText(
              'gjl6p81h' /* Meal Name */,
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ),
        _sizedBox4(context),
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
            prefixIcon: Icon(
              Icons.restaurant_menu,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            hintStyle: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: ResponsiveUtils.fontSize(context, 14),
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
            contentPadding:
                ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
          ),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
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
          padding: EdgeInsetsDirectional.fromSTEB(
              0.0, 0.0, 0.0, ResponsiveUtils.height(context, 4.0)),
          child: Text(
            FFLocalizations.of(context).getText(
              'vcre8yrp' /* Description */,
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
            ),
          ),
        ),
        _sizedBox4(context),
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
            prefixIcon: Icon(
              Icons.description,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            hintStyle: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 12),
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
            contentPadding:
                ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
          ),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
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
        height: ResponsiveUtils.height(context, 56.0),
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 18),
          fontWeight: FontWeight.w700,
          color: FlutterFlowTheme.of(context).info,
        ),
        elevation: 2.0,
        borderRadius: BorderRadius.circular(28.0),
      ),
    );
  }
}
