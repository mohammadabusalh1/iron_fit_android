import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/logger.dart';
import '../auth/firebase_auth/auth_util.dart';
import '../backend/backend.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  Future<void> initialize(BuildContext context) async {}

  static Stream<List<AlertRecord>> streamReaddNotifications(
      TraineeRecord trainee) {
    return queryAlertRecord(
      queryBuilder: (alertRecord) => alertRecord.where('trainees',
          arrayContains: {'ref': trainee.reference, 'isRead': true}),
    );
  }

  static Stream<List<AlertRecord>> streamUnReaddNotifications(
      TraineeRecord trainee) {
    return queryAlertRecord(
      queryBuilder: (alertRecord) => alertRecord.where('trainees',
          arrayContains: {'ref': trainee.reference, 'isRead': false}),
    );
  }

  static Stream<List<SubscriptionsRecord>> streamSubscriptionNotifications(
      TraineeRecord trainee) {
    return querySubscriptionsRecord(
      queryBuilder: (subscriptionsRecord) => subscriptionsRecord
          .where('trainee', isEqualTo: trainee.reference)
          .where('isActive', isEqualTo: false),
    );
  }

  static PopupMenuItem createRequestNotificationItem(
      SubscriptionsRecord doc, int index, BuildContext context) {
    return PopupMenuItem(
      child: FutureBuilder<CoachRecord>(
        future: CoachRecord.getDocument(doc.coach!).first,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final coachData = snapshot.data!;
          return FutureBuilder(
              future: UserRecord.getDocument(coachData.user!).first,
              builder: (context, snapshot2) {
                if (!snapshot2.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final user = snapshot2.data!;
                return AnimatedContainer(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            FFLocalizations.of(context)
                                .getText('SubscriptionRequest'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${FFLocalizations.of(context).getText('coach_label')}: ${user.displayName}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Text(
                        '${FFLocalizations.of(context).getText('s3kxq2nc')}: ${doc.amountPaid}, ${FFLocalizations.of(context).getText('kcmdk6wv')}: ${doc.debts}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Text(
                        '${FFLocalizations.of(context).getText('40ue080t')}: ${dateTimeFormat('yyyy/MM/dd', doc.endDate)}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check, size: 18),
                            label: Text(
                              FFLocalizations.of(context).getText('accept'),
                              style: AppStyles.textCairo(
                                context,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                if (currentUserReference == null) return;
                                final trainee = await queryTraineeRecord(
                                  queryBuilder: (traineeRecord) =>
                                      traineeRecord.where(
                                    'user',
                                    isEqualTo: currentUserReference,
                                  ),
                                  singleRecord: true,
                                ).first;

                                await FirebaseFirestore.instance
                                    .collection('subscriptions')
                                    .where('trainee',
                                        isEqualTo: trainee.first.reference)
                                    .get()
                                    .then((querySnapshot) {
                                  for (var subDoc in querySnapshot.docs) {
                                    if (doc.reference == subDoc.reference) {
                                      doc.reference.update({
                                        'isActive': true,
                                      });
                                    } else {
                                      subDoc.reference.delete();
                                    }
                                  }
                                }).then((_) {
                                  context.pop();
                                });
                              } catch (e) {
                                context.pop();
                                Logger.error(
                                    'Error accepting subscription: $e');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 18),
                            label: Text(
                              FFLocalizations.of(context).getText('reject'),
                              style: AppStyles.textCairo(
                                context,
                                color: FlutterFlowTheme.of(context).error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await doc.reference.delete();
                                Navigator.pop(context);
                              } catch (e) {
                                Logger.error(
                                    'Error rejecting subscription: $e');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  static PopupMenuItem createNotificationItem(
      AlertRecord doc, bool isRead, BuildContext context) {
    return PopupMenuItem(
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 4),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? FlutterFlowTheme.of(context).secondaryBackground
              : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isRead
                      ? Icons.notifications_none
                      : Icons.notifications_active,
                  color: isRead
                      ? FlutterFlowTheme.of(context).secondaryText
                      : FlutterFlowTheme.of(context).primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doc.name,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isRead
                          ? FlutterFlowTheme.of(context).secondaryText
                          : FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
                if (isRead)
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: FlutterFlowTheme.of(context).success,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.desc,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateTimeFormat('relative', doc.date),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<List<AlertRecord>> getUnreadNotifications(
      TraineeRecord trainee) async {
    final querySnapshot = await queryAlertRecord(
      queryBuilder: (alertRecord) => alertRecord.where(
        'trainees',
        arrayContains: {
          'ref': trainee.reference,
          'isRead': false,
        },
      ),
    ).first;
    return querySnapshot;
  }

  static Future<List<AlertRecord>> getReadNotifications(
      TraineeRecord trainee) async {
    final querySnapshot = await queryAlertRecord(
      queryBuilder: (alertRecord) => alertRecord.where(
        'trainees',
        arrayContains: {
          'ref': trainee.reference,
          'isRead': true,
        },
      ),
    ).first;
    return querySnapshot;
  }

  static Future<List<SubscriptionsRecord>> getSubscriptionRequests(
      TraineeRecord trainee) async {
    final querySnapshot = await querySubscriptionsRecord(
      queryBuilder: (subscriptionsRecord) => subscriptionsRecord
          .where('trainee', isEqualTo: trainee.reference)
          .where('isActive', isEqualTo: false),
    ).first;
    return querySnapshot;
  }
}
