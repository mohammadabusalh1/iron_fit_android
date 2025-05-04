import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/responsive_utils.dart';

class ProgramStructureSection extends StatelessWidget {
  final FormFieldController<List<String>> levelValueController;
  final FormFieldController<List<String>> goalValueController;
  final Function(List<String>?) onLevelChanged;
  final Function(List<String>?) onGoalChanged;

  const ProgramStructureSection({
    super.key,
    required this.levelValueController,
    required this.goalValueController,
    required this.onLevelChanged,
    required this.onGoalChanged,
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
          padding: ResponsiveUtils.padding(context, horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 8)),
                  Text(
                    FFLocalizations.of(context)
                        .getText('56uefxy7' /* Program Structure */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 18),
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.height(context, 24)),
              _buildStructureSection(
                context,
                title: FFLocalizations.of(context)
                    .getText('sis1n01p' /* Experience Level */),
                subtitle: FFLocalizations.of(context).getText(
                    'level_subtitle' /* Select the program difficulty */),
                icon: Icons.trending_up_rounded,
                options: [
                  FFLocalizations.of(context)
                      .getText('spfhprtu' /* Beginner */),
                  FFLocalizations.of(context)
                      .getText('1pvh1cxx' /* Intermediate */),
                  FFLocalizations.of(context)
                      .getText('lxrqt25o' /* Advanced */),
                ],
                onChanged: onLevelChanged,
                controller: levelValueController,
              ),
              SizedBox(height: ResponsiveUtils.height(context, 24)),
              _buildStructureSection(
                context,
                title: FFLocalizations.of(context)
                    .getText('fnycvvuy' /* Training Goal */),
                subtitle: FFLocalizations.of(context).getText(
                    'choose_goal_subtitle' /* Choose the primary focus */),
                icon: Icons.track_changes_rounded,
                options: [
                  FFLocalizations.of(context).getText(
                      'build_muscle_lose_weight' /* Build Muscle & Lose Weight */),
                  FFLocalizations.of(context)
                      .getText('amdnrtzx' /* Strength */),
                  FFLocalizations.of(context).getText('9d9lxfgp' /* Cardio */),
                  FFLocalizations.of(context).getText('duqb8whi' /* HIIT */),
                  FFLocalizations.of(context).getText('all' /* Flexibility */),
                ],
                onChanged: onGoalChanged,
                controller: goalValueController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStructureSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> options,
    required Function(List<String>?) onChanged,
    required FormFieldController<List<String>> controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: ResponsiveUtils.iconSize(context, 20),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 12),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate.withAlpha(150),
              width: 1,
            ),
          ),
          padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
          child: FlutterFlowChoiceChips(
            options: options.map((e) => ChipData(e)).toList(),
            onChanged: onChanged,
            selectedChipStyle: ChipStyle(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              textStyle: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).info,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                letterSpacing: 0.0,
              ),
              iconColor: FlutterFlowTheme.of(context).info,
              iconSize: ResponsiveUtils.iconSize(context, 18.0),
              elevation: 2.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
            unselectedChipStyle: ChipStyle(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              textStyle: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                letterSpacing: 0.0,
              ),
              iconColor: FlutterFlowTheme.of(context).secondaryText,
              iconSize: ResponsiveUtils.iconSize(context, 18.0),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
              borderWidth: 1,
              borderColor:
                  FlutterFlowTheme.of(context).alternate.withAlpha(150),
            ),
            chipSpacing: ResponsiveUtils.width(context, 8.0),
            rowSpacing: ResponsiveUtils.height(context, 8.0),
            multiselect: false,
            alignment: WrapAlignment.start,
            controller: controller,
            wrapped: true,
          ),
        ),
      ],
    );
  }
}
