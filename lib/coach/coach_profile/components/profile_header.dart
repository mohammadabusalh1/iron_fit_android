import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';

class ProfileHeader extends StatelessWidget {
  final CoachRecord coachRecord;

  const ProfileHeader({
    super.key,
    required this.coachRecord,
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
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Content
        Column(
          children: [
            const SizedBox(height: 60),

            // Profile image
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).info,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context).info.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: currentUserPhoto != null && currentUserPhoto.isNotEmpty
                      ? Image.network(
                          currentUserPhoto,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultAvatar(context),
                        )
                      : _buildDefaultAvatar(context),
                ),
              ),
            ).animate().scale(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 16),

            // Name
            AuthUserStreamWidget(
              builder: (context) {
                String displayName = _formatDisplayName(context);
                return SizedBox(
                  width: ResponsiveUtils.width(context, 250),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    displayName,
                    style: _getTextStyle(
                      context,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .moveY(
                    begin: 20,
                    end: 0,
                    duration: const Duration(milliseconds: 600)),

            const SizedBox(height: 12),

            // Specialization and gym badges
            _buildInfoBadges(context),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: Icon(
        Icons.person,
        color: FlutterFlowTheme.of(context).primary,
        size: 48,
      ),
    );
  }

  String _formatDisplayName(BuildContext context) {
    try {
      if (currentUserDisplayName.isEmpty) {
        return FFLocalizations.of(context).getText('your_name');
      } else {
        final nameParts = currentUserDisplayName.trim().split(' ');
        if (nameParts.isEmpty) {
          return FFLocalizations.of(context).getText('your_name');
        } else if (nameParts.length == 1) {
          return nameParts[0];
        } else {
          return nameParts[0];
        }
      }
    } catch (e) {
      return FFLocalizations.of(context).getText('your_name');
    }
  }

  Widget _buildInfoBadges(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _buildBadge(
          context,
          icon: Icons.fitness_center_rounded,
          label: valueOrDefault<String>(
            coachRecord.specialization,
            FFLocalizations.of(context).getText('coach_label'),
          ),
        ),
        _buildBadge(
          context,
          icon: Icons.location_on_rounded,
          label: valueOrDefault<String>(
            coachRecord.gymName,
            FFLocalizations.of(context).getText('gym_name'),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 600))
        .moveY(begin: 20, end: 0, duration: const Duration(milliseconds: 600));
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: FlutterFlowTheme.of(context).primary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: _getTextStyle(
              context,
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
