import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final ValueChanged<String>? onChanged;
  final Function()? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onChanged,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MouseRegion(
            onEnter: (_) => _animationController.forward(),
            onExit: (_) => _animationController.reverse(),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() => _isFocused = hasFocus);
                },
                child: TextFormField(
                  controller: widget.controller,
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                    if (value.isEmpty && widget.onClear != null) {
                      widget.onClear!();
                    }
                  },
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        FFLocalizations.of(context).getText('search_trainees'),
                    hintStyle: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: ResponsiveUtils.iconSize(context, 24),
                      color: _isFocused
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: widget.controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              size: ResponsiveUtils.iconSize(context, 24),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            onPressed: () {
                              widget.controller.clear();
                              if (widget.onClear != null) {
                                widget.onClear!();
                              }
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: ResponsiveUtils.padding(
                      context,
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.width(context, 12)),
        FFButtonWidget(
          onPressed: () {
            widget.onSearch();
          },
          text: FFLocalizations.of(context).getText('search'),
          options: FFButtonOptions(
            height: ResponsiveUtils.height(context, 55.0),
            padding: EdgeInsetsDirectional.fromSTEB(
              ResponsiveUtils.width(context, 24),
              0,
              ResponsiveUtils.width(context, 24),
              0,
            ),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            elevation: 2.0,
            borderRadius: BorderRadius.circular(16.0),
            hoverColor:
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.8),
            hoverElevation: 4.0,
          ),
        ),
      ],
    );
  }
}
