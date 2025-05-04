import 'package:iron_fit/Ad/AdService.dart';
import 'package:iron_fit/componants/CheckSubscribe/check_subscribe.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/coach/nutrition_plans/components/components.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/pages/error_page/error_page_widget.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'nutrition_plans_model.dart';
export 'nutrition_plans_model.dart';

class NutritionPlansWidget extends StatefulWidget {
  const NutritionPlansWidget({super.key});

  @override
  State<NutritionPlansWidget> createState() => _NutritionPlansWidgetState();
}

class _NutritionPlansWidgetState extends State<NutritionPlansWidget> {
  late NutritionPlansModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AdService _adService;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NutritionPlansModel());
    _adService = AdService();
    
    // Add delay to ad loading
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _adService.loadAd(context);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentCoachDocument == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }
    return _buildScaffold(currentCoachDocument!);
  }

  Widget _buildScaffold(CoachRecord coachRecord) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CoachAppBar.coachAppBar(
          context,
          FFLocalizations.of(context).getText('0pk4v0z4' /* Nutrition Plans */),
          IconButton(
            onPressed: () => context.pushNamed('coachFeatures'),
            icon: const Icon(Icons.arrow_back),
          ),
          null),
      backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
      extendBodyBehindAppBar: true,
      body: Container(
          // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
            ),
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  top: true,
                  child: Padding(
                    padding: ResponsiveUtils.padding(context, horizontal: 24.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (mounted) {
                          setState(() {});
                        }
                        return Future<void>.delayed(
                            const Duration(milliseconds: 500));
                      },
                      child: SingleChildScrollView(
                        child: _buildNutritionPlansList(coachRecord),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: ResponsiveUtils.height(context, 24),
                left: ResponsiveUtils.width(context, 24),
                child: GestureDetector(
                  onTap: _onAddPlanPressed,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    height: ResponsiveUtils.height(context, 64),
                    width: ResponsiveUtils.width(context, 64),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context)
                              .info
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: ResponsiveUtils.iconSize(context, 28),
                        color: FlutterFlowTheme.of(context).black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> _onAddPlanPressed() async {
    try {
      if (currentCoachDocument == null) {
        Logger.warning('Coach record not found when trying to add plan');
        return;
      }

      if (currentCoachDocument!.isSub == true) {
        Logger.info('User is subscribed, navigating to create nutrition plans');
        if (mounted) {
          context.pushNamed('CreateNutritionPlans');
        }
      } else {
        Logger.info('User is not subscribed, showing subscription check');
        if (mounted) {
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return CheckSubscribe(
                showInterstitialAd: () =>
                    _adService.showInterstitialAd(context),
                page: 'CreateNutritionPlans',
              );
            },
          );
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Error in _onAddPlanPressed', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorAddingPlan'), context);
      }
    }
  }

  Widget _buildNutritionPlansList(CoachRecord coachRecord) {
    try {
      return StreamBuilder<List<NutPlanRecord>>(
        stream: queryNutPlanRecord(
          queryBuilder: (nutPlanRecord) => nutPlanRecord.where(
            'coachRef',
            isEqualTo: coachRecord.reference,
          ),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Logger.error('Error fetching nutrition plans', snapshot.error,
                snapshot.stackTrace);
            return const ErrorPageWidget();
          }

          if (!snapshot.hasData) return const LoadingIndicator();

          if (snapshot.data!.isEmpty) {
            return EmptyNutritionPlansView(
              onTap: _onAddPlanPressed,
            );
          }

          return _buildNutritionPlans(snapshot.data!);
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Error building nutrition plans list', e, stackTrace);
      return const ErrorPageWidget();
    }
  }

  Widget _buildNutritionPlans(List<NutPlanRecord> plans) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(plans.length, (index) {
        final plan = plans[index];
        return Animate(
          effects: [
            FadeEffect(
              duration: 300.ms,
              delay: (50 * index).ms,
            ),
            SlideEffect(
              begin: const Offset(-0.1, 0),
              end: const Offset(0, 0),
              duration: 300.ms,
              delay: (50 * index).ms,
              curve: Curves.easeOut,
            ),
          ],
          child: NutritionPlanCard(
            key: ValueKey(plan.reference.id),
            plan: plan,
            onDelete: () => _onDeletePlanPressed(plan),
            onEdit: () => _onEditPlanPressed(plan),
            onViewDetails: () => _onViewDetailsPressed(plan),
          ),
        );
      }),
    );
  }

  Future<void> _onDeletePlanPressed(NutPlanRecord plan) async {
    try {
      Logger.info('Attempting to delete plan: ${plan.nutPlan.name}');

      final shouldDelete = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteConfirmationDialog(
            onConfirm: (confirmed) => Navigator.pop(context, confirmed),
          );
        },
      );

      if (shouldDelete == true) {
        if (!mounted) {
          Logger.warning(
              'Context is no longer mounted when trying to delete plan');
          return;
        }

        LoadingDialog.show(
          context,
          FFLocalizations.of(context).getText('deletingPlan'),
        );

        try {
          // Delete the plan
          await plan.reference.delete();
          Logger.info('Plan deleted successfully: ${plan.nutPlan.name}');

          // Close loading dialog
          if (mounted) LoadingDialog.hide(context);

          // Show success message
          if (mounted) {
            showSuccessDialog(
                FFLocalizations.of(context).getText('planDeletedSuccessfully'),
                context);
          }
        } catch (error, stackTrace) {
          Logger.error(
              'Error deleting plan: ${plan.nutPlan.name}', error, stackTrace);

          // Close loading dialog
          if (mounted) LoadingDialog.hide(context);

          // Show error message
          if (mounted) {
            showErrorDialog(
                FFLocalizations.of(context).getText('2184r6dy'), context);
          }
        }
      } else {
        Logger.info('Plan deletion cancelled by user: ${plan.nutPlan.name}');
      }
    } catch (e, stackTrace) {
      Logger.error('Unexpected error in _onDeletePlanPressed', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('unexpectedError'), context);
      }
    }
  }

  void _onEditPlanPressed(NutPlanRecord plan) {
    try {
      Logger.info('Navigating to edit plan: ${plan.nutPlan.name}');
      context.pushNamed(
        'CreateNutritionPlans',
        queryParameters: {
          'editNutPlan': serializeParam(plan, ParamType.Document),
        }.withoutNulls,
        extra: <String, dynamic>{
          'editNutPlan': plan,
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Error navigating to edit plan', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorNavigatingToEdit'),
            context);
      }
    }
  }

  void _onViewDetailsPressed(NutPlanRecord plan) {
    try {
      Logger.info('Viewing details for plan: ${plan.nutPlan.name}');
      context.pushNamed(
        'nutPlanDetials',
        queryParameters: {
          'nuPlan': serializeParam(plan, ParamType.Document),
        }.withoutNulls,
        extra: <String, dynamic>{
          'nuPlan': plan,
        },
      );
    } catch (e, stackTrace) {
      Logger.error('Error navigating to plan details', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorViewingDetails'),
            context);
      }
    }
  }
}
