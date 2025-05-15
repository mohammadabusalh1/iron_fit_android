// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/services/notification_service.dart';
import 'package:iron_fit/services/notification_manager.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class NotificationButton extends StatefulWidget {
  final TraineeRecord trainee;
  final NotificationService notificationService;

  const NotificationButton({
    required this.trainee,
    required this.notificationService,
    super.key,
  });

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class ProcessedNotification {
  static final Set<String> processedNotificationIds = {};
  // Set to track already processed subscription IDs
  static final Set<String> processedSubscriptionIds = {};

  static bool isNotificationProcessed(String notificationId) =>
      processedNotificationIds.contains(notificationId);

  static bool isSubscriptionProcessed(String subscriptionId) =>
      processedSubscriptionIds.contains(subscriptionId);

  static void markNotificationProcessed(String notificationId) =>
      processedNotificationIds.add(notificationId);

  static void markSubscriptionProcessed(String subscriptionId) =>
      processedSubscriptionIds.add(subscriptionId);
}

class _NotificationButtonState extends State<NotificationButton> {
  int notificationCount = 0;
  // Set to track already processed notification IDs

  List<Widget> _buildMenuItems(BuildContext context, List notifications) {
    if (notifications.isEmpty) {
      return [
        Padding(
          padding: ResponsiveUtils.padding(context, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: ResponsiveUtils.iconSize(context, 48),
                color: FlutterFlowTheme.of(context)
                    .secondaryText
                    .withValues(alpha: 0.5),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              Text(
                FFLocalizations.of(context).getText('NoNotifications'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      ];
    }

    return [
      ...notifications,
    ];
  }

  PopupMenuItem createRequestNotificationItem(
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
                  margin: ResponsiveUtils.padding(context, vertical: 4),
                  duration: const Duration(milliseconds: 300),
                  padding: ResponsiveUtils.padding(context,
                      horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: FlutterFlowTheme.of(context)
                            .black
                            .withValues(alpha: 0.05),
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
                            size: ResponsiveUtils.iconSize(context, 20),
                          ),
                          SizedBox(width: ResponsiveUtils.width(context, 8)),
                          Text(
                            FFLocalizations.of(context)
                                .getText('SubscriptionRequest'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.height(context, 8)),
                      Text(
                        '${FFLocalizations.of(context).getText('coach_label')}: ${user.displayName}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Text(
                        '${FFLocalizations.of(context).getText('s3kxq2nc')}: ${doc.amountPaid}, ${FFLocalizations.of(context).getText('kcmdk6wv')}: ${doc.debts}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      Text(
                        '${FFLocalizations.of(context).getText('40ue080t')}: ${dateTimeFormat('yyyy/MM/dd', doc.endDate)}',
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.height(context, 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.check,
                                size: ResponsiveUtils.iconSize(context, 18)),
                            label: Text(
                              FFLocalizations.of(context).getText('accept'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                                color: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                              padding: ResponsiveUtils.padding(context,
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('subscriptions')
                                    .where('trainee',
                                        isEqualTo: widget.trainee.reference)
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
                                  setState(() {});
                                  if (context.mounted) context.pop();
                                });
                              } catch (e, stackTrace) {
                                if (context.mounted) context.pop();
                                Logger.error('Error accepting subscription',
                                    error: e, stackTrace: stackTrace);
                              }
                            },
                          ),
                          SizedBox(width: ResponsiveUtils.width(context, 8)),
                          OutlinedButton.icon(
                            icon: Icon(Icons.close,
                                size: ResponsiveUtils.iconSize(context, 18)),
                            label: Text(
                              FFLocalizations.of(context).getText('reject'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 14),
                                color: FlutterFlowTheme.of(context).error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                              ),
                              padding: ResponsiveUtils.padding(context,
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await doc.reference.delete().then((_) {
                                  setState(() {});
                                  if (context.mounted) context.pop();
                                });
                              } catch (e, stackTrace) {
                                Logger.error('Error rejecting subscription',
                                    error: e, stackTrace: stackTrace);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(FFLocalizations.of(context)
                                          .getText('error_rejecting')),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                  context.pop();
                                }
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

  void _showNotifications(
      BuildContext context,
      List<PopupMenuItem> Unreadednotifications,
      List<PopupMenuItem> readednotifications,
      List<PopupMenuItem> subscriptions,
      List<AlertRecord> notificationsList) async {
    try {
      final mediaQuery = MediaQuery.of(context).size;

      final notifications =
          subscriptions + Unreadednotifications + readednotifications;

      await showDialog(
        context: context,
        barrierColor: FlutterFlowTheme.of(context).black.withValues(alpha: 0.5),
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.width(context, 16),
                vertical: ResponsiveUtils.height(context, 24)),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.width(context, 400),
                maxHeight: mediaQuery.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .black
                        .withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: ResponsiveUtils.padding(context,
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: ResponsiveUtils.iconSize(context, 24)),
                            SizedBox(width: ResponsiveUtils.width(context, 8)),
                            Text(
                              FFLocalizations.of(context)
                                  .getText('Notifications'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 18),
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close,
                              size: ResponsiveUtils.iconSize(context, 24)),
                          onPressed: () => Navigator.pop(context),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Notifications List
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildMenuItems(context, notifications),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.height(context, 16)),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: ResponsiveUtils.padding(context,
                            horizontal: 12, vertical: 12),
                        child: TextButton(
                          onPressed: () {
                            try {
                              // Mark all notifications as read logic would go here
                              context.pop();
                            } catch (e, stackTrace) {
                              Logger.error(
                                  'Error marking notifications as read',
                                  error: e,
                                  stackTrace: stackTrace);
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                FlutterFlowTheme.of(context).primary,
                          ),
                          child: Text(
                            FFLocalizations.of(context)
                                .getText('MarkAllAsRead'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 14),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      for (var notification in notificationsList) {
        final trainees = notification.trainees;

        for (var t in trainees) {
          if (t['ref'] == currentTraineeDocument!.reference && !t['isRead']) {
            t['isRead'] = true;
          }
        }
        await notification.reference.update({'trainees': trainees});
      }
    } catch (e, stackTrace) {
      Logger.error('Error showing notifications dialog',
          error: e, stackTrace: stackTrace);
    }
  }

  // show sound notification for new notifications
  void _processNewNotifications(List<AlertRecord> notifications) {
    for (var notification in notifications) {
      try {
        // Only show notification if we haven't processed this ID before
        if (!ProcessedNotification.isNotificationProcessed(
            notification.reference.id)) {
          widget.notificationService.showSoundNotification(
              title: notification.name, body: notification.desc);

          // Add this notification ID to our processed set
          ProcessedNotification.markNotificationProcessed(
              notification.reference.id);
        }
      } catch (e, stackTrace) {
        Logger.error('Error showing sound notification',
            error: e, stackTrace: stackTrace);
      }
    }
  }

  //  show sound notification for new subscription requests
  void _processNewSubscriptions(
      List<SubscriptionsRecord> subscriptions, BuildContext context) {
    for (var subscription in subscriptions) {
      try {
        // Only show notification if we haven't processed this ID before
        if (!ProcessedNotification.isSubscriptionProcessed(
            subscription.reference.id)) {
          widget.notificationService.showSoundNotification(
              title: FFLocalizations.of(context).getText('SubscriptionRequest'),
              body: FFLocalizations.of(context)
                  .getText('subscription_requests_from_coach'));

          // Add this subscription ID to our processed set
          ProcessedNotification.markSubscriptionProcessed(
              subscription.reference.id);
        }
      } catch (e, stackTrace) {
        Logger.error('Error showing subscription sound notification',
            error: e, stackTrace: stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AlertRecord>>(
      stream: NotificationManager.streamUnReaddNotifications(widget.trainee),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Logger.error('Error streaming unread notifications',
              error: snapshot.error, stackTrace: snapshot.stackTrace);
          return const SizedBox();
        }

        if (!snapshot.hasData) return const SizedBox();

        final notifications = snapshot.data!;

        // show sound notification for new notifications
        _processNewNotifications(notifications);

        List<PopupMenuItem<dynamic>> unReadedItems = [];
        try {
          unReadedItems = notifications
              .map((doc) => NotificationManager.createNotificationItem(
                  doc, false, context))
              .toList();
        } catch (e, stackTrace) {
          Logger.error('Error creating unread notification items',
              error: e, stackTrace: stackTrace);
        }

        return StreamBuilder<List<AlertRecord>>(
          stream: NotificationManager.streamReaddNotifications(widget.trainee),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Logger.error('Error streaming read notifications',
                  error: snapshot.error, stackTrace: snapshot.stackTrace);
              return const SizedBox();
            }

            if (!snapshot.hasData) return const SizedBox();

            final readNotifications = snapshot.data!;

            List<PopupMenuItem<dynamic>> readedItems = [];
            try {
              readedItems = readNotifications
                  .map((doc) => NotificationManager.createNotificationItem(
                      doc, true, context))
                  .toList();
            } catch (e, stackTrace) {
              Logger.error('Error creating read notification items',
                  error: e, stackTrace: stackTrace);
            }

            return StreamBuilder<List<SubscriptionsRecord>>(
              stream: NotificationManager.streamSubscriptionNotifications(
                  widget.trainee),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  Logger.error('Error streaming subscription notifications',
                      error: snapshot.error, stackTrace: snapshot.stackTrace);
                  return const SizedBox();
                }

                if (!snapshot.hasData) return const SizedBox();

                final subscriptionsNotifications = snapshot.data!;

                // show sound notification for new subscription requests
                _processNewSubscriptions(subscriptionsNotifications, context);

                List<PopupMenuItem<dynamic>> subscriptionsItems = [];
                try {
                  subscriptionsItems = subscriptionsNotifications
                      .asMap()
                      .entries
                      .map((entry) => createRequestNotificationItem(
                          entry.value, entry.key, context))
                      .toList();
                } catch (e, stackTrace) {
                  Logger.error('Error creating subscription notification items',
                      error: e, stackTrace: stackTrace);
                }

                notificationCount =
                    notifications.length + subscriptionsNotifications.length;

                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: Theme.of(context).iconTheme.color,
                        size: ResponsiveUtils.iconSize(context, 24),
                      ),
                      onPressed: () => _showNotifications(
                        context,
                        unReadedItems,
                        readedItems,
                        subscriptionsItems,
                        notifications,
                      ),
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 1,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          constraints: BoxConstraints(
                            minWidth: ResponsiveUtils.width(context, 20),
                            minHeight: ResponsiveUtils.height(context, 12),
                          ),
                          child: Text(
                            notificationCount.toString(),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 9),
                              color: FlutterFlowTheme.of(context).info,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
