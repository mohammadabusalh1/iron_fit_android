import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'days_model.dart';
import 'components/days_exercise_list.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
export 'days_model.dart';

class DaysWidget extends StatefulWidget {
  /// I need a page to display exercises during the week for trainees
  const DaysWidget({super.key});

  @override
  State<DaysWidget> createState() => _DaysWidgetState();
}

class _DaysWidgetState extends State<DaysWidget> {
  late DaysModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DaysModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    if (currentTraineeDocument == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        extendBodyBehindAppBar: true,
        appBar: CoachAppBar.coachAppBar(
            context,
            FFLocalizations.of(context).getText('dv1k6pvj' /* My Trainees */),
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24,
              ),
              onPressed: () {
                context.pushNamed('mySubscription');
              },
            ),
            null),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 80,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.05),
                FlutterFlowTheme.of(context).primaryBackground,
              ],
            ),
          ),
          child: DaysExerciseList(
              key: ValueKey(currentTraineeDocument!.reference.id),
              traineeRecord: currentTraineeDocument!),
        ),
      ).withUserNavBar(1),
    );
  }
}
