import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20),
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
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: FlutterFlowTheme.of(context).error,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  FFLocalizations.of(context).getText('delete_account_title'),
                  style: AppStyles.textCairo(
                    context,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  FFLocalizations.of(context).getText('delete_account_confirm'),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
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
                          height: 48,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          _animationController.reverse().then((_) {
                            widget.onDelete();
                          });
                        },
                        text: FFLocalizations.of(context).getText('delete'),
                        options: FFButtonOptions(
                          height: 48,
                          color: FlutterFlowTheme.of(context).error,
                          textStyle: AppStyles.textCairo(
                            context,
                            color: FlutterFlowTheme.of(context).info,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(12),
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
