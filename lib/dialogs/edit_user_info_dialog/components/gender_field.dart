import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/form_field_controller.dart';

class GenderField extends StatefulWidget {
  const GenderField({
    super.key,
    this.initialGender,
    required this.onGenderSelected,
  });

  final String? initialGender;
  final Function(String) onGenderSelected;

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField>
    with SingleTickerProviderStateMixin {
  late FormFieldController<List<String>> _genderController;
  late List<ChipData> _chipOptions;

  @override
  void initState() {
    super.initState();

    // Initialize controller with initial value if it exists
    final List<String> initialValue =
        widget.initialGender != null && widget.initialGender!.isNotEmpty
            ? [widget.initialGender!]
            : [];

    _genderController = FormFieldController<List<String>>(initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final localizations = FFLocalizations.of(context);

    // Initialize chip options with localized text
    _chipOptions = [
      ChipData(
          localizations.getText('of3kkd2s' /* Male */), Icons.male_rounded),
      ChipData(
          localizations.getText('0qvrqp4v' /* Female */), Icons.female_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.getText('gciphuh3' /* Gender */),
          style: AppStyles.textCairo(
            context,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.wc_rounded,
              color: theme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FlutterFlowChoiceChips(
                options: _chipOptions,
                onChanged: (val) {
                  if (val != null && val.isNotEmpty) {
                    // Trigger haptic feedback on selection
                    HapticFeedback.selectionClick();
                    widget.onGenderSelected(val.first);
                  }
                },
                controller: _genderController,
                selectedChipStyle: ChipStyle(
                  backgroundColor: theme.primary,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: theme.info,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  iconColor: theme.info,
                  iconSize: 20,
                  labelPadding:
                      const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                ),
                unselectedChipStyle: ChipStyle(
                  backgroundColor: theme.primaryBackground,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: theme.secondaryText,
                    fontSize: 16,
                  ),
                  iconColor: theme.secondaryText,
                  iconSize: 20,
                  labelPadding:
                      const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(16),
                ),
                chipSpacing: 12,
                rowSpacing: 12,
                multiselect: false,
                alignment: WrapAlignment.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
