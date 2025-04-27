import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';

class CustomChoiceChips extends StatelessWidget {
  final String label;
  final IconData? labelIcon;
  final List<ChipData> options;
  final Function(String?) onChanged;
  final FormFieldController<List<String>>? controller;
  final bool multiSelect;
  final String? selectedValue;

  const CustomChoiceChips({
    super.key,
    required this.label,
    this.labelIcon,
    required this.options,
    required this.onChanged,
    this.controller,
    this.multiSelect = false,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              children: [
                if (labelIcon != null) ...[
                  Icon(
                    labelIcon,
                    size: 18.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(width: 8.0),
                ],
                Text(
                  label,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14.0,
                    color: FlutterFlowTheme.of(context).info,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        FlutterFlowChoiceChips(
          options: options,
          onChanged: (val) => onChanged(val?.firstOrNull),
          selectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(
              context,
              fontSize: 14.0,
              color: FlutterFlowTheme.of(context).info,
              fontWeight: FontWeight.w600,
            ),
            iconColor: FlutterFlowTheme.of(context).info,
            iconSize: 18.0,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          unselectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            textStyle: AppStyles.textCairo(
              context,
              fontSize: 14.0,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.normal,
            ),
            iconColor: FlutterFlowTheme.of(context).secondaryText,
            iconSize: 18.0,
            elevation: 0.0,
            borderRadius: BorderRadius.circular(8.0),
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 1.0,
          ),
          chipSpacing: 12.0,
          rowSpacing: 12.0,
          multiselect: multiSelect,
          alignment: WrapAlignment.start,
          controller: controller ?? FormFieldController<List<String>>([]),
          wrapped: true,
        ),
      ],
    );
  }
}
