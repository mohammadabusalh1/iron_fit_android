import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DateOfBirthField extends StatefulWidget {
  const DateOfBirthField({
    super.key,
    required this.onDateSelected,
    required this.dateOfBirthTextController,
    required this.dateOfBirthFocusNode,
  });

  final Function(DateTime) onDateSelected;
  final TextEditingController dateOfBirthTextController;
  final FocusNode dateOfBirthFocusNode;

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;
  Animation<Color?>? _labelColorAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _labelColorAnimation = ColorTween(
        begin: FlutterFlowTheme.of(context).primaryText,
        end: FlutterFlowTheme.of(context).primary,
      ).animate(_animationController);

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // In case the animation hasn't been initialized yet
    _labelColorAnimation ??= ColorTween(
      begin: FlutterFlowTheme.of(context).primaryText,
      end: FlutterFlowTheme.of(context).primary,
    ).animate(_animationController);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 8),
                child: Text(
                  FFLocalizations.of(context).getText('glzsjd4b'),
                  style: AppStyles.textCairo(
                    context,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _labelColorAnimation!.value,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovering
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).alternate,
                      width: _borderAnimation.value,
                    ),
                    boxShadow: _isHovering
                        ? [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        TextFormField(
                          controller: widget.dateOfBirthTextController,
                          focusNode: widget.dateOfBirthFocusNode,
                          readOnly: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText:
                                FFLocalizations.of(context).getText('glzsjd4b'),
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintText: FFLocalizations.of(context)
                                .getText('dateOfBirth_hint'),
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16, 24, 16, 24),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return FFLocalizations.of(context)
                                  .getText('dateOfBirth_required');
                            }
                            return null;
                          },
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(
                                  const Duration(days: 6570)), // ~18 years
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.fromSeed(
                                        seedColor: FlutterFlowTheme.of(context)
                                            .primary),
                                    textTheme: TextTheme(
                                      bodyMedium: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        textStyle: AppStyles.textCairo(context,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              widget.onDateSelected(date);
                            }
                          },
                        ),
                        // Subtle gradient overlay when hovering
                        if (_isHovering)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context)
                                        .primary
                                        .withOpacity(0.03),
                                    FlutterFlowTheme.of(context)
                                        .primary
                                        .withOpacity(0.06),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
