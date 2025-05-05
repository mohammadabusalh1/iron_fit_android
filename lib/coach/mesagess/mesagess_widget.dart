import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/componants/loading_indicator/loadingIndicator.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/navigation/page_wrapper.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'componants/broadcast_message_section.dart';
import 'componants/recent_messages_section.dart';

class MessagesWidget extends StatefulWidget {
  /// I want you to create coach Messages page to send notifications for
  /// trainees
  const MessagesWidget({super.key});

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<AlertRecord> listViewAlertRecordList = List<AlertRecord>.empty();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getMessages() async {
    if (currentCoachDocument == null) return;
    try {
      setState(() => _isLoading = true);
      Logger.info('Fetching coach messages');

      await _deleteOldMessages();
      await _fetchMessages(currentCoachDocument!);

      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      Logger.error('Failed to get messages', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    }
  }

  Future<void> _deleteOldMessages() async {
    try {
      Logger.info('Deleting messages older than 7 days');
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final querySnapshot = await FirebaseFirestore.instance
          .collection('alert')
          .where('date', isLessThan: sevenDaysAgo)
          .get();

      Logger.info('Found ${querySnapshot.docs.length} old messages to delete');
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      Logger.info('Successfully deleted old messages');
    } catch (e, stackTrace) {
      Logger.error('Failed to delete old messages', e, stackTrace);
      // Continue execution - non-critical error
    }
  }

  Future<void> _fetchMessages(CoachRecord coachRecord) async {
    try {
      Logger.info('Fetching alert messages for coach');
      final messages = await FirebaseFirestore.instance
          .collection('alert')
          .where('coach', isEqualTo: coachRecord.reference)
          .where('name', whereIn: ['Coach Alert', 'تنبيه المدرب'])
          .orderBy('date', descending: true)
          .get();

      if (!mounted) {
        Logger.warning('Widget no longer mounted after fetching messages');
        return;
      }

      setState(() {
        listViewAlertRecordList =
            messages.docs.map((doc) => AlertRecord.fromSnapshot(doc)).toList();
      });
      Logger.info(
          'Successfully loaded ${listViewAlertRecordList.length} messages');
    } catch (e, stackTrace) {
      Logger.error('Failed to fetch messages', e, stackTrace);
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('2184r6dy'), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (currentCoachDocument == null) {
      Logger.warning('No coach records available');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed('Login');
        }
      });
      return const LoadingIndicator();
    }

    return _buildMainScreen(currentCoachDocument!);
  }

  Widget _buildMainScreen(CoachRecord coachRecord) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          extendBody: true,
          backgroundColor: FlutterFlowTheme.of(context).info.withOpacity(0.2),
          extendBodyBehindAppBar: true,
          appBar: CoachAppBar.coachAppBar(
            context,
            FFLocalizations.of(context).getText('kqnehly5'),
            null,
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: FlutterFlowTheme.of(context).primaryText,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
              onPressed: () {
                context.pushNamed('Contact');
              },
            ),
          ),
          body: Container(
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
            padding: ResponsiveUtils.padding(
              context,
              horizontal: 20,
              vertical: 0,
            ),
            child: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                    BroadcastMessageSection(
                        coachRecord: coachRecord, onMessageSent: getMessages),
                    SizedBox(height: ResponsiveUtils.height(context, 32.0)),
                    RecentMessagesSection(messages: listViewAlertRecordList),
                    SizedBox(height: ResponsiveUtils.height(context, 24.0)),
                  ],
                ),
              ),
            ),
          )).withCoachNavBar(2),
    );
  }
}
