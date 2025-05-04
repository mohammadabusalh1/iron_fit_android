import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/coach/trainee/trainee_widget.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class TraineeCard extends StatelessWidget {
  final SubscriptionsRecord subscription;
  final bool isRequest;
  final Function()? onRestore;
  final Function()? onDelete;

  const TraineeCard({
    super.key,
    required this.subscription,
    this.isRequest = false,
    this.onRestore,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 600, // Maximum width for larger screens
            minWidth:
                constraints.maxWidth * 0.9, // Minimum width based on screen
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: ResponsiveUtils.height(context, 16.0),
            ),
            child: _buildCardContent(context, constraints),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, BoxConstraints constraints) {
    if (subscription.isAnonymous) {
      return _buildAnonymousContent(context, constraints);
    } else if (isRequest) {
      return _buildRequestContent(context, constraints);
    } else {
      return _buildRegularContent(context, constraints);
    }
  }

  Widget _buildAnonymousContent(
      BuildContext context, BoxConstraints constraints) {
    final bool isSmallScreen = constraints.maxWidth < 350;

    return InkWell(
      onTap: () async {
        if (!subscription.isDeleted) {
          await context.pushNamed(
            'trainee',
            queryParameters: {
              'sub': serializeParam(
                subscription.reference,
                ParamType.DocumentReference,
              ),
            }.withoutNulls,
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: ResponsiveUtils.width(context, isSmallScreen ? 40.0 : 50.0),
                  height: ResponsiveUtils.height(context, isSmallScreen ? 40.0 : 50.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Icon(
                      Icons.person_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: ResponsiveUtils.iconSize(context, isSmallScreen ? 25 : 35),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveUtils.width(context, constraints.maxWidth * 0.03)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: AppStyles.textCairo(
                          context,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 14 : 16),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        dateTimeFormat(
                          "yMd",
                          subscription.endDate,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 10 : 12),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!subscription.isDeleted)
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                ),
              if (subscription.isDeleted && onRestore != null)
                IconButton(
                  onPressed: onRestore,
                  icon: Icon(
                    Icons.restore,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                    minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
              if (subscription.isDeleted && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: FlutterFlowTheme.of(context).error,
                    size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                    minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestContent(
      BuildContext context, BoxConstraints constraints) {
    final bool isSmallScreen = constraints.maxWidth < 350;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: ResponsiveUtils.width(context, isSmallScreen ? 40.0 : 50.0),
                height: ResponsiveUtils.height(context, isSmallScreen ? 40.0 : 50.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Icon(
                    Icons.person_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, isSmallScreen ? 25 : 35),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.width(context, constraints.maxWidth * 0.03)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: AppStyles.textCairo(
                        context,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 14 : 16),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      dateTimeFormat(
                        "yMd",
                        subscription.endDate,
                        locale: FFLocalizations.of(context).languageCode,
                      ),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 10 : 12),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!subscription.isDeleted && onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete,
                  color: FlutterFlowTheme.of(context).error,
                  size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                ),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                  minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                ),
                padding: EdgeInsets.zero,
              ),
            if (subscription.isDeleted && onRestore != null)
              IconButton(
                onPressed: onRestore,
                icon: Icon(
                  Icons.restore,
                  color: FlutterFlowTheme.of(context).primary,
                  size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                ),
                constraints: BoxConstraints(
                  minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                  minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                ),
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegularContent(
      BuildContext context, BoxConstraints constraints) {
    final bool isSmallScreen = constraints.maxWidth < 350;

    return InkWell(
      onTap: () async {
        if (!subscription.isDeleted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TraineeWidget(sub: subscription.reference),
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: subscription.trainee != null
                  ? TraineeRecord.getDocument(subscription.trainee!)
                      .asyncMap((traineeRecord) async {
                      if (traineeRecord.user == null) return {};
                      final userRecord =
                          await UserRecord.getDocument(traineeRecord.user!)
                              .first;
                      return {
                        'trainee': traineeRecord,
                        'user': userRecord,
                      };
                    })
                  : null,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!;
                  print('data: ${data}');
                  final userRecord = data['user'] as UserRecord;
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: ResponsiveUtils.width(context, isSmallScreen ? 40.0 : 50.0),
                        height: ResponsiveUtils.height(context, isSmallScreen ? 40.0 : 50.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.network(
                            userRecord.photoUrl,
                            width: ResponsiveUtils.width(context, isSmallScreen ? 40.0 : 50.0),
                            height: ResponsiveUtils.height(context, isSmallScreen ? 40.0 : 50.0),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: ResponsiveUtils.iconSize(context, isSmallScreen ? 25 : 35),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, constraints.maxWidth * 0.03)),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subscription.name,
                              style: AppStyles.textCairo(
                                context,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 14 : 16),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              dateTimeFormat(
                                "yMd",
                                subscription.endDate,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, isSmallScreen ? 10 : 12),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!subscription.isDeleted)
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                ),
              if (subscription.isDeleted && onRestore != null)
                IconButton(
                  onPressed: onRestore,
                  icon: Icon(
                    Icons.restore,
                    color: FlutterFlowTheme.of(context).primary,
                    size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                    minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
              if (subscription.isDeleted && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: FlutterFlowTheme.of(context).error,
                    size: ResponsiveUtils.iconSize(context, isSmallScreen ? 20.0 : 24.0),
                  ),
                  constraints: BoxConstraints(
                    minWidth: ResponsiveUtils.width(context, isSmallScreen ? 30.0 : 40.0),
                    minHeight: ResponsiveUtils.height(context, isSmallScreen ? 30.0 : 40.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SubscriptionsRecord>('subscription', subscription));
    properties.add(DiagnosticsProperty<bool>('isRequest', isRequest));
  }
}
