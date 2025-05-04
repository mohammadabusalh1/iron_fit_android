import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
// ignore: unused_import
import 'package:iron_fit/coach/coach_home/coach_home_model.dart';
import 'package:iron_fit/coach/coach_home/coach_home_widget.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/trainee/user_home/user_home_widget.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class ErrorPageWidget extends StatelessWidget {
  /// create Error Page
  const ErrorPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              ResponsiveUtils.width(context, 24), 
              MediaQuery.of(context).padding.top + ResponsiveUtils.height(context, 24), 
              ResponsiveUtils.width(context, 24), 
              ResponsiveUtils.height(context, 24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://img.freepik.com/free-vector/oops-404-error-with-broken-robot-concept-illustration_114360-5529.jpg?t=st=1733462893~exp=1733466493~hmac=ad9c2fff54f44648fb8e77b78a68ff0cc508f0b5cf53cde0a26b45b28aed1380&w=740',
                      width: ResponsiveUtils.width(context, 300),
                      height: ResponsiveUtils.height(context, 300),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    'l7kfx3m8' /* Oops! Something went wrong */,
                  ),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 24),
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FFLocalizations.of(context).getText(
                    '2184r6dy' /* We encountered an unexpected e... */,
                  ),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => currentUserDocument != null
                            ? currentUserDocument!.role == 'trainee'
                                ? const UserHomeWidget()
                                : const CoachHomeWidget()
                            : const ErrorPageWidget(),
                      ),
                    );
                  },
                  text: FFLocalizations.of(context).getText(
                    '2ic7dbdd' /* Try Again */,
                  ),
                  options: FFButtonOptions(
                    width: ResponsiveUtils.width(context, 200),
                    height: ResponsiveUtils.height(context, 50),
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      color: FlutterFlowTheme.of(context).info,
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {},
                  text: FFLocalizations.of(context).getText(
                    'e1g3ko1c' /* Contact Support */,
                  ),
                  options: FFButtonOptions(
                    width: ResponsiveUtils.width(context, 200),
                    height: ResponsiveUtils.height(context, 50),
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: const Color(0x00FFFFFF),
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ].divide(SizedBox(height: ResponsiveUtils.height(context, 24))),
            ),
          ),
        ),
      ),
    );
  }
}
