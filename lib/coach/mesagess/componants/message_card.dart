import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/componants/Styles.dart';

class MessageCard extends StatelessWidget {
  final AlertRecord alertRecord;

  const MessageCard({
    super.key,
    required this.alertRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alertRecord.name,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateTimeFormat(
                    "relative",
                    alertRecord.date!,
                    locale: FFLocalizations.of(context).languageCode,
                  ),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
            Text(
              alertRecord.desc,
              style: AppStyles.textCairo(context, fontSize: 14),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.people,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 16.0,
                ),
                Text(
                  FFLocalizations.of(context)
                      .getText('etu9d3wo' /* Sent to: All Members */),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ].divide(const SizedBox(width: 8.0)),
            ),
          ].divide(const SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}
