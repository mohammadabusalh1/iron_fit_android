import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/user_nav/user_nav_widget.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'nut_plan_detials_model.dart';
export 'nut_plan_detials_model.dart';

// Import components
import 'components/empty_plan_state.dart';
import 'components/plan_summary.dart';
import 'components/meals_list.dart';

class NutPlanDetialsWidget extends StatefulWidget {
  final bool hasNav;
  final bool isForUser;

  /// create page to show nutrition plan details
  const NutPlanDetialsWidget({
    super.key,
    required this.nuPlan,
    this.hasNav = false,
    required this.isForUser,
  });

  final NutPlanRecord? nuPlan;

  @override
  State<NutPlanDetialsWidget> createState() => _NutPlanDetialsWidgetState();
}

class _NutPlanDetialsWidgetState extends State<NutPlanDetialsWidget> {
  late NutPlanDetialsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NutPlanDetialsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
        appBar: CoachAppBar.coachAppBar(
          context,
          FFLocalizations.of(context).getText('2gaxu5nj' /* My Trainees */),
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24,
            ),
            onPressed: () {
              widget.isForUser
                  ? context.pushNamed('mySubscription')
                  : context.pushNamed('NutritionPlans');
            },
          ),
          widget.isForUser
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24,
                  ),
                  onPressed: () {
                    context.pushNamed(
                      'CreateNutritionPlans',
                      queryParameters: {
                        'editNutPlan': serializeParam(
                          widget.nuPlan,
                          ParamType.Document,
                        ),
                      }.withoutNulls,
                      extra: <String, dynamic>{
                        'editNutPlan': widget.nuPlan,
                      },
                    );
                  },
                ),
        ),
        key: scaffoldKey,
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.nuPlan == null) {
      return EmptyPlanState(hasNav: widget.hasNav);
    }

    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primaryBackground,
            FlutterFlowTheme.of(context).primary.withOpacity(0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          _NutPlanContent(
            nuPlan: widget.nuPlan!,
            hasNav: widget.hasNav,
          ),
          if (widget.hasNav)
            const Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: UserNavWidget(num: 1),
            ),
        ],
      ),
    );
  }
}

class _NutPlanContent extends StatelessWidget {
  final NutPlanRecord nuPlan;
  final bool hasNav;

  const _NutPlanContent({
    required this.nuPlan,
    required this.hasNav,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: mediaQuery.size.height * 0.75,
            ),
            width: mediaQuery.size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlanSummary(nuPlan: nuPlan),
                  const SizedBox(height: 24.0),
                  MealsList(nuPlan: nuPlan),
                ],
              ),
            ),
          ),
          hasNav ? const SizedBox(height: 56) : const SizedBox(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
