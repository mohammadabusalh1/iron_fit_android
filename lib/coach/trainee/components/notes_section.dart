import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A component for managing trainee notes.
class NotesSectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSavePressed;

  const NotesSectionWidget({
    super.key,
    required this.controller,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withAlpha(40),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FFLocalizations.of(context).getText('notes'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 8)),
          // Adding animation to the note section
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: TextField(
              onTap: () {
                // Move cursor to end of text
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: FFLocalizations.of(context).getText('notes_hint'),
                hintStyle: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: ResponsiveUtils.fontSize(context, 12),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    width: 1.0,
                  ),
                ),
              ),
              maxLines: 5,
            ),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 12)),
          FFButtonWidget(
            icon: Icon(
              Icons.save_rounded,
              size: ResponsiveUtils.iconSize(context, 20),
              color: FlutterFlowTheme.of(context).info,
            ),
            onPressed: onSavePressed,
            text: FFLocalizations.of(context).getText('apqx7rpg'),
            options: FFButtonOptions(
              width: double.infinity,
              height: ResponsiveUtils.height(context, 54.0),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.width(context, 16.0)),
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.95),
              textStyle: AppStyles.textCairo(
                context,
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveUtils.fontSize(context, 16),
                color: FlutterFlowTheme.of(context).info,
              ),
              elevation: 4,
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 800.ms).moveY(
          begin: 50,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }
}
