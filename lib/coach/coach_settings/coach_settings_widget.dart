import 'package:flutter/material.dart';
import 'package:iron_fit/coach/coach_settings/componants/sevices.dart';
import 'package:iron_fit/coach/coach_settings/componants/sign_out_button.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/internationalization.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/auth/firebase_auth/auth_util.dart';
import 'package:iron_fit/utils/logger.dart';
import 'componants/account_settings.dart';
import '/componants/loading_indicator/loadingIndicator.dart';
import '/utils/responsive_utils.dart';

class CoachSettingsWidget extends StatefulWidget {
  const CoachSettingsWidget({super.key});

  @override
  State<CoachSettingsWidget> createState() => _CoachSettingsWidgetState();
}

class _CoachSettingsWidgetState extends State<CoachSettingsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  CoachRecord? _coachRecord;

  @override
  void initState() {
    super.initState();
    _fetchCoachData();
  }

  Future<void> _fetchCoachData() async {
    if (currentCoachDocument == null) return;

    try {
      final coachRecord = await queryCoachRecord(
        queryBuilder: (query) => query.where(
          'user',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).first;

      if (mounted) {
        setState(() {
          _coachRecord = coachRecord.first;
          _isLoading = false;
        });
      }
    } catch (e) {
      Logger.error('Error fetching coach data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle account deletion
  void _handleDeleteAccount(CoachRecord coach) async {
    // This would be implemented with actual account deletion logic
    Logger.info('Delete account requested for coach: ${coach.reference.id}');
    deleteAccount(coach, context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_coachRecord == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Unable to load settings',
            style: AppStyles.textCairo(context,
                fontSize: ResponsiveUtils.fontSize(context, 16)),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.1),
          extendBodyBehindAppBar: true,
          appBar: CoachAppBar.coachAppBar(
              context,
              FFLocalizations.of(context).getText('ux9ea1rv'),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: ResponsiveUtils.iconSize(context, 24),
                  )),
              null),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                left: ResponsiveUtils.width(context, 20),
                right: ResponsiveUtils.width(context, 20)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5),
                  FlutterFlowTheme.of(context).primaryBackground,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    AccountSettings(
                      onDeleteAccount: _handleDeleteAccount,
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 24)),
                    SignOutButton(onPressed: () {
                      logout(context);
                    }),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          )).withCoachNavBar(4),
    );
  }
}
