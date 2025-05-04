import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_choice_chips.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:iron_fit/trainee/user_enter_info/components/material3_text_field.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:lottie/lottie.dart';

class PhysicalInfoStep extends StatelessWidget {
  final TextEditingController heightController;
  final FocusNode heightFocusNode;
  final TextEditingController weightController;
  final FocusNode weightFocusNode;
  final String? genderValue;
  final FormFieldController<List<String>> genderValueController;
  final Function(List<String>?) onGenderChanged;

  const PhysicalInfoStep({
    super.key,
    required this.heightController,
    required this.heightFocusNode,
    required this.weightController,
    required this.weightFocusNode,
    required this.genderValue,
    required this.genderValueController,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Cache localization to avoid repeated lookups
    final localizations = FFLocalizations.of(context);
    final theme = FlutterFlowTheme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: const ValueKey('physical_info_step'),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Header with Lottie
            _buildAnimatedHeader(context, theme, localizations),
            SizedBox(height: ResponsiveUtils.height(context, 12)),

            // Gender Selection with Enhanced Animation
            _buildGenderSelection(context, theme, localizations),
            SizedBox(height: ResponsiveUtils.height(context, 12)),

            // Height and Weight Fields with Enhanced Design
            _buildMeasurementsSection(context, theme, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, FlutterFlowTheme theme,
      FFLocalizations localizations) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primary.withValues(alpha: 0.15),
                    theme.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Lottie.asset(
                    'assets/lottie/fitness_stats.json',
                    fit: BoxFit.cover,
                    animate: true,
                    repeat: true,
                    height: ResponsiveUtils.height(context, 80),
                  ),
                  SizedBox(width: ResponsiveUtils.width(context, 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.getText(
                              'w2zhnn8t' /* Your Physical Attributes */),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderSelection(BuildContext context, FlutterFlowTheme theme,
      FFLocalizations localizations) {
    // Memoize chip options to avoid recreation on each build
    final chipOptions = [
      ChipData(
          localizations.getText('of3kkd2s' /* Male */), Icons.male_rounded),
      ChipData(
          localizations.getText('0qvrqp4v' /* Female */), Icons.female_rounded),
    ];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.alternate,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.getText('gciphuh3' /* Gender */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 16)),
                  Row(
                    children: [
                      Icon(
                        Icons.wc_rounded,
                        color: theme.primary,
                        size: ResponsiveUtils.iconSize(context, 24),
                      ),
                      SizedBox(width: ResponsiveUtils.width(context, 12)),
                      Expanded(
                        child: FlutterFlowChoiceChips(
                          options: chipOptions,
                          onChanged: onGenderChanged,
                          controller: genderValueController,
                          selectedChipStyle: ChipStyle(
                            backgroundColor: theme.primary,
                            textStyle: AppStyles.textCairo(
                              context,
                              color: theme.info,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                            ),
                            iconColor: theme.info,
                            iconSize: ResponsiveUtils.iconSize(context, 20),
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                ResponsiveUtils.width(context, 16), 
                                ResponsiveUtils.height(context, 8), 
                                ResponsiveUtils.width(context, 16), 
                                ResponsiveUtils.height(context, 8)),
                            elevation: 4,
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: theme.primaryBackground,
                            textStyle: AppStyles.textCairo(
                              context,
                              color: theme.secondaryText,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                            ),
                            iconColor: theme.secondaryText,
                            iconSize: ResponsiveUtils.iconSize(context, 20),
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                ResponsiveUtils.width(context, 16), 
                                ResponsiveUtils.height(context, 8), 
                                ResponsiveUtils.width(context, 16), 
                                ResponsiveUtils.height(context, 8)),
                            elevation: 0,
                          ),
                          chipSpacing: ResponsiveUtils.width(context, 12),
                          rowSpacing: ResponsiveUtils.height(context, 12),
                          multiselect: false,
                          alignment: WrapAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeasurementsSection(BuildContext context, FlutterFlowTheme theme,
      FFLocalizations localizations) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 24)),
              padding: ResponsiveUtils.padding(context, horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.alternate,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _MeasurementFields(
                heightController: heightController,
                heightFocusNode: heightFocusNode,
                weightController: weightController,
                weightFocusNode: weightFocusNode,
                localizations: localizations,
                theme: theme,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extract measurement fields into a separate widget to reduce rebuilds
class _MeasurementFields extends StatelessWidget {
  final TextEditingController heightController;
  final FocusNode heightFocusNode;
  final TextEditingController weightController;
  final FocusNode weightFocusNode;
  final FFLocalizations localizations;
  final FlutterFlowTheme theme;

  const _MeasurementFields({
    required this.heightController,
    required this.heightFocusNode,
    required this.weightController,
    required this.weightFocusNode,
    required this.localizations,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.getText('body_metrics' /* Body Measurements */),
          style: AppStyles.textCairo(
            context,
            fontSize: ResponsiveUtils.fontSize(context, 16),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 20)),

        // Height Field
        _buildMeasurementField(
          controller: heightController,
          focusNode: heightFocusNode,
          icon: Icons.height,
          label: localizations.getText('5vy2q12i' /* Height */),
          placeholder: localizations.getText('ipep4d7i' /* Height in cm */),
          keyboardType: TextInputType.number,
          suffixText: 'cm',
          context: context,
        ),
        SizedBox(height: ResponsiveUtils.height(context, 16)),

        // Weight Field
        _buildMeasurementField(
          controller: weightController,
          focusNode: weightFocusNode,
          icon: Icons.monitor_weight_rounded,
          label: localizations.getText('tcxcdcm7' /* Weight */),
          placeholder: localizations.getText('kt2idkx2' /* Weight in kg */),
          keyboardType: TextInputType.number,
          suffixText: 'kg',
          context: context,
        ),
      ],
    );
  }

  Widget _buildMeasurementField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String label,
    required String placeholder,
    required TextInputType keyboardType,
    required String suffixText,
    required BuildContext context,
  }) {
    return Material3TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      title: label,
      labelText: label,
      hintText: placeholder,
      prefixIcon: icon,
      suffixText: suffixText,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return localizations.getText('fieldIsRequired');
        }

        final parsedValue = int.tryParse(val);
        if (parsedValue == null) {
          return localizations.getText('inputMustBeNumber');
        }

        // Additional validation for height/weight ranges can be added here

        return null;
      },
    );
  }
}
