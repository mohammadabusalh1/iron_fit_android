import 'package:flutter/material.dart';
import 'package:iron_fit/coach/create_nutrition_plans/componants/form_field_components.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdditionalNotesSection extends StatelessWidget {
  final TextEditingController notesController;
  final FocusNode notesFocusNode;

  const AdditionalNotesSection({
    super.key,
    required this.notesController,
    required this.notesFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.notes_rounded,
            title: FFLocalizations.of(context)
                .getText('3menqg1v' /* Additional Notes */),
          ),
          const SizedBox(height: 16),
          Text(
            FFLocalizations.of(context).getText(
                'notesDescription' /* Add any special instructions or additional information about the nutrition plan */),
            style: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1,
              ),
            ),
            child: TextFormField(
              onTap: () {
                // Move cursor to end of text
                notesController.selection = TextSelection.fromPosition(
                  TextPosition(offset: notesController.text.length),
                );
              },
              controller: notesController,
              focusNode: notesFocusNode,
              maxLines: 6,
              minLines: 4,
              style: AppStyles.textCairo(
                context,
                fontSize: 14,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              decoration: InputDecoration(
                hintText: FFLocalizations.of(context).getText(
                    'l6f4hfdc' /* Enter any additional instructions or notes about the plan... */),
                hintStyle: AppStyles.textCairo(
                  context,
                  color:
                      FlutterFlowTheme.of(context).secondaryText.withAlpha(150),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // Notes are optional
                }
                if (value.length < 10) {
                  return FFLocalizations.of(context).getText(
                      'notesTooShort' /* Notes should be at least 10 characters */);
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            FFLocalizations.of(context).getText(
                'notesOptional' /* Optional: Add any relevant details about meal timing, preparation, or special considerations */),
            style: AppStyles.textCairo(
              context,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (notesFocusNode.hasFocus)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${notesController.text.length} ${FFLocalizations.of(context).getText('characters')}',
                    style: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
