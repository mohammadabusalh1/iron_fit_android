import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/services/notification_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'notification_button.dart';
import '/backend/backend.dart';

class UserHeader extends StatelessWidget {
  final TraineeRecord trainee;
  final NotificationService notificationService;

  const UserHeader({
    required this.trainee,
    required this.notificationService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Cache calculated values
    final firstName = currentUserDisplayName.split(' ')[0];
    final greeting =
        '${FFLocalizations.of(context).getText('c6ki0mzp')} $firstName!';

    final formattedDate = FFLocalizations.of(context).languageCode == 'ar'
        ? dateTimeFormat(
            'EEEE, dd MMMM',
            DateTime.now(),
            locale: const Locale('ar').toString(),
          )
        : dateTimeFormat('EEEE, dd MMMM', DateTime.now());

    // Memoize avatar widget to prevent rebuilds
    final avatarWidget = currentUserPhoto.isNotEmpty
        ? CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(currentUserPhoto),
          )
        : Icon(
            Icons.person,
            color: FlutterFlowTheme.of(context).primary,
            size: 30,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              avatarWidget,
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          NotificationButton(
              trainee: trainee, notificationService: notificationService),
        ],
      ),
    );
  }
}
