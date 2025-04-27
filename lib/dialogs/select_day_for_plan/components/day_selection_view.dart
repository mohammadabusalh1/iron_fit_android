import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/backend/schema/structs/index.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class DaySelectionView extends StatelessWidget {
  final List<String> weekDays;
  final List<String> selectedDays;
  final List<String> existingDays;
  final TrainingDayStruct? editingDay;
  final Function(List<String>) onDaysSelected;

  const DaySelectionView({
    super.key,
    required this.weekDays,
    required this.selectedDays,
    required this.existingDays,
    required this.onDaysSelected,
    this.editingDay,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = editingDay != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditMode
                    ? FFLocalizations.of(context)
                        .getText('edit_training_day_title')
                    : FFLocalizations.of(context).getText('isftiu1s'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  context.pop();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            FFLocalizations.of(context).getText('o89ikb3u'),
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEditMode
                ? FFLocalizations.of(context).getText('multiple_days_hint_edit')
                : FFLocalizations.of(context).getText('multiple_days_hint'),
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: FlutterFlowTheme.of(context).primary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: weekDays.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final day = weekDays[index];
                final isSelected = selectedDays.contains(day);

                // For edit mode, allow selecting days that were previously disabled
                bool isDisabled = false;
                if (isEditMode) {
                  // In edit mode, don't disable any days - allow multi-selection of all days
                  isDisabled = false;
                } else {
                  isDisabled = existingDays.contains(day);
                }

                final abbreviation = day.substring(0, 3).toUpperCase();

                return _buildDayItem(context, day, abbreviation, isSelected,
                    isDisabled, isEditMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(BuildContext context, String day, String abbreviation,
      bool isSelected, bool isDisabled, bool isEditMode) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  List<String> newSelectedDays = List.from(selectedDays);
                  if (isSelected) {
                    newSelectedDays.remove(day);
                  } else {
                    newSelectedDays.add(day);
                  }
                  onDaysSelected(newSelectedDays);
                },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.1),
                        FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected
                  ? null
                  : isDisabled
                      ? FlutterFlowTheme.of(context)
                          .alternate
                          .withValues(alpha: 0.1)
                      : FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : isDisabled
                        ? FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.5)
                        : FlutterFlowTheme.of(context).alternate,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context)
                            .alternate
                            .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      abbreviation,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : isDisabled
                                ? FlutterFlowTheme.of(context).alternate
                                : FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDisabled
                              ? FlutterFlowTheme.of(context).alternate
                              : FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      if (isDisabled && day != editingDay?.day)
                        Text(
                          FFLocalizations.of(context).getText('already_added'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 12,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                      if (isEditMode &&
                          existingDays.contains(day) &&
                          day != editingDay?.day)
                        Text(
                          FFLocalizations.of(context)
                              .getText('already_in_plan'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 12,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      if (day == editingDay?.day)
                        Text(
                          FFLocalizations.of(context).getText('current_day'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 12,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
