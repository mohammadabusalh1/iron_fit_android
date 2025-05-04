import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/dialogs/edit_user_info_dialog/edit_user_info_dialog_widget.dart';
import 'theme_cache.dart';
import '/utils/responsive_utils.dart';

class UserStatsSection extends StatelessWidget {
  final TraineeRecord userProfileTraineeRecord;
  final ThemeCache themeCache;
  final VoidCallback? onProfileUpdated;

  const UserStatsSection({
    super.key,
    required this.userProfileTraineeRecord,
    required this.themeCache,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    // Safely handle potential null values
    final height = userProfileTraineeRecord.height.toString();
    final weight = userProfileTraineeRecord.weight.toString();

    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: 'profileImage',
              child: Container(
                width: ResponsiveUtils.width(context, 120),
                height: ResponsiveUtils.width(context, 120),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeCache.primaryColor,
                    width: ResponsiveUtils.width(context, 3),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 60)),
                  child: CachedNetworkImage(
                    imageUrl: currentUserPhoto.isEmpty
                        ? 'https://via.placeholder.com/150'
                        : currentUserPhoto,
                    fit: BoxFit.cover,
                    memCacheWidth: 240, // 2x display size for high-res screens
                    memCacheHeight: 240,
                    placeholder: (context, url) => Container(
                      color: themeCache.primaryColor.withValues(alpha: 0.1),
                      child: Center(
                        child: SizedBox(
                          width: ResponsiveUtils.width(context, 20),
                          height: ResponsiveUtils.width(context, 20),
                          child: CircularProgressIndicator(
                            strokeWidth: ResponsiveUtils.width(context, 2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              themeCache.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: ResponsiveUtils.iconSize(context, 60),
                      color: themeCache.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            // Edit button overlay
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _openEditProfileDialog(context),
                child: Container(
                  width: ResponsiveUtils.width(context, 36),
                  height: ResponsiveUtils.width(context, 36),
                  decoration: BoxDecoration(
                    color: themeCache.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            themeCache.primaryBackgroundColor.withOpacity(0.25),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit,
                    color: themeCache.primaryBackgroundColor,
                    size: ResponsiveUtils.iconSize(context, 20),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 16)),
        Text(
          currentUserDisplayName,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              height,
              FFLocalizations.of(context).getText('5vy2q12i'),
              Icons.local_fire_department,
            ),
            _buildStatItem(
              context,
              weight,
              FFLocalizations.of(context).getText('tcxcdcm7'),
              Icons.people,
            ),
          ],
        ),
      ],
    );
  }

  void _openEditProfileDialog(BuildContext context) async {
    try {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: EditUserInfoDialogWidget(
                name: currentUserDisplayName,
                trainee: userProfileTraineeRecord,
                onProfileUpdated: onProfileUpdated,
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Error showing edit profile dialog: $e');
    }
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: themeCache.primaryColor,
          size: ResponsiveUtils.iconSize(context, 24),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          value,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: themeCache.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
