import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/responsive_utils.dart';
import 'package:iron_fit/componants/Styles.dart';

class WeightInputDialog extends StatefulWidget {
  final String exerciseName;
  final Function(int? weight) onWeightSubmitted;

  const WeightInputDialog({
    super.key,
    required this.exerciseName,
    required this.onWeightSubmitted,
  });

  @override
  State<WeightInputDialog> createState() => _WeightInputDialogState();
}

class _WeightInputDialogState extends State<WeightInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitWeight() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Trigger haptic feedback
      HapticFeedback.mediumImpact();

      final weight = int.parse(_weightController.text);
      widget.onWeightSubmitted(weight);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Dialog(
      backgroundColor: theme.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16)),
      ),
      child: Padding(
        padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context).getText('weight_input_title'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 16)),
              Text(
                '${FFLocalizations.of(context).getText('weight_input_subtitle')} ${widget.exerciseName}',
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  color: theme.secondaryText,
                ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 24)),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      FFLocalizations.of(context).getText('weight_input_label'),
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return FFLocalizations.of(context)
                        .getText('weight_input_required');
                  }
                  final weight = int.tryParse(value);
                  if (weight == null || weight < 1 || weight > 500) {
                    return FFLocalizations.of(context)
                        .getText('weight_input_invalid');
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveUtils.height(context, 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            widget.onWeightSubmitted(null);
                            Navigator.pop(context);
                          },
                    child: Text(
                      FFLocalizations.of(context).getText('cancel'),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 16)),
                  FFButtonWidget(
                    onPressed: _isSubmitting ? null : _submitWeight,
                    text: FFLocalizations.of(context).getText('submit'),
                    options: FFButtonOptions(
                      width: ResponsiveUtils.width(context, 120),
                      height: ResponsiveUtils.height(context, 40),
                      color: theme.primary,
                      textStyle: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
