import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  final bool isSaving;
  final VoidCallback onSave;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isSaving) {
            _animationController.forward();
            HapticFeedback.mediumImpact();
          }
        },
        onTapUp: (_) {
          if (!widget.isSaving) {
            _animationController.reverse();
          }
        },
        onTapCancel: () {
          if (!widget.isSaving) {
            _animationController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: ResponsiveUtils.height(context, 60.0), // Responsive height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(ResponsiveUtils.width(context, 30.0)), // Responsive border radius
                  boxShadow: widget.isSaving
                      ? []
                      : [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.3 * _shadowAnimation.value),
                            blurRadius: 15 * _shadowAnimation.value,
                            offset: Offset(0, ResponsiveUtils.height(context, 6) * _shadowAnimation.value),
                            spreadRadius: -2,
                          ),
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.2 * _shadowAnimation.value),
                            blurRadius: ResponsiveUtils.width(context, 4),
                            offset: Offset(0, ResponsiveUtils.height(context, 2) * _shadowAnimation.value),
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 30.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 30.0)),
                    splashColor:
                        FlutterFlowTheme.of(context).info.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    onTap: widget.isSaving
                        ? null
                        : () {
                            HapticFeedback
                                .heavyImpact(); // Stronger feedback when saving
                            widget.onSave();
                          },
                    child: Center(
                      child: widget.isSaving
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: ResponsiveUtils.width(context, 24),
                                  height: ResponsiveUtils.height(context, 24),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).info),
                                    strokeWidth: ResponsiveUtils.width(context, 2.5),
                                  ),
                                ),
                                SizedBox(width: ResponsiveUtils.width(context, 12)),
                                Text(
                                  FFLocalizations.of(context).getText('saving'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: ResponsiveUtils.fontSize(context, 17),
                                    fontWeight: FontWeight.w700,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: Matrix4.translationValues(
                                      _isHovering ? 0 : ResponsiveUtils.width(context, -4), 0, 0),
                                  child: Icon(
                                    Icons.save_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: ResponsiveUtils.iconSize(context, 24),
                                  ),
                                ),
                                SizedBox(width: ResponsiveUtils.width(context, 12)),
                                AnimatedPadding(
                                  padding: EdgeInsets.only(
                                    left: _isHovering 
                                        ? ResponsiveUtils.width(context, 12) 
                                        : ResponsiveUtils.width(context, 8),
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    FFLocalizations.of(context)
                                        .getText('ayt5365p'),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: ResponsiveUtils.fontSize(context, 17),
                                      fontWeight: FontWeight.w700,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                // Animated arrow on hover
                                AnimatedOpacity(
                                  opacity: _isHovering ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: AnimatedPadding(
                                    padding: EdgeInsets.only(
                                      left: _isHovering 
                                          ? ResponsiveUtils.width(context, 8) 
                                          : 0,
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: ResponsiveUtils.iconSize(context, 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
