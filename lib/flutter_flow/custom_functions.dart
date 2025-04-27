import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/logger.dart';

DateTime? nowDate() {
  return DateTime.now();
}

double sunValues(List<double> a) {
  double total = 0;
  for (double number in a) {
    total += number;
  }
  return total;
}

DateTime? afterMonth() {
  DateTime now = DateTime.now();
  // Adding one month (30 days) to the current date
  DateTime afterMonth = now.add(const Duration(days: 30));
  return afterMonth;
}

DateTime? afterThreeMonth() {
  DateTime now = DateTime.now();
  DateTime afterThreeMonth = now.add(const Duration(days: 90));
  return afterThreeMonth;
}

DateTime? afterYear() {
  DateTime now = DateTime.now();
  // Adding one month (30 days) to the current date
  DateTime afterYear = now.add(const Duration(days: 365));
  return afterYear;
}

Future<void> showDebtsModal(
    SubscriptionsRecord traineeSubscriptionsRecord, context) async {
  try {
    Logger.info('Showing debts modal for subscription');

    final sortedDebts = List<Map<String, dynamic>>.from(
        traineeSubscriptionsRecord.debtList)
      ..sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    if (sortedDebts.isEmpty) {
      Logger.info('No debts found for this subscription');
    } else {
      Logger.info('Found ${sortedDebts.length} debts');
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
      builder: (context) {
        return _buildDebtsModalContent(context, sortedDebts);
      },
    );

    Logger.info('Debts modal closed');
  } catch (e) {
    Logger.error('Error while showing debts modal', e, StackTrace.current);
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(FFLocalizations.of(context).getText('errorOccurred')),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }
}

Widget _buildDebtsModalContent(
    BuildContext context, List<Map<String, dynamic>> sortedDebts) {
  final totalDebts = sortedDebts.fold<double>(
    0,
    (sum, debt) => sum + (debt['type'] == '+' ? debt['debt'] : -debt['debt']),
  );

  return Container(
    height: MediaQuery.of(context).size.height * 0.85,
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
        // Handle bar with improved design
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context)
                .secondaryText
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header with total balance
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Text(
                FFLocalizations.of(context).getText('viewAllDebts'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: totalDebts >= 0
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      totalDebts >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: totalDebts >= 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${totalDebts >= 0 ? '+' : ''}${totalDebts.toStringAsFixed(2)}',
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: totalDebts >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Debts List
        Expanded(
          child: sortedDebts.isEmpty
              ? _buildEmptyDebtState(context)
              : _buildDebtsList(context, sortedDebts),
        ),
      ],
    ),
  );
}

Widget _buildEmptyDebtState(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.money_off,
            size: 48,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          FFLocalizations.of(context).getText('noDebtsYet'),
          style: AppStyles.textCairo(
            context,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add your first transaction to get started',
          style: AppStyles.textCairo(
            context,
            fontSize: 14,
            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.7),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDebtsList(
    BuildContext context, List<Map<String, dynamic>> sortedDebts) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 16),
    itemCount: sortedDebts.length,
    itemBuilder: (context, index) {
      final debt = sortedDebts[index];
      final isIncome = debt['type'] == '+';
      final amount = debt['debt'];

      return Container(
        key: ValueKey('debt-${debt['date']}-${index}'),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Add interaction feedback if needed
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isIncome
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isIncome ? Icons.add_circle : Icons.remove_circle,
                      color: isIncome ? Colors.green : Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debt['name'],
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(debt['date']),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 14,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isIncome ? Colors.green : Colors.red,
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

void showErrorDialog(String message, context) {
  try {
    if (context.mounted) {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SizedBox.shrink(),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: FadeTransition(
              opacity: curvedAnimation,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                title: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: FlutterFlowTheme.of(context).error,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        FFLocalizations.of(context).getText('error'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).error,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      FFLocalizations.of(context).getText('ok'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black54,
      );
    }
  } catch (e) {
    Logger.error('Error while showing error dialog', e, StackTrace.current);
  }
}

void showSuccessDialog(String message, context) {
  // Create a pre-built SnackBar to avoid rebuilding in the ScaffoldMessenger
  final snackBar = SnackBar(
    content: Text(
      message,
      style: AppStyles.textCairo(
        context,
        color: FlutterFlowTheme.of(context).info,
      ),
    ),
    backgroundColor: FlutterFlowTheme.of(context).primary,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void onNavItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.pushNamed('CoachHome');
      break;
    case 1:
      context.pushNamed('trainees');
      break;
    case 2:
      context.pushNamed('plansRoutes');
      break;
    case 3:
      context.pushNamed('coachAnalytics');
      break;
    case 4:
      context.pushNamed('CoachProfile');
      break;
  }

  // Get FCM token for push notifications
}
