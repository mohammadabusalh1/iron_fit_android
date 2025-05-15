import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/services/firebase_messages.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/logger.dart';

class BroadcastMessageSection extends StatefulWidget {
  final CoachRecord coachRecord;
  final Function onMessageSent;

  const BroadcastMessageSection({
    super.key,
    required this.coachRecord,
    required this.onMessageSent,
  });

  @override
  State<BroadcastMessageSection> createState() =>
      _BroadcastMessageSectionState();
}

class _BroadcastMessageSectionState extends State<BroadcastMessageSection> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    // Cache localized strings at the beginning
    final localization = FFLocalizations.of(context);
    final coachAlertText = localization.getText('coachAlert');
    final noSubscriptionsText = localization.getText('noSubscriptionsFound');
    final messageSentText = localization.getText('messageSentSuccessfully');
    final failedToLoadText =
        localization.getText('failedToLoadMessagesPleaseTryAgain');

    try {
      Logger.info('Attempting to send broadcast message');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );

      // Optimize subscription query with a single compound query
      final subsData = await querySubscriptionsRecordOnce(
        queryBuilder: (subsRecord) => subsRecord
            .where('coach', isEqualTo: widget.coachRecord.reference)
            .where('isAnonymous', isEqualTo: false)
            .where('isActive', isEqualTo: true)
            .limit(1000), // Add reasonable limit to prevent memory issues
      );

      if (!mounted) {
        Logger.warning('Widget no longer mounted after subscription query');
        return;
      }

      if (subsData.isEmpty) {
        Logger.warning('No active non-anonymous subscriptions found for coach');
        context.pop();
        showErrorDialog(noSubscriptionsText, context);
        setState(() {
          _isSending = false;
        });
        return;
      }

      Logger.info('Found ${subsData.length} subscriptions for broadcast');

      // Batch process trainee records
      final traineeRefs = subsData
          .map((e) => e.trainee)
          .whereType<DocumentReference<Object?>>()
          .toList();

      // Process in parallel with error handling
      final traineeRecords = await Future.wait(
        traineeRefs.map((ref) => ref.get()),
        eagerError: true,
      );

      // Extract user references and process in parallel
      final usersRef = traineeRecords
          .map((doc) => TraineeRecord.fromSnapshot(doc).user)
          .whereType<DocumentReference<Object?>>()
          .toList();

      final users = await Future.wait(
        usersRef.map((ref) => ref.get()),
        eagerError: true,
      );

      // Extract FCM tokens in parallel
      final fcmTokens = users
          .map((doc) => UserRecord.fromSnapshot(doc))
          .where((user) => user.fcmToken != null && user.fcmToken.isNotEmpty)
          .map((user) => user.fcmToken)
          .toList();

      // Send FCM notifications in parallel with error handling
      if (fcmTokens.isNotEmpty) {
        final notificationResults = await Future.wait(
          fcmTokens.map((token) async {
            try {
              await FirebaseNotificationService.instance.sendPushNotification(
                token: token,
                title: coachAlertText,
                body: _textController.text,
                data: {
                  'type': 'broadcast',
                  'coachId': widget.coachRecord.reference.id,
                },
              );
              return true;
            } catch (e) {
              Logger.error('Error sending FCM notification: $e');
              return false;
            }
          }),
          eagerError: false,
        );

        // Log failed notifications
        final failedCount = notificationResults.where((r) => !r).length;
        if (failedCount > 0) {
          Logger.warning('Failed to send $failedCount notifications');
        }
      }

      // Create alert record with optimized data structure
      final alertData = {
        ...createAlertRecordData(
          name: coachAlertText,
          desc: _textController.text,
          coach: widget.coachRecord.reference,
          date: getCurrentTimestamp,
        ),
        ...mapToFirestore({
          'trainees': subsData
              .map((e) => {
                    'ref': e.trainee,
                    'isRead': false,
                  })
              .toList(),
        }),
      };

      await AlertRecord.collection.doc().set(alertData);

      _textController.clear();
      if (!mounted) {
        Logger.warning('Widget no longer mounted after sending message');
        return;
      }

      Navigator.of(context).pop();
      showSuccessDialog(messageSentText, context);
      Logger.info('Broadcast message sent successfully');

      widget.onMessageSent();
    } catch (e, stackTrace) {
      Logger.error('Failed to send broadcast message',
          error: e, stackTrace: stackTrace);

      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(failedToLoadText, context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withAlpha(30),
            width: 1,
          ),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(
            context,
            horizontal: 16.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                FFLocalizations.of(context).getText(
                    'broadcast_messages_subtitle' /* Send a message to all your trainees at once */),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              _buildMessageInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.campaign_rounded,
          color: FlutterFlowTheme.of(context).primary,
          size: ResponsiveUtils.iconSize(context, 24),
        ),
        SizedBox(width: ResponsiveUtils.width(context, 12)),
        Text(
          FFLocalizations.of(context)
              .getText('z6h7b76l' /* Send Broadcast Message */),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 18),
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInputField() {
    return TextFormField(
      onTap: () {
        // Move cursor to end of text
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length),
        );
      },
      controller: _textController,
      focusNode: _textFieldFocusNode,
      onFieldSubmitted: (_) async => await _sendMessage(),
      autofocus: false,
      obscureText: false,
      enabled: !_isSending,
      decoration: InputDecoration(
        hintText: FFLocalizations.of(context)
            .getText('l0ljacgo' /* Type your message to all train... */),
        hintStyle: FlutterFlowTheme.of(context).bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        suffixIcon: InkWell(
          onTap: _isSending ? null : () async => await _sendMessage(),
          child: Icon(
            Icons.send,
            color: _isSending
                ? FlutterFlowTheme.of(context).secondaryText
                : FlutterFlowTheme.of(context).primary,
          ),
        ),
      ),
    );
  }
}
