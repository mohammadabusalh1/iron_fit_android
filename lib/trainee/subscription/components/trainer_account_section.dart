import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class TrainerAccountSection extends StatelessWidget {
  final CoachRecord coachRecord;
  final UserRecord userCoachRecord;

  const TrainerAccountSection({
    super.key,
    required this.coachRecord,
    required this.userCoachRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
      ),
      child: Container(
        width: ResponsiveUtils.width(context, MediaQuery.sizeOf(context).width),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FFLocalizations.of(context).getText('trainerAccount'),
                    style: AppStyles.textCairo(context,
                        fontSize: ResponsiveUtils.fontSize(context, 22), fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: ResponsiveUtils.padding(context, horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: ResponsiveUtils.iconSize(context, 20),
                    ),
                  ),
                ],
              ),
              Container(
                padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: ResponsiveUtils.width(context, 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                          width: ResponsiveUtils.width(context, 2),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 10)),
                        child: Image.network(
                          userCoachRecord.photoUrl,
                          width: ResponsiveUtils.width(context, 70),
                          height: ResponsiveUtils.height(context, 70),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: ResponsiveUtils.width(context, 70),
                            height: ResponsiveUtils.height(context, 70),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 10)),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: FlutterFlowTheme.of(context).primary,
                              size: ResponsiveUtils.iconSize(context, 30),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: ResponsiveUtils.width(context, 70),
                              height: ResponsiveUtils.height(context, 70),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 10)),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userCoachRecord.displayName,
                            style: AppStyles.textCairo(
                              context,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 4)),
                          Container(
                            padding: ResponsiveUtils.padding(
                              context,
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 8)),
                            ),
                            child: Text(
                              coachRecord.specialization.isEmpty
                                  ? FFLocalizations.of(context)
                                      .getText('coach_label')
                                  : coachRecord.specialization,
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 12),
                                color: FlutterFlowTheme.of(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 4)),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: ResponsiveUtils.iconSize(context, 16),
                              ),
                              SizedBox(width: ResponsiveUtils.width(context, 4)),
                              Text(
                                '${coachRecord.experience} ${FFLocalizations.of(context).getText('t70b45uz')}',
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: ResponsiveUtils.fontSize(context, 12),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ].divide(SizedBox(height: ResponsiveUtils.height(context, 16))),
          ),
        ),
      ),
    );
  }
}
