import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:logging/logging.dart';

/// A widget that memoizes a single day item to prevent unnecessary rebuilds
class MemoizedDayItem extends StatefulWidget {
  final TrainingDayStruct dayItem;
  final int dayIndex;
  final Function(BuildContext, TrainingDayStruct, int, {Key? key}) itemBuilder;

  const MemoizedDayItem({
    super.key,
    required this.dayItem,
    required this.dayIndex,
    required this.itemBuilder,
  });

  @override
  State<MemoizedDayItem> createState() => _MemoizedDayItemState();
}

class _MemoizedDayItemState extends State<MemoizedDayItem> {
  @override
  Widget build(BuildContext context) {
    return widget.itemBuilder(context, widget.dayItem, widget.dayIndex,
        key: ValueKey('day_${widget.dayIndex}_${widget.dayItem.hashCode}'));
  }

  @override
  void didUpdateWidget(MemoizedDayItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only rebuild if the day item data has changed
    if (oldWidget.dayItem != widget.dayItem ||
        oldWidget.dayIndex != widget.dayIndex) {
      setState(() {});
    }
  }
}

class ScheduleSection extends StatelessWidget {
  static final _logger = Logger('ScheduleSection');
  final PlanStruct? draftPlan;
  final Function(PlanStruct updatedPlan) onPlanUpdated;
  final GlobalKey dayKey;

  const ScheduleSection({
    super.key,
    required this.draftPlan,
    required this.onPlanUpdated,
    required this.dayKey,
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
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildScheduleHeader(context),
              const SizedBox(height: 16),
              _buildDaysList(context),
              const SizedBox(height: 16),
              _buildAddDayButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today,
            color: FlutterFlowTheme.of(context).primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FFLocalizations.of(context).getText('laamzbep' /* Schedule */),
              style: AppStyles.textCairo(
                context,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              FFLocalizations.of(context).getText(
                  'schedule_subtitle' /* Organize your training days */),
              style: AppStyles.textCairo(
                context,
                fontSize: 12,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysList(BuildContext context) {
    final days = draftPlan?.days.toList() ?? [];

    if (days.isEmpty) {
      return Container(
        height: 120,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withAlpha(150),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 40,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(height: 8),
              Text(
                FFLocalizations.of(context).getText('no_days_found'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 14,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withAlpha(150),
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: days.length,
        separatorBuilder: (context, index) => const Divider(
          height: 24,
          thickness: 1,
          color:
              Color(0x26AEAEAE), // Using constant color instead of theme lookup
        ),
        itemBuilder: (context, daysIndex) {
          final daysItem = days[daysIndex];
          return MemoizedDayItem(
            dayItem: daysItem,
            dayIndex: daysIndex,
            itemBuilder: _buildDayItem,
          );
        },
      ),
    );
  }

  Widget _buildDayItem(
      BuildContext context, TrainingDayStruct daysItem, int daysIndex,
      {Key? key}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  daysItem.day,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  daysItem.title.length > 15
                      ? '${daysItem.title.substring(0, 15)}...'
                      : daysItem.title,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                if (daysItem.exercises.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${daysItem.exercises.length} ${FFLocalizations.of(context).getText('exercises')}',
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                key: draftPlan?.days.length == 1 ? dayKey : null,
                child: _buildDayActionButton(
                  icon: Icons.edit,
                  color: FlutterFlowTheme.of(context).primary,
                  tooltip: 'Edit Day',
                  onTap: () => _editDay(context, daysItem, daysIndex),
                ),
              ),
              const SizedBox(width: 12),
              _buildDayActionButton(
                icon: Icons.delete_outline_rounded,
                color: FlutterFlowTheme.of(context).error,
                tooltip: 'Delete Day',
                onTap: () => _showDeleteConfirmationDialog(context, daysIndex),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildDayActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    )
        .animate()
        .scale(duration: 200.ms, curve: Curves.easeInOut)
        .fadeIn(duration: 200.ms);
  }

  Widget _buildAddDayButton(BuildContext context) {
    return FFButtonWidget(
      onPressed: () => _addDay(context),
      text: FFLocalizations.of(context).getText('c71ma75q' /* Add Day */),
      icon: Icon(
        Icons.add_rounded,
        size: 20,
        color: FlutterFlowTheme.of(context).info,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 48.0,
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: AppStyles.textCairo(
          context,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: FlutterFlowTheme.of(context).info,
        ),
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  Future<void> _editDay(
      BuildContext context, TrainingDayStruct daysItem, int daysIndex) async {
    try {
      // Unfocus any active text fields
      FocusScope.of(context).unfocus();

      // Navigate to edit day screen with the current day data
      final result = await context.pushNamed(
        'SelectDayForPlan',
        queryParameters: {
          'existingDays': draftPlan?.days
                  .where((day) => day != daysItem)
                  .map((e) => e.day)
                  .toList() ??
              [],
        },
        extra: {
          'editingDay': daysItem,
        },
      );

      Future.delayed(
        const Duration(milliseconds: 100),
        () => FocusScope.of(context).unfocus(),
      );

      if (result != null) {
        // Create a copy of the current plan
        final updatedPlan = draftPlan ?? PlanStruct();
        final updatedDays = List<TrainingDayStruct>.from(updatedPlan.days);

        // Map to define the day order (index) for proper sorting
        final dayOrderMap = {
          'Saturday': 0,
          'السبت': 0,
          'Sunday': 1,
          'الأحد': 1,
          'الاحد': 1,
          'Monday': 2,
          'الإثنين': 2,
          'الاثنين': 2,
          'Tuesday': 3,
          'الثلاثاء': 3,
          'Wednesday': 4,
          'الأربعاء': 4,
          'الاربعاء': 4,
          'Thursday': 5,
          'الخميس': 5,
          'Friday': 6,
          'الجمعة': 6,
        };

        // Handle different result types
        if (result is List) {
          // Handle the multi-day edit mode result

          bool shouldRemoveOriginal = false;
          String originalDay = '';

          // First pass to check for any removal actions
          for (var item in result) {
            if (item is Map && item['action'] == 'remove') {
              shouldRemoveOriginal = true;
              originalDay = item['day'] as String;
              break;
            }
          }

          // If we need to remove the original day
          if (shouldRemoveOriginal) {
            // Find and remove the original day
            final originalDayIndex =
                updatedDays.indexWhere((day) => day.day == originalDay);
            if (originalDayIndex >= 0) {
              updatedDays.removeAt(originalDayIndex);
            }
          }

          // Second pass to add or update days
          for (var item in result) {
            if (item is TrainingDayStruct) {
              final day = item;

              // Check if this day already exists in plan
              final existingIndex = updatedDays.indexWhere((existingDay) =>
                  existingDay.day == day.day ||
                  (dayOrderMap[existingDay.day] != null &&
                      dayOrderMap[day.day] != null &&
                      dayOrderMap[existingDay.day] == dayOrderMap[day.day]));

              if (existingIndex >= 0) {
                // Update existing day
                updatedDays[existingIndex] = day;
              } else {
                // Add new day
                updatedDays.add(day);
              }
            }
          }
        } else if (result is TrainingDayStruct) {
          // Traditional single day edit (backward compatibility)
          TrainingDayStruct newDay = result;

          // Check if original day has been renamed
          if (newDay.day != daysItem.day) {
            // Remove the old day
            updatedDays.removeAt(daysIndex);

            // Check if the new day name conflicts with existing days
            final existingDayIndex = updatedDays.indexWhere((day) =>
                day.day == newDay.day ||
                (dayOrderMap[day.day] != null &&
                    dayOrderMap[newDay.day] != null &&
                    dayOrderMap[day.day] == dayOrderMap[newDay.day]));

            if (existingDayIndex >= 0) {
              // Update the existing day with the new content
              updatedDays[existingDayIndex] = newDay;
            } else {
              // Add as a new day
              updatedDays.add(newDay);
            }
          } else {
            // Just update the day content, keeping the same day name
            updatedDays[daysIndex] = newDay;
          }
        }

        // Sort the days based on the dayOrderMap
        updatedDays.sort((a, b) {
          final aIndex = dayOrderMap[a.day] ?? 7; // Default to end if unknown
          final bIndex = dayOrderMap[b.day] ?? 7; // Default to end if unknown
          return aIndex.compareTo(bIndex);
        });

        // Create a new PlanStruct with the updated days
        final newPlan = PlanStruct(
          name: updatedPlan.name,
          level: updatedPlan.level,
          coach: updatedPlan.coach,
          createdAt: updatedPlan.createdAt,
          description: updatedPlan.description,
          draft: updatedPlan.draft,
          days: updatedDays,
          totalSource: updatedPlan.totalSource,
          type: updatedPlan.type,
        );

        // Notify parent about the update
        onPlanUpdated(newPlan);
      }
    } catch (e) {
      _logger.severe('Error editing day: $e');
      if (context.mounted) {
        functions.showErrorDialog(
          FFLocalizations.of(context).getText('failedToEditDay'),
          context,
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int daysIndex) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Delete Icon with Animation
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .error
                                  .withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: FlutterFlowTheme.of(context).error,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      FFLocalizations.of(context).getText('confirmDelete'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Warning Message
                    Text(
                      FFLocalizations.of(context)
                          .getText('areYouSureYouWantToDeleteThisExercise'),
                      textAlign: TextAlign.center,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 16,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      FFLocalizations.of(context).getText('thisActionCannot'),
                      textAlign: TextAlign.center,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        color: FlutterFlowTheme.of(context).error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              FFLocalizations.of(context).getText('cancel'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 16,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Delete Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                              foregroundColor:
                                  FlutterFlowTheme.of(context).info,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              FFLocalizations.of(context).getText('delete'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 16,
                                color: FlutterFlowTheme.of(context).info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                )
                .fade(
                  duration: 300.ms,
                  begin: 0,
                  end: 1,
                );
          },
        ) ??
        false;

    if (shouldDelete) {
      // Create a copy of the current plan
      final updatedPlan = draftPlan ?? PlanStruct();

      // Update the days list by removing the day at the specified index
      final updatedDays = List<TrainingDayStruct>.from(updatedPlan.days);
      updatedDays.removeAt(daysIndex);

      // Create a new PlanStruct with the updated days
      final newPlan = PlanStruct(
        name: updatedPlan.name,
        level: updatedPlan.level,
        coach: updatedPlan.coach,
        createdAt: updatedPlan.createdAt,
        description: updatedPlan.description,
        draft: updatedPlan.draft,
        days: updatedDays,
        totalSource: updatedPlan.totalSource,
        type: updatedPlan.type,
      );

      // Notify parent about the update
      onPlanUpdated(newPlan);
    }
  }

  Future<void> _addDay(BuildContext context) async {
    // Unfocus before showing modal
    Future.delayed(
      const Duration(milliseconds: 100),
      () => FocusScope.of(context).unfocus(),
    );

    final result = await context.pushNamed(
      'SelectDayForPlan',
      queryParameters: {
        'existingDays': draftPlan?.days.map((e) => e.day).toList() ?? [],
      },
    );

    if (result != null) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => FocusScope.of(context).unfocus(),
      );

      // Create a copy of the current plan
      final updatedPlan = draftPlan ?? PlanStruct();
      final updatedDays = List<TrainingDayStruct>.from(updatedPlan.days);

      // Map to define the day order (index) for proper sorting
      final dayOrderMap = {
        'Saturday': 0,
        'السبت': 0,
        'Sunday': 1,
        'الأحد': 1,
        'الاحد': 1,
        'Monday': 2,
        'الإثنين': 2,
        'الاثنين': 2,
        'Tuesday': 3,
        'الثلاثاء': 3,
        'Wednesday': 4,
        'الأربعاء': 4,
        'الاربعاء': 4,
        'Thursday': 5,
        'الخميس': 5,
        'Friday': 6,
        'الجمعة': 6,
      };

      // Handle multiple days being added
      if (result is List<TrainingDayStruct>) {
        List<TrainingDayStruct> newDays = result;

        for (TrainingDayStruct newDay in newDays) {
          // Check if day already exists in plan
          final existingDayIndex = updatedDays.indexWhere((day) =>
              day.day == newDay.day ||
              (dayOrderMap[day.day] != null &&
                  dayOrderMap[newDay.day] != null &&
                  dayOrderMap[day.day] == dayOrderMap[newDay.day]));

          // Replace the day if it exists, otherwise add it
          if (existingDayIndex >= 0) {
            updatedDays[existingDayIndex] = newDay;
          } else {
            updatedDays.add(newDay);
          }
        }
      }
      // Handle single day being added (backward compatibility)
      else if (result is TrainingDayStruct) {
        TrainingDayStruct newDay = result;

        // Check if day already exists in plan
        final existingDayIndex = updatedDays.indexWhere((day) =>
            day.day == newDay.day ||
            (dayOrderMap[day.day] != null &&
                dayOrderMap[newDay.day] != null &&
                dayOrderMap[day.day] == dayOrderMap[newDay.day]));

        // Replace the day if it exists, otherwise add it
        if (existingDayIndex >= 0) {
          updatedDays[existingDayIndex] = newDay;
        } else {
          updatedDays.add(newDay);
        }
      }

      // Sort the days based on the dayOrderMap
      updatedDays.sort((a, b) {
        final aIndex = dayOrderMap[a.day] ?? 7; // Default to end if unknown
        final bIndex = dayOrderMap[b.day] ?? 7; // Default to end if unknown
        return aIndex.compareTo(bIndex);
      });

      // Create a new PlanStruct with the updated days
      final newPlan = PlanStruct(
        name: updatedPlan.name,
        level: updatedPlan.level,
        coach: updatedPlan.coach,
        createdAt: updatedPlan.createdAt,
        description: updatedPlan.description,
        draft: updatedPlan.draft,
        days: updatedDays,
        totalSource: updatedPlan.totalSource,
        type: updatedPlan.type,
      );

      // Notify parent about the update
      onPlanUpdated(newPlan);
    }
  }
}
