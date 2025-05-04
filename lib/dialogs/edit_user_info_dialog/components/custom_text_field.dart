import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/utils/responsive_utils.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    this.validator,
    this.icon,
    this.maxLines = 1,
    this.hintText,
    this.isLastField = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? icon;
  final int maxLines;
  final String? hintText;
  final bool isLastField;
  final Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _labelSizeAnimation;
  Animation<Color?>? _borderColorAnimation;
  Animation<Color?>? _labelColorAnimation;
  Animation<Color?>? _iconColorAnimation;
  late Animation<double> _iconScaleAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    widget.focusNode.addListener(_handleFocusChange);

    // Initialize animations that don't depend on context
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _labelSizeAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize context-dependent animations here
    if (!_isInitialized) {
      _borderColorAnimation = ColorTween(
        begin: FlutterFlowTheme.of(context).alternate,
        end: FlutterFlowTheme.of(context).primary,
      ).animate(_animationController);

      _labelColorAnimation = ColorTween(
        begin: FlutterFlowTheme.of(context).primaryText,
        end: FlutterFlowTheme.of(context).primary,
      ).animate(_animationController);

      _iconColorAnimation = ColorTween(
        begin: FlutterFlowTheme.of(context).secondaryText,
        end: FlutterFlowTheme.of(context).primary,
      ).animate(_animationController);

      // Initialize animation state based on initial focus
      if (widget.focusNode.hasFocus) {
        _animationController.value = 1.0;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (widget.focusNode.hasFocus) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create the animations here if they're null (this should not happen normally)
    _borderColorAnimation ??= ColorTween(
      begin: FlutterFlowTheme.of(context).alternate,
      end: FlutterFlowTheme.of(context).primary,
    ).animate(_animationController);

    _labelColorAnimation ??= ColorTween(
      begin: FlutterFlowTheme.of(context).primaryText,
      end: FlutterFlowTheme.of(context).primary,
    ).animate(_animationController);

    _iconColorAnimation ??= ColorTween(
      begin: FlutterFlowTheme.of(context).secondaryText,
      end: FlutterFlowTheme.of(context).primary,
    ).animate(_animationController);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Label
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                ResponsiveUtils.width(context, 4),
                0,
                0,
                ResponsiveUtils.height(context, 8),
              ),
              child: Transform.scale(
                scale: _labelSizeAnimation.value,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.label,
                  style: AppStyles.textCairo(
                    context,
                    fontWeight: widget.focusNode.hasFocus
                        ? FontWeight.w600
                        : FontWeight.w500,
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                    color: _labelColorAnimation!.value,
                  ),
                ),
              ),
            ),
            // Animated text field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                boxShadow: widget.focusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.15),
                          blurRadius: ResponsiveUtils.width(context, 8),
                          spreadRadius: 0,
                          offset: Offset(0, ResponsiveUtils.height(context, 2)),
                        ),
                      ]
                    : null,
              ),
              child: TextFormField(
                maxLines: widget.maxLines,
                minLines: widget.maxLines == 1 ? 1 : 3,
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboardType,
                textInputAction: widget.isLastField
                    ? TextInputAction.done
                    : TextInputAction.next,
                cursorColor: FlutterFlowTheme.of(context).primary,
                cursorWidth: ResponsiveUtils.width(context, 2),
                cursorRadius: Radius.circular(ResponsiveUtils.width(context, 2)),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context)
                        .secondaryText
                        .withOpacity(0.5),
                    fontSize: ResponsiveUtils.fontSize(context, 14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: ResponsiveUtils.width(context, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _borderColorAnimation!.value!,
                      width: ResponsiveUtils.width(context, 2.0),
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: ResponsiveUtils.width(context, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: ResponsiveUtils.width(context, 2.0),
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                  ),
                  filled: true,
                  fillColor: widget.focusNode.hasFocus
                      ? FlutterFlowTheme.of(context).secondaryBackground
                      : FlutterFlowTheme.of(context)
                          .secondaryBackground
                          .withOpacity(0.97),
                  prefixIcon: widget.icon != null
                      ? Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Icon(
                            widget.icon,
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.7),
                            size: ResponsiveUtils.iconSize(context, 20),
                          ),
                        )
                      : null,
                  suffixIcon: widget.controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: ResponsiveUtils.iconSize(context, 18),
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          onPressed: () {
                            widget.controller.clear();
                            if (widget.onChanged != null) {
                              widget.onChanged!('');
                            }
                            FocusScope.of(context)
                                .requestFocus(widget.focusNode);
                            HapticFeedback.lightImpact();
                          },
                        )
                      : null,
                  contentPadding: ResponsiveUtils.padding(
                    context, 
                    horizontal: 16,
                    vertical: widget.maxLines > 1 ? 16 : 14,
                  ),
                ),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 15),
                ),
                validator: widget.validator,
                onTap: () {
                  if (!widget.focusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(widget.focusNode);
                  }
                  widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controller.text.length),
                  );
                },
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  setState(() {}); // To refresh the clear button visibility
                },
                onEditingComplete: () {
                  if (widget.isLastField) {
                    widget.focusNode.unfocus();
                  } else {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
