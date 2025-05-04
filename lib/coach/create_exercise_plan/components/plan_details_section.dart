import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';

class PlanDetailsSection extends StatelessWidget {
  final TextEditingController planNameController;
  final FocusNode planNameFocusNode;
  final TextEditingController descController;
  final FocusNode descFocusNode;

  const PlanDetailsSection({
    super.key,
    required this.planNameController,
    required this.planNameFocusNode,
    required this.descController,
    required this.descFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context).black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 8)),
                  Text(
                    FFLocalizations.of(context)
                        .getText('itpi07oi' /* Plan Details */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              _buildTextFormField(
                onTap: () {
                  // Move cursor to end of text
                  planNameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: planNameController.text.length),
                  );
                },
                context,
                controller: planNameController,
                focusNode: planNameFocusNode,
                labelText: FFLocalizations.of(context)
                    .getText('aj70rhi0' /* Plan Name */),
                hintText:
                    FFLocalizations.of(context).getText('enter_plan_name'),
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: ResponsiveUtils.iconSize(context, 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FFLocalizations.of(context)
                        .getText('pleaseEnterPlanName');
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              _buildTextFormField(
                onTap: () {
                  // Move cursor to end of text
                  descController.selection = TextSelection.fromPosition(
                    TextPosition(offset: descController.text.length),
                  );
                },
                context,
                controller: descController,
                focusNode: descFocusNode,
                labelText: FFLocalizations.of(context)
                    .getText('kac6c4m1' /* Description */),
                hintText: FFLocalizations.of(context)
                    .getText('enter_plan_description'),
                prefixIcon: Icon(
                  Icons.description_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: ResponsiveUtils.iconSize(context, 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FFLocalizations.of(context)
                        .getText('enter_plan_description');
                  }
                  return null;
                },
                maxLines: 3,
                minLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    BuildContext context, {
    VoidCallback? onTap,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required String? Function(String?)? validator,
    Widget? prefixIcon,
    int? maxLines,
    int? minLines,
    String? hintText,
  }) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      obscureText: false,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 14),
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
        hintText: hintText,
        hintStyle: AppStyles.textCairo(context,
            fontSize: ResponsiveUtils.fontSize(context, 12), 
            color: FlutterFlowTheme.of(context).secondaryText),
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate.withAlpha(150),
            width: 1.0,
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
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        contentPadding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      ),
      style: AppStyles.textCairo(
        context,
        fontSize: ResponsiveUtils.fontSize(context, 16),
        color: FlutterFlowTheme.of(context).primaryText,
      ),
      validator: validator,
    );
  }
}
