import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';
import 'dart:ui';

class StatisticsRow extends StatelessWidget {
  final CoachRecord coach;

  const StatisticsRow({
    super.key,
    required this.coach,
  });

  // Text styles helper
  TextStyle _getTextStyle(
    BuildContext context, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return AppStyles.textCairo(
      context,
      color: color ?? FlutterFlowTheme.of(context).primaryText,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontStyle: fontStyle ?? FontStyle.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withAlpha(15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                context,
                icon: Icons.calendar_month_outlined,
                value: coach.dateOfBirth != null
                    ? (DateTime.now().year - coach.dateOfBirth!.year).toString()
                    : '-',
                label: FFLocalizations.of(context).getText('age'),
              ),
              _buildVerticalDivider(context),
              _buildStatCard(
                context,
                icon: Icons.fitness_center_outlined,
                value: coach.experience.toString(),
                label: FFLocalizations.of(context).getText('t70b45uz'),
              ),
              _buildVerticalDivider(context),
              _buildStatCard(
                context,
                icon: Icons.payments_outlined,
                value: coach.price.toString(),
                label: FFLocalizations.of(context).getText('ekri56yw'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: SizedBox(
          height: 150, // Fixed height for all stat cards
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary.withOpacity(0.9),
                      FlutterFlowTheme.of(context).tertiary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  size: 24,
                ),
              ),
              Text(
                value,
                style: _getTextStyle(
                  context,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: _getTextStyle(
                    context,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 60,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondaryText.withOpacity(0),
            FlutterFlowTheme.of(context).secondaryText.withOpacity(0.2),
            FlutterFlowTheme.of(context).secondaryText.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
