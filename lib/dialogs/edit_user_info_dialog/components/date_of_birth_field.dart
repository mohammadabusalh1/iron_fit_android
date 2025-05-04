import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/responsive_utils.dart';

class DateOfBirthField extends StatefulWidget {
  const DateOfBirthField({
    super.key,
    required this.dateOfBirthFocusNode,
    required this.dateOfBirthTextController,
    required this.onDateSelected,
  });

  final FocusNode dateOfBirthFocusNode;
  final TextEditingController dateOfBirthTextController;
  final Function(DateTime) onDateSelected;

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.dateOfBirthFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.dateOfBirthFocusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = widget.dateOfBirthFocusNode.hasFocus;
    });
    if (widget.dateOfBirthFocusNode.hasFocus) {
      _showDatePicker();
    }
  }

  Future<void> _showDatePicker() async {
    // Unfocus to prevent keyboard from showing
    widget.dateOfBirthFocusNode.unfocus();

    // Calculate dates for picker
    final DateTime now = DateTime.now();
    final DateTime minDate = DateTime(now.year - 100, now.month, now.day);
    final DateTime maxDate = DateTime(now.year - 10, now.month, now.day);
    
    DateTime initialDate;
    try {
      initialDate = DateTime.parse(widget.dateOfBirthTextController.text);
      // Ensure initialDate is within the allowed range
      if (initialDate.isBefore(minDate)) {
        initialDate = minDate;
      } else if (initialDate.isAfter(maxDate)) {
        initialDate = maxDate;
      }
    } catch (e) {
      // Use a reasonable default if the current value can't be parsed
      initialDate = DateTime(now.year - 25, now.month, now.day);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary,
              onPrimary: FlutterFlowTheme.of(context).info,
              onSurface: FlutterFlowTheme.of(context).primaryText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Update the text field with the selected date
      widget.dateOfBirthTextController.text = picked.toString();
      
      // Notify parent of the selection
      widget.onDateSelected(picked);
      
      // Provide haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            ResponsiveUtils.width(context, 4),
            0,
            0, 
            ResponsiveUtils.height(context, 8)
          ),
          child: Text(
            FFLocalizations.of(context).getText('glzsjd4b'),
            style: AppStyles.textCairo(
              context,
              fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w500,
              fontSize: ResponsiveUtils.fontSize(context, 14),
              color: _isFocused 
                  ? FlutterFlowTheme.of(context).primary 
                  : FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
            boxShadow: _isFocused
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
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
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                    hintText: FFLocalizations.of(context)
                        .getText('dateOfBirth_hint'),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: ResponsiveUtils.width(context, 2),
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: ResponsiveUtils.width(context, 2),
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: ResponsiveUtils.width(context, 2),
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: ResponsiveUtils.width(context, 2),
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: ResponsiveUtils.padding(
                      context,
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.7),
                      size: ResponsiveUtils.iconSize(context, 20),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.fontSize(context, 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return FFLocalizations.of(context).getText('dateRequired');
                    }
                    try {
                      DateTime.parse(value);
                      return null;
                    } catch (e) {
                      return FFLocalizations.of(context).getText('invalidDate');
                    }
                  },
                  onTap: _showDatePicker,
                ),
                // Invisible button overlay to ensure good tap area
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      highlightColor: Colors.transparent,
                      onTap: _showDatePicker,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
