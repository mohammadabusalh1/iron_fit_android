import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';
import '/widgets/build_text_filed.dart';
import '../../add_client_model.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class TrainingDetailsStep extends StatelessWidget {
  final AddClientModel model;
  final bool isFirstStep;
  final ValueChanged<String?> onLevelChanged;
  final String? levelValidationError;

  const TrainingDetailsStep({
    super.key,
    required this.model,
    required this.isFirstStep,
    required this.onLevelChanged,
    this.levelValidationError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        if (isFirstStep)
          _buildGoalField(context)
        else
          _buildLevelSelection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Text(
            FFLocalizations.of(context).getText('ud6tvmoh'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            FFLocalizations.of(context).getText('client_details_desc'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalField(BuildContext context) {
    return buildTextField(
      controller: model.goalTextController,
      focusNode: model.goalFocusNode,
      context: context,
      hintText: FFLocalizations.of(context).getText('k7u005at'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return FFLocalizations.of(context).getText('error_goal_required');
        }
        return null;
      },
      labelText: FFLocalizations.of(context).getText('label_training_goals'),
      prefixIcon: Icons.fitness_center,
      fontSize: ResponsiveUtils.fontSize(context, 14),
      iconSize: ResponsiveUtils.iconSize(context, 24),
    );
  }

  Widget _buildLevelSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                FFLocalizations.of(context)
                    .getText('label_current_fitness_level'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
            if (levelValidationError != null)
              Text(
                '*',
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12)),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildLevelCard(
                    context,
                    FFLocalizations.of(context).getText('1h4l5b6m'),
                    onLevelChanged,
                    model.levelValue,
                    Icons.fitness_center,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.width(context, 12)),
                Expanded(
                  flex: 1,
                  child: _buildLevelCard(
                    context,
                    FFLocalizations.of(context).getText('vncaynbk'),
                    onLevelChanged,
                    model.levelValue,
                    Icons.speed,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.height(context, 12)),
            _buildLevelCard(
              context,
              FFLocalizations.of(context).getText('ocvkm51o'),
              onLevelChanged,
              model.levelValue,
              Icons.military_tech,
              isFullWidth: true,
            ),
            if (levelValidationError != null)
              Container(
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: ResponsiveUtils.height(context, 8.0)),
                padding: ResponsiveUtils.padding(
                  context,
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: FlutterFlowTheme.of(context).error,
                      size: ResponsiveUtils.iconSize(context, 16),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 8)),
                    Expanded(
                      child: Text(
                        levelValidationError!,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          fontWeight: FontWeight.w500,
                          color: FlutterFlowTheme.of(context).error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String level,
    ValueChanged<String?> onChanged,
    String? selectedLevel,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    final isSelected = selectedLevel == level;
    return InkWell(
      onTap: () {
        onChanged(level);
        final currentContext = context;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (currentContext.mounted) {
            FocusScope.of(currentContext).unfocus();
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        width: isFullWidth ? double.infinity : null,
        duration: const Duration(milliseconds: 200),
        padding: ResponsiveUtils.padding(context, vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? FlutterFlowTheme.of(context).info
                  : FlutterFlowTheme.of(context).secondaryText,
              size: ResponsiveUtils.iconSize(context, 32),
            ),
            SizedBox(height: ResponsiveUtils.height(context, 8)),
            Text(
              level,
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? FlutterFlowTheme.of(context).info
                    : FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
