import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/componants/Styles.dart';
import '/backend/backend.dart';
import '/utils/responsive_utils.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionsRecord subscription;

  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
      ),
      child: subscription.trainee == null
          ? AnonymousTraineeCard(subscription: subscription)
          : TraineeCard(subscription: subscription),
    );
  }
}

class AnonymousTraineeCard extends StatelessWidget {
  final SubscriptionsRecord subscription;

  const AnonymousTraineeCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    return UserInfoRow(
      goal: subscription.goal,
      subscription: subscription,
      isAnonymous: true,
    );
  }
}

class TraineeCard extends StatelessWidget {
  final SubscriptionsRecord subscription;

  const TraineeCard({
    super.key,
    required this.subscription,
  });

  Future<Map<String, dynamic>> _fetchTraineeAndUserData(
      DocumentReference traineeRef) async {
    final traineeDoc = await TraineeRecord.getDocument(traineeRef).first;
    if (traineeDoc.user == null) {
      throw Exception('Trainee user reference is null');
    }

    final userDoc = await UserRecord.getDocument(traineeDoc.user!).first;
    return {
      'trainee': traineeDoc,
      'user': userDoc,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (subscription.trainee == null) {
      return AnonymousTraineeCard(subscription: subscription);
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchTraineeAndUserData(subscription.trainee!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading data',
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
          );
        }

        final traineeRecord = snapshot.data!['trainee'] as TraineeRecord;
        final userRecord = snapshot.data!['user'] as UserRecord;

        return UserInfoRow(
          userRecord: userRecord,
          goal: traineeRecord.goal,
          subscription: subscription,
        );
      },
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final UserRecord? userRecord;
  final String goal;
  final SubscriptionsRecord subscription;
  final bool isAnonymous;

  const UserInfoRow({
    super.key,
    this.userRecord,
    required this.goal,
    required this.subscription,
    this.isAnonymous = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: ResponsiveUtils.width(context, 50),
                  height: ResponsiveUtils.height(context, 50),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 25)),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 25)),
                    child: isAnonymous
                        ? Icon(
                            Icons.person_outline,
                            color: FlutterFlowTheme.of(context).primary,
                            size: ResponsiveUtils.iconSize(context, 30),
                          )
                        : Image.network(
                            userRecord?.photoUrl ??
                                'https://picsum.photos/seed/794/600',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person_outline,
                              color: FlutterFlowTheme.of(context).primary,
                              size: ResponsiveUtils.iconSize(context, 30),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.width(context, 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: AppStyles.textCairo(
                          context,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtils.fontSize(context, 16),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        goal,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.width(context, 12), 
              vertical: ResponsiveUtils.height(context, 8)
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: FlutterFlowTheme.of(context).success,
                  size: ResponsiveUtils.iconSize(context, 16),
                ),
                SizedBox(width: ResponsiveUtils.width(context, 4)),
                Text(
                  FFLocalizations.of(context).getText('3zm1gqar'),
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).success,
                    fontSize: ResponsiveUtils.fontSize(context, 12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
