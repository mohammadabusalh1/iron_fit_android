import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';

class FilterTabs extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const FilterTabs({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _buildFilterButton(
            context, FFLocalizations.of(context).getText('active'), 'active'),
        _buildFilterButton(context,
            FFLocalizations.of(context).getText('inactive'), 'inactive'),
        _buildFilterButton(context,
            FFLocalizations.of(context).getText('requests'), 'requests'),
        _buildFilterButton(
            context, FFLocalizations.of(context).getText('deleted'), 'deleted'),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, String value) {
    final isSelected = currentFilter == value;
    return FFButtonWidget(
      onPressed: () => onFilterChanged(value),
      text: label,
      options: FFButtonOptions(
        height: 35.0,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        color: isSelected
            ? FlutterFlowTheme.of(context).primary
            : FlutterFlowTheme.of(context).secondaryBackground,
        textStyle: AppStyles.textCairo(
          context,
          fontWeight: FontWeight.bold,
          color: isSelected
              ? FlutterFlowTheme.of(context).info
              : FlutterFlowTheme.of(context).primaryText,
          fontSize: 12,
        ),
        elevation: 0.0,
        borderSide: BorderSide(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primaryText,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }
}
