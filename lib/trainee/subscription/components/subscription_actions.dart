import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/utils/logger.dart';

class SubscriptionActions extends StatelessWidget {
  const SubscriptionActions({super.key});

  Future<NutPlanRecord?> getNutPlanRecord() async {
    try {
      Logger.info('Fetching nutrition plan for current user');
      final traineeQuery = await FirebaseFirestore.instance
          .collection('trainee')
          .where('user', isEqualTo: currentUserReference)
          .limit(1)
          .get();

      if (traineeQuery.docs.isEmpty) {
        Logger.warning('No trainee record found for current user');
        return null;
      }

      final traineeDoc = traineeQuery.docs.first;
      Logger.debug('Trainee document found: ${traineeDoc.id}');

      final subQuery = await FirebaseFirestore.instance
          .collection('subscriptions')
          .where('trainee', isEqualTo: traineeDoc.reference)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (subQuery.docs.isEmpty) {
        Logger.warning('No active subscription found for trainee');
        return null;
      }

      final subDoc = subQuery.docs.first;
      Logger.debug('Subscription document found: ${subDoc.id}');

      final nutPlanRef = subDoc.data()['nutPlan'];
      if (nutPlanRef == null) {
        Logger.warning('Nutrition plan reference is null in subscription');
        return null;
      }

      final nutPlanDoc = NutPlanRecord.getDocument(nutPlanRef);
      final nutPlan = await nutPlanDoc.first;
      Logger.info('Successfully retrieved nutrition plan');

      return nutPlan;
    } catch (e, stackTrace) {
      Logger.error('Error fetching nutrition plan', e, stackTrace);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FFButtonWidget(
          onPressed: () async {
            final nuPlan = await getNutPlanRecord();
            if (nuPlan != null) {
              Logger.debug('Navigating to nutrition plan details screen');
              context.pushNamed(
                'nutPlanDetialsUser',
                queryParameters: {
                  'nuPlan': serializeParam(
                    nuPlan,
                    ParamType.Document,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  'nuPlan': nuPlan,
                },
              );
            } else {
              Logger.debug('Showing error message - nutrition plan not found');
              if (context.mounted) {
                showErrorDialog(
                    FFLocalizations.of(context)
                        .getText('nutritionPlanNotFound'),
                    context);
              }
            }
          },
          text: FFLocalizations.of(context).getText('viewNutritionPlan'),
          icon: Icon(
            Icons.restaurant_menu,
            color: FlutterFlowTheme.of(context).info,
            size: 20,
          ),
          options: FFButtonOptions(
            width: MediaQuery.sizeOf(context).width,
            height: 56,
            padding: const EdgeInsets.all(8),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).info),
            elevation: 3,
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        FFButtonWidget(
          onPressed: () {
            try {
              Logger.debug('Navigating to training plan screen');
              context.pushNamed('days');
            } catch (e, stackTrace) {
              Logger.error('Error navigating to training plan', e, stackTrace);
              if (context.mounted) {
                showErrorDialog(
                    FFLocalizations.of(context)
                        .getText('errorNavigatingToTrainingPlan'),
                    context);
              }
            }
          },
          text: FFLocalizations.of(context).getText('viewTrainingPlan'),
          icon: Icon(
            Icons.fitness_center,
            color: FlutterFlowTheme.of(context).primary,
            size: 20,
          ),
          options: FFButtonOptions(
            width: MediaQuery.sizeOf(context).width,
            height: 56,
            padding: const EdgeInsets.all(8),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            color: const Color(0x00FFFFFF),
            textStyle: AppStyles.textCairo(context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primary),
            elevation: 0,
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ].divide(const SizedBox(height: 16)),
    );
  }
}
