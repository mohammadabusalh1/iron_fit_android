import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/coach/subscription/componants/plan_feature_item.dart';
import 'package:iron_fit/coach/subscription/componants/plan_header_section.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/componants/Styles.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String? saveText;
  final Color? saveBackgroundColor;
  final Color? saveTextColor;
  final List<String> features;
  final String buttonText;
  final String paypalAmount;
  final Function(DateTime) updateSubscriptionDate;

  const SubscriptionPlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    this.saveText,
    this.saveBackgroundColor,
    this.saveTextColor,
    required this.features,
    required this.buttonText,
    required this.paypalAmount,
    required this.updateSubscriptionDate,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width once at beginning
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = FlutterFlowTheme.of(context);

    // Pre-compute features list to avoid rebuilding in the widget tree
    final featureWidgets = features
        .map((feature) => PlanFeatureItem(featureText: feature))
        .toList();

    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
      ),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius:
              BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            ResponsiveUtils.width(context, 24),
            ResponsiveUtils.height(context, 24),
            ResponsiveUtils.width(context, 24),
            ResponsiveUtils.height(context, 24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  ResponsiveUtils.width(context, 16),
                  0,
                  ResponsiveUtils.width(context, 16),
                  0,
                ),
                child: PlanHeaderSection(
                  title: title,
                  price: price,
                  description: description,
                  saveText: saveText,
                  saveBackgroundColor: saveBackgroundColor,
                  saveTextColor: saveTextColor,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  ResponsiveUtils.width(context, 16),
                  0,
                  ResponsiveUtils.width(context, 16),
                  0,
                ),
                child: Container(
                  width: screenWidth,
                  height: ResponsiveUtils.height(context, 1),
                  decoration: BoxDecoration(
                    color: theme.alternate,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  ResponsiveUtils.width(context, 16),
                  0,
                  ResponsiveUtils.width(context, 16),
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: featureWidgets.divide(
                      SizedBox(height: ResponsiveUtils.height(context, 12))),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  ResponsiveUtils.width(context, 16),
                  0,
                  ResponsiveUtils.width(context, 16),
                  0,
                ),
                child: FFButtonWidget(
                  onPressed: () => _handleSubscription(context),
                  text: buttonText,
                  options: FFButtonOptions(
                    width: screenWidth,
                    height: ResponsiveUtils.height(context, 50),
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: theme.primary,
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(
                        ResponsiveUtils.width(context, 25)),
                  ),
                ),
              ),
            ].divide(SizedBox(height: ResponsiveUtils.height(context, 16))),
          ),
        ),
      ),
    );
  }

  Future<void> _keyEvent() async {
    try {
      await EventsRecord.collection.add(
        createEventsRecordData(
          type: 'click_pay',
          timestamp: DateTime.now(),
          coach: currentCoachDocument!.reference,
          data: {
            'page': 'subscriptions',
            'email': currentUserEmail,
          },
        ),
      );
    } catch (e) {
      debugPrint('Error saving session duration: $e');
    }
  }

  void _handleSubscription(BuildContext context) {
    try {
      _keyEvent();
      // Validate environment variables
      final clientId = dotenv.env['ClientID'];
      final secretKey = dotenv.env['SecretKey'];

      if (clientId == null ||
          clientId.isEmpty ||
          secretKey == null ||
          secretKey.isEmpty) {
        Logger.error('PayPal credentials not configured properly');
        functions.showErrorDialog(
            'Payment configuration error. Please contact support.', context);
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: false,
            clientId: clientId,
            secretKey: secretKey,
            transactions: [
              {
                "amount": {
                  "total": paypalAmount,
                  "currency": "USD",
                  "details": {
                    "subtotal": paypalAmount,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                "item_list": {
                  "items": [
                    {
                      "name": "IronFit",
                      "quantity": 1,
                      "price": paypalAmount,
                      "currency": "USD"
                    },
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              try {
                Logger.info('Payment successful: ${params.toString()}');

                // Fetch coach record
                final coach = await queryCoachRecordOnce(
                  singleRecord: true,
                  queryBuilder: (p0) => p0.where(
                    'user',
                    isEqualTo: currentUserReference,
                  ),
                ).then((s) => s.firstOrNull);

                // Check if coach exists
                if (coach == null) {
                  Logger.error(
                      'Coach record not found for user: ${currentUserReference?.id}');
                  throw Exception("Coach record not found.");
                }

                // Get appropriate date based on plan
                DateTime endDate;
                if (title.toLowerCase() == 'monthly') {
                  endDate = functions.afterMonth() ??
                      DateTime.now().add(const Duration(days: 30));
                } else if (title.toLowerCase() == 'quarterly') {
                  endDate = functions.afterThreeMonth() ??
                      DateTime.now().add(const Duration(days: 90));
                } else if (title.toLowerCase() == 'annual') {
                  endDate = functions.afterYear() ??
                      DateTime.now().add(const Duration(days: 365));
                } else {
                  Logger.warning(
                      'Unknown plan type: $title, defaulting to monthly');
                  endDate = functions.afterMonth() ??
                      DateTime.now().add(const Duration(days: 30));
                }

                // Update coach record
                await coach.reference.update(
                  createCoachRecordData(
                    isSub: true,
                    subEndDate: endDate,
                  ),
                );

                Logger.info(
                    'Subscription updated successfully for coach: ${coach.reference.id}');

                // Call the callback to update the parent state
                updateSubscriptionDate(endDate);
              } catch (e, stackTrace) {
                // Log the error
                Logger.error('Error updating coach record after payment',
                    error: e, stackTrace: stackTrace);

                // Notify the user
                functions.showErrorDialog(
                    FFLocalizations.of(context).getText('2184r6dy'), context);
              }
            },
            onError: (error) {
              // Log and show a user-friendly message
              Logger.error('PayPal payment error', error: error);
              functions.showErrorDialog(
                  FFLocalizations.of(context).getText('2184r6dy'), context);
            },
            onCancel: () {
              Navigator.pushNamed(context, 'mySubscription');
              Logger.info('Payment process was cancelled by user');
              functions.showSuccessDialog(
                FFLocalizations.of(context).getText(
                    'paymentProcessCancelled' /* Payment process was cancelled. */),
                context,
              );
            },
          ),
        ),
      );
    } catch (e, stackTrace) {
      // Log unexpected errors
      Logger.error('Unexpected error during subscription process',
          error: e, stackTrace: stackTrace);
      functions.showErrorDialog(
          FFLocalizations.of(context).getText('2184r6dy'), context);
    }
  }
}
