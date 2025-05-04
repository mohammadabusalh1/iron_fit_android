import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'theme_cache.dart';
import '/utils/responsive_utils.dart';

class ProfileHeader extends StatelessWidget {
  final TraineeRecord userProfileTraineeRecord;
  final ThemeCache themeCache;

  const ProfileHeader({
    super.key,
    required this.userProfileTraineeRecord,
    required this.themeCache,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: themeCache.primaryTextColor,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            onPressed: () => context.pop(),
            tooltip: 'Close',
          ),
          Text(
            FFLocalizations.of(context).getText('your_profile'),
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: themeCache.primaryTextColor,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            onPressed: () {
              context.pushNamed(
                'traineeSettings',
                queryParameters: {
                  'trainee': serializeParam(
                    userProfileTraineeRecord.reference,
                    ParamType.DocumentReference,
                  ),
                }.withoutNulls,
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
