import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/backend/schema/subscriptions_record.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/dialogs/add_debts/add_debts_widget.dart';
import 'package:iron_fit/dialogs/renew_sub/renew_sub_widget.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/services/trainee_service.dart';
import 'package:iron_fit/utils/logger.dart';

class TraineeHandlers {
  static Future<void> handleRenewSubscription(
    BuildContext context,
    SubscriptionsRecord subscription,
    VoidCallback refreshSubscription,
  ) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return RenewSubWidget(
          subRef: subscription.reference,
          refreshSubscription: refreshSubscription,
        );
      },
    );
  }

  static Future<bool?> showCancelSubscriptionDialog(
    BuildContext context,
    SubscriptionsRecord subscription,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).error.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: FlutterFlowTheme.of(context).error,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  FFLocalizations.of(context).getText('confirm'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context).getText('areYouSure'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('cancel'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            Logger.info('Attempting to cancel subscription');
                            await TraineeService()
                                .deleteSubscription(subscription);
                            Logger.info('Subscription canceled successfully');
                            if (context.mounted) {
                              showSuccessDialog(
                                  FFLocalizations.of(context)
                                      .getText('subscriptionCanceled'),
                                  context);
                              context.pop();
                              context.pushNamed('trainees');
                            }
                          } catch (e) {
                            Logger.error('Failed to cancel subscription',
                                error: e, stackTrace: StackTrace.current);
                            if (context.mounted) {
                              showErrorDialog(
                                  FFLocalizations.of(context)
                                      .getText('defaultErrorMessage'),
                                  context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          foregroundColor: FlutterFlowTheme.of(context).info,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('confirm'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> handleAddDebts(
    BuildContext context,
    SubscriptionsRecord subscription,
    VoidCallback refreshSubscription,
  ) async {
    final result = await showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const AddDebtsWidget(),
        );
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      final debt = result['debt'] as double?;
      final title = result['title'] as String?;

      if (debt != null && debt > 0 && title != null && title.isNotEmpty) {
        try {
          Logger.info('Attempting to add debt: $debt, title: $title');
          await TraineeService().addDebts(subscription.reference, debt, title);
          Logger.info('Debt added successfully');
          if (context.mounted) {
            showSuccessDialog(
                FFLocalizations.of(context).getText('debtAdded'), context);
          }
          refreshSubscription();
        } catch (e) {
          Logger.error('Failed to add debt',
              error: e, stackTrace: StackTrace.current);
          if (context.mounted) {
            showErrorDialog(
                FFLocalizations.of(context).getText('l7kfx3m8'), context);
          }
        }
      }
    }
  }

  static Future<void> handleRemoveDebts(
    BuildContext context,
    SubscriptionsRecord subscription,
    VoidCallback refreshSubscription,
  ) async {
    final result = await showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const AddDebtsWidget(isDebtRemoval: true),
        );
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      final debt = result['debt'] as double?;
      final title = result['title'] as String?;

      if (debt != null && debt > 0 && title != null && title.isNotEmpty) {
        if (debt > subscription.debts) {
          Logger.warning(
              'Removal debt amount ($debt) exceeds current debt (${subscription.debts})');
          if (context.mounted) {
            showErrorDialog(
                FFLocalizations.of(context).getText('numberIsBigThanDebts'),
                context);
          }
          return;
        }

        try {
          Logger.info('Attempting to remove debt: $debt, title: $title');
          await TraineeService()
              .removeDebts(subscription.reference, debt, title);
          Logger.info('Debt removed successfully');
          if (context.mounted) {
            showSuccessDialog(
                FFLocalizations.of(context).getText('debtRemoved'), context);
          }
          refreshSubscription();
        } catch (e) {
          Logger.error('Failed to remove debt',
              error: e, stackTrace: StackTrace.current);
          if (context.mounted) {
            showErrorDialog(
                FFLocalizations.of(context).getText('l7kfx3m8'), context);
          }
        }
      }
    }
  }

  static Future<void> handleViewBills(
    BuildContext context,
    SubscriptionsRecord subscription,
  ) async {
    try {
      Logger.info('Viewing bills history for subscription');
      final sortedBills = subscription.bills.toList()
        ..sort(
            (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

      if (sortedBills.isEmpty) {
        Logger.info('No bills found for this subscription');
      } else {
        Logger.info('Found ${sortedBills.length} bills');
      }

      // Get screen size for responsive design
      final screenSize = MediaQuery.of(context).size;
      final isSmallScreen = screenSize.width < 600;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: isSmallScreen ? 0.9 : 0.85,
            minChildSize: isSmallScreen ? 0.6 : 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .secondaryText
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Header with adaptable padding
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16.0 : 24.0,
                        vertical: isSmallScreen ? 12.0 : 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              FFLocalizations.of(context)
                                  .getText('paymentHistory'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.w700,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: isSmallScreen ? 22 : 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Content with responsive layout
                    Expanded(
                      child: sortedBills.isEmpty
                          ? RefreshIndicator(
                              onRefresh: () async {
                                // Add refresh logic here if needed
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight * 2,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            isSmallScreen ? 16 : 24),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  isSmallScreen ? 12 : 16),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary
                                                        .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.receipt_long_outlined,
                                                size: isSmallScreen ? 36 : 48,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    isSmallScreen ? 16 : 24),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText('noBillsYet'),
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize:
                                                    isSmallScreen ? 16 : 18,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            SizedBox(
                                                height: isSmallScreen ? 6 : 8),
                                            Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                      'billsWillAppearHere'),
                                              textAlign: TextAlign.center,
                                              style: AppStyles.textCairo(
                                                context,
                                                fontSize:
                                                    isSmallScreen ? 12 : 14,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                // Add refresh logic here if needed
                              },
                              child: OrientationBuilder(
                                  builder: (context, orientation) {
                                // Adjust layout based on orientation
                                final itemHeight =
                                    orientation == Orientation.portrait
                                        ? (isSmallScreen ? 100.0 : 120.0)
                                        : 100.0;

                                return ListView.builder(
                                  controller: scrollController,
                                  padding:
                                      EdgeInsets.all(isSmallScreen ? 16 : 24),
                                  itemCount: sortedBills.length,
                                  cacheExtent: 200,
                                  itemExtent: itemHeight,
                                  addRepaintBoundaries: true,
                                  itemBuilder: (context, index) {
                                    final bill = sortedBills[index];
                                    return billItem(
                                      bill: bill,
                                      context: context,
                                      isSmallScreen: isSmallScreen,
                                    );
                                  },
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      Logger.info('Bills history view closed');
    } catch (e) {
      Logger.error('Error while viewing bills history',
          error: e, stackTrace: StackTrace.current);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
    }
  }

  static Widget billItem({
    required Map<String, dynamic> bill,
    required BuildContext context,
    bool isSmallScreen = false,
  }) {
    // Determine if we're in landscape mode
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Generate a unique tag for hero animation
    final heroTag = 'bill-${bill['date'].millisecondsSinceEpoch}';

    // Format amount for better readability
    final formattedAmount = '${bill['paid']} \$';

    return Hero(
      tag: heroTag,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              _showModernBillDetailsDialog(
                context,
                bill,
                isSmallScreen,
                heroTag,
                formattedAmount,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
              child: Row(
                children: [
                  // Icon with shimmer effect
                  ShimmerIcon(
                    icon: Icons.receipt_rounded,
                    context: context,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(width: isSmallScreen ? 14 : 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedAmount,
                          style: AppStyles.textCairo(
                            context,
                            fontSize: isSmallScreen ? 17 : 20,
                            fontWeight: FontWeight.w700,
                            color: FlutterFlowTheme.of(context).success,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: isSmallScreen ? 12 : 14,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            SizedBox(width: 4),
                            Text(
                              dateTimeFormat(
                                isLandscape || isSmallScreen
                                    ? 'yMMMd'
                                    : 'relative',
                                (bill['date'] as DateTime),
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: isSmallScreen ? 12 : 14,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern shimmer icon for bill item
  static Widget ShimmerIcon({
    required IconData icon,
    required BuildContext context,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary.withOpacity(0.7),
            FlutterFlowTheme.of(context).primary.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: isSmallScreen ? 20 : 24,
      ),
    );
  }

  // Modern bill details dialog
  static void _showModernBillDetailsDialog(
    BuildContext context,
    Map<String, dynamic> bill,
    bool isSmallScreen,
    String heroTag,
    String formattedAmount,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Bill Details",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: isSmallScreen ? 24 : 32,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: isSmallScreen ? 20 : 24,
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: heroTag,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.receipt_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context)
                                      .getText('paymentDetails'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: isSmallScreen ? 20 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dateTimeFormat(
                                    'MMMMd',
                                    (bill['date'] as DateTime),
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bill amount card
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .success
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .success
                              .withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .success
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.attach_money_rounded,
                              color: FlutterFlowTheme.of(context).success,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context)
                                      .getText('s3kxq2nc'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 14,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedAmount,
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Payment details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText('paymentInfo'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            context,
                            Icons.calendar_today_rounded,
                            FFLocalizations.of(context).getText('date'),
                            dateTimeFormat(
                              'yMMMd',
                              (bill['date'] as DateTime),
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            isSmallScreen,
                          ),
                          const SizedBox(height: 16),
                          _buildModernDetailRow(
                            context,
                            Icons.access_time_rounded,
                            FFLocalizations.of(context).getText('time_label'),
                            dateTimeFormat(
                              'jm',
                              (bill['date'] as DateTime),
                              locale: FFLocalizations.of(context).languageCode,
                            ),
                            isSmallScreen,
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                // Share functionality could be added here
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.share_rounded,
                                size: 20,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              label: Text(
                                FFLocalizations.of(context).getText('share'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 14,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 20,
                              ),
                              label: Text(
                                FFLocalizations.of(context).getText('done'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Modern detail row for bill details
  static Widget _buildModernDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.textCairo(
                  context,
                  fontSize: isSmallScreen ? 12 : 14,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.textCairo(
                  context,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Future<bool?> handleDeleteTrainingPlan(
    BuildContext context,
    SubscriptionsRecord subscription,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).error.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: FlutterFlowTheme.of(context).error,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  FFLocalizations.of(context).getText('deleteTrainingPlan'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context).getText('confirmDeletePlan'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('cancel'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            Logger.info('Attempting to delete training plan');
                            await subscription.reference
                                .update({'plan': FieldValue.delete()});
                            Logger.info('Training plan deleted successfully');
                            if (context.mounted) {
                              showSuccessDialog(
                                  FFLocalizations.of(context)
                                      .getText('planDeleted'),
                                  context);
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            Logger.error('Failed to delete training plan',
                                error: e, stackTrace: StackTrace.current);
                            if (context.mounted) {
                              showErrorDialog(
                                  FFLocalizations.of(context)
                                      .getText('errorOccurred'),
                                  context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          foregroundColor: FlutterFlowTheme.of(context).info,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('confirm'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> handleDeleteNutritionalPlan(
    BuildContext context,
    SubscriptionsRecord subscription,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).error.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          color: FlutterFlowTheme.of(context).error,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  FFLocalizations.of(context).getText('deleteNutritionalPlan'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context).getText('confirmDeletePlan'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('cancel'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            Logger.info(
                                'Attempting to delete nutritional plan');
                            await subscription.reference
                                .update({'nutPlan': FieldValue.delete()});
                            Logger.info(
                                'Nutritional plan deleted successfully');
                            if (context.mounted) {
                              showSuccessDialog(
                                  FFLocalizations.of(context)
                                      .getText('planDeleted'),
                                  context);
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            Logger.error('Failed to delete nutritional plan',
                                error: e, stackTrace: StackTrace.current);
                            if (context.mounted) {
                              showErrorDialog(
                                  FFLocalizations.of(context)
                                      .getText('errorOccurred'),
                                  context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          foregroundColor: FlutterFlowTheme.of(context).info,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          FFLocalizations.of(context).getText('confirm'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> handleSavePlans(
    BuildContext context,
    SubscriptionsRecord subscription,
    PlansRecord? trainingPlan,
    NutPlanRecord? nutPlan,
  ) async {
    try {
      Logger.info('Attempting to save training and nutritional plans');
      await TraineeService().savePlans(
        context,
        subscription,
        trainingPlan,
        nutPlan,
        currentUserReference,
      );
      Logger.info('Plans saved successfully');
      if (context.mounted) {
        showSuccessDialog(
            FFLocalizations.of(context).getText('plansSaved'), context);
      }
    } catch (e) {
      Logger.error('Failed to save plans',
          error: e, stackTrace: StackTrace.current);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
    }
  }

  static Future<void> handleSaveNotes(
    BuildContext context,
    SubscriptionsRecord subscription,
    TextEditingController notesController,
  ) async {
    try {
      Logger.info('Attempting to save notes');
      await TraineeService().saveNotes(
        subscription.reference,
        notesController.text,
      );
      Logger.info('Notes saved successfully');
      if (context.mounted) {
        showSuccessDialog(
            FFLocalizations.of(context).getText('notesSaved'), context);
      }
    } catch (e) {
      Logger.error('Failed to save notes',
          error: e, stackTrace: StackTrace.current);
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
    }
  }
}
