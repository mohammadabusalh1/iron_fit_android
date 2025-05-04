import 'package:flutter/material.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'message_card.dart';

class RecentMessagesSection extends StatelessWidget {
  final List<AlertRecord> messages;

  const RecentMessagesSection({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          FFLocalizations.of(context).getText(
              'messages_are_automatically_deleted_after_7_days' /* Messages are automatically deleted after 7 days */),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 14),
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 16)),
        _buildMessagesListView(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 12)),
            Text(
              FFLocalizations.of(context)
                  .getText('mu14nif2' /* Recent Messages */),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 18),
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
        Container(
          padding: ResponsiveUtils.padding(
            context,
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
          ),
          child: Text(
            '${messages.length} ${FFLocalizations.of(context).getText('vj2epgx9' /* messages */)}',
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMessagesListView(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.message_outlined,
                size: ResponsiveUtils.iconSize(context, 48),
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              Text(
                FFLocalizations.of(context).getText('noData'),
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final alertRecord = messages[index];
        return Padding(
          padding:
              EdgeInsets.only(bottom: index < messages.length - 1 ? ResponsiveUtils.height(context, 12.0) : 0),
          child: MessageCard(alertRecord: alertRecord),
        );
      },
    );
  }
}
