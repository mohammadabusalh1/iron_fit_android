import 'package:flutter/material.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
    required this.onDelete,
  });

  final VoidCallback onDelete;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 20)),
              boxShadow: [
                BoxShadow(
                  color: FlutterFlowTheme.of(context).error.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ResponsiveUtils.width(context, 80),
                  height: ResponsiveUtils.height(context, 80),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: FlutterFlowTheme.of(context).error,
                    size: ResponsiveUtils.iconSize(context, 40),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 20)),
                Text(
                  FFLocalizations.of(context).getText('delete_account_title'),
                  style: AppStyles.textCairo(
                    context,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 12)),
                Text(
                  FFLocalizations.of(context).getText('delete_account_confirm'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                Row(
                  children: [
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          _animationController.reverse().then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        text: FFLocalizations.of(context).getText('cancel'),
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 48),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.width(context, 12)),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          _animationController.reverse().then((_) {
                            widget.onDelete();
                          });
                        },
                        text: FFLocalizations.of(context).getText('delete'),
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 48),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: ResponsiveUtils.fontSize(context, 14),
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
