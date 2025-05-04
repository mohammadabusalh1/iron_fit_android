import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class PlanListItem extends StatelessWidget {
  final PlansRecord planItem;
  final int index;
  final VoidCallback? onDelete;

  const PlanListItem({
    super.key,
    required this.planItem,
    required this.index,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Pre-calculate values used multiple times to avoid recomputation
    final String planName = planItem.plan.name;
    final String planDescription = planItem.plan.description;
    final int numOfDays = planItem.plan.days.length;

    return Hero(
      tag: 'plan-${planItem.reference.id}',
      child: Padding(
        padding: ResponsiveUtils.padding(
          context,
          vertical: 8.0,
          horizontal: 4.0,
        ),
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.width(context, 24.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: InkWell(
                onTap: () => _navigateToCreatePlan(context),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.width(context, 24.0),
                ),
                splashColor: theme.primary.withOpacity(0.1),
                highlightColor: theme.primary.withOpacity(0.05),
                child: Container(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    ResponsiveUtils.width(context, 20),
                    ResponsiveUtils.height(context, 16),
                    ResponsiveUtils.width(context, 20),
                    ResponsiveUtils.height(context, 16),
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.width(context, 24.0),
                    ),
                    border: Border.all(
                      color: theme.primary.withAlpha(40),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withAlpha(8),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Section with Status Badge
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    // _buildStatusBadge(theme, isDraft),
                                    // const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        planName,
                                        style: AppStyles.textCairo(
                                          context,
                                          fontSize: ResponsiveUtils.fontSize(context, 18),
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: ResponsiveUtils.padding(
                                  context,
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryBackground,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.width(context, 16),
                                  ),
                                  border: Border.all(
                                    color: theme.primary.withAlpha(30),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: ResponsiveUtils.iconSize(context, 14),
                                      color: theme.primary,
                                    ),
                                    SizedBox(width: ResponsiveUtils.width(context, 4)),
                                    Text(
                                      '$numOfDays ${FFLocalizations.of(context).getText("days")}',
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: ResponsiveUtils.fontSize(context, 13),
                                        fontWeight: FontWeight.w600,
                                        color: theme.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 12)),

                          // Description
                          Text(
                            planDescription,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 14),
                              color: theme.secondaryText,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: ResponsiveUtils.height(context, 16)),

                          // Action buttons in a more modern layout
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Right side - Action buttons
                              Row(
                                children: [
                                  _buildActionButton(
                                    context,
                                    icon: Icons.visibility_rounded,
                                    label: FFLocalizations.of(context)
                                        .getText('view_plan'),
                                    color: theme.primary,
                                    onTap: () =>
                                        _navigateToPlanDetails(context),
                                  ),
                                  SizedBox(width: ResponsiveUtils.width(context, 8)),
                                  _buildIconButton(
                                    context,
                                    Icons.edit_rounded,
                                    theme.primary,
                                    () => _navigateToCreatePlan(context),
                                  ),
                                  SizedBox(width: ResponsiveUtils.width(context, 8)),
                                  _buildIconButton(
                                    context,
                                    Icons.delete_outline_rounded,
                                    theme.error,
                                    () => _confirmAndDelete(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: 120 * index),
          curve: Curves.easeOutQuint,
        )
        .slideY(
          begin: 0.2,
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 120 * index),
          curve: Curves.easeOutCubic,
        );
  }

  // Status badge widget
  Widget _buildStatusBadge(BuildContext context, FlutterFlowTheme theme, bool isDraft) {
    return Container(
      padding: ResponsiveUtils.padding(
        context,
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isDraft
            ? theme.warning.withOpacity(0.15)
            : theme.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.width(context, 12),
        ),
        border: Border.all(
          color: isDraft ? theme.warning : theme.success,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDraft ? Icons.edit_note : Icons.fitness_center,
            size: ResponsiveUtils.iconSize(context, 14),
            color: isDraft ? theme.warning : theme.success,
          ),
          SizedBox(width: ResponsiveUtils.width(context, 4)),
          Text(
            isDraft ? 'Draft' : 'Active',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, 12),
              fontWeight: FontWeight.bold,
              color: isDraft ? theme.warning : theme.success,
            ),
          ),
        ],
      ),
    );
  }

  // Modern action button with icon and text
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.width(context, 8),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(
            context,
            horizontal: 10,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(context, 16),
                color: color,
              ),
              SizedBox(width: ResponsiveUtils.width(context, 4)),
              Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon button for editing and deleting
  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: ResponsiveUtils.padding(
            context,
            horizontal: 8,
            vertical: 8,
          ),
          child: Icon(
            icon,
            size: ResponsiveUtils.iconSize(context, 20),
            color: color,
          ),
        ),
      ),
    );
  }

  void _navigateToPlanDetails(BuildContext context) {
    context.pushNamed(
      'PlanDetails',
      queryParameters: {
        'plan': serializeParam(planItem, ParamType.Document),
      }.withoutNulls,
      extra: <String, dynamic>{
        'plan': planItem,
      },
    );
  }

  void _navigateToCreatePlan(BuildContext context) {
    context.pushNamed(
      'createExercisePlan',
      queryParameters: {
        'plan': serializeParam(
          planItem.plan,
          ParamType.DataStruct,
        ),
        'planRef': serializeParam(
          planItem.reference,
          ParamType.DocumentReference,
        ),
      }.withoutNulls,
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    try {
      final confirmDelete = await _showDeleteConfirmationDialog(context);
      if (confirmDelete) {
        await planItem.reference.delete();
        onDelete?.call();
      }
    } catch (error) {
      Logger.error('Error deleting plan: $error');
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final theme = FlutterFlowTheme.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor: theme.secondaryBackground.withOpacity(0.95),
                contentPadding: EdgeInsets.zero,
                content: Container(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.elasticOut,
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.error.withAlpha(20),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.error.withAlpha(40),
                                    blurRadius: 20,
                                    spreadRadius: value * 8,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: theme.error,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Text(
                        FFLocalizations.of(context).getText('confirmDelete'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        FFLocalizations.of(context)
                            .getText('areYouSureYouWantToDeleteThisExercise'),
                        textAlign: TextAlign.center,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          color: theme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        FFLocalizations.of(context).getText('thisActionCannot'),
                        textAlign: TextAlign.center,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 14,
                          color: theme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildDialogButtons(context, theme),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }

  // Extract the dialog buttons to its own method
  Widget _buildDialogButtons(BuildContext context, FlutterFlowTheme theme) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.secondaryText.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
            child: Text(
              FFLocalizations.of(context).getText('cancel'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: theme.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.error,
              foregroundColor: theme.info,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: theme.error.withOpacity(0.5),
            ),
            child: Text(
              FFLocalizations.of(context).getText('delete'),
              style: AppStyles.textCairo(
                context,
                fontSize: 16,
                color: theme.info,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
