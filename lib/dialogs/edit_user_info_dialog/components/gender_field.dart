import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/responsive_utils.dart';

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
  String? _selectedChoice;

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
  void didUpdateWidget(GenderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGender != widget.initialGender) {
      _initSelectedChoice();
    }
  }

  void _initSelectedChoice() {
    if (widget.initialGender != null && widget.initialGender!.isNotEmpty) {
      _genderController.value = [widget.initialGender!];
      _selectedChoice = widget.initialGender;
    }
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
            fontSize: ResponsiveUtils.fontSize(context, 16),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12)),
        Row(
          children: [
            Icon(
              Icons.wc_rounded,
              color: theme.primary,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 12)),
            Expanded(
              child: FlutterFlowChoiceChips(
                options: _chipOptions,
                onChanged: (val) {
                  if (val != null && val.isNotEmpty) {
                    // Trigger haptic feedback on selection
                    HapticFeedback.selectionClick();
                    widget.onGenderSelected(val.first);
                    _selectedChoice = val.first;
                  }
                },
                controller: _genderController,
                selectedChipStyle: ChipStyle(
                  backgroundColor: theme.primary,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: theme.info,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                  ),
                  iconColor: theme.info,
                  iconSize: ResponsiveUtils.iconSize(context, 20),
                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                    ResponsiveUtils.width(context, 16),
                    ResponsiveUtils.height(context, 8),
                    ResponsiveUtils.width(context, 16),
                    ResponsiveUtils.height(context, 8),
                  ),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
                ),
                unselectedChipStyle: ChipStyle(
                  backgroundColor: theme.secondaryBackground,
                  textStyle: AppStyles.textCairo(
                    context,
                    color: theme.secondaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                  ),
                  iconColor: theme.secondaryText,
                  iconSize: ResponsiveUtils.iconSize(context, 20),
                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                    ResponsiveUtils.width(context, 16),
                    ResponsiveUtils.height(context, 8),
                    ResponsiveUtils.width(context, 16),
                    ResponsiveUtils.height(context, 8),
                  ),
                  elevation: 1,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
                  borderColor: theme.alternate,
                  borderWidth: ResponsiveUtils.width(context, 1),
                ),
                chipSpacing: ResponsiveUtils.width(context, 12),
                rowSpacing: ResponsiveUtils.height(context, 8),
                multiselect: false,
                initialized: _selectedChoice != null,
                alignment: WrapAlignment.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
