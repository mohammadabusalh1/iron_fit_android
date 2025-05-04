import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/trainee/user_enter_info/components/profile_image_uploader.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:iron_fit/widgets/build_text_filed.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:lottie/lottie.dart';

class PersonalInfoStep extends StatelessWidget {
  final TextEditingController fullNameController;
  final FocusNode fullNameFocusNode;
  final TextEditingController dateOfBirthController;
  final FocusNode dateOfBirthFocusNode;
  final String uploadedFileUrl;
  final bool isDataUploading;
  final Function() onImageSelected;

  const PersonalInfoStep({
    super.key,
    required this.fullNameController,
    required this.fullNameFocusNode,
    required this.dateOfBirthController,
    required this.dateOfBirthFocusNode,
    required this.uploadedFileUrl,
    required this.isDataUploading,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: const ValueKey('personal_info_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message with Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Center(
                    child: Text(
                      FFLocalizations.of(context)
                          .getText('welcome_message' /* Welcome to Iron Fit */),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 24),
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Welcome Animation with Scaling
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween<double>(begin: 0.8, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Center(
                  child: SizedBox(
                    height: ResponsiveUtils.height(context, 130),
                    child: Lottie.asset(
                      'assets/lottie/welcome_wave.json',
                      animate: true,
                      repeat: true,
                      options: LottieOptions(enableMergePaths: true),
                    ),
                  ),
                ),
              );
            },
          ),

          // Profile Image Upload Section
          ProfileImageUploader(
            uploadedFileUrl: uploadedFileUrl,
            isUploading: isDataUploading,
            onImageSelected: onImageSelected,
          ),

          SizedBox(height: ResponsiveUtils.height(context, 32)),

          // Form Fields with Staggered Animation
          ..._buildStaggeredFormFields(context),
        ],
      ),
    );
  }

  // Helper method to build staggered form fields
  List<Widget> _buildStaggeredFormFields(BuildContext context) {
    return [
      // Full Name Field
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: Expanded(
                  child: buildTextField(
                    maxLines: 1,
                    controller: fullNameController,
                    focusNode: fullNameFocusNode,
                    labelText: FFLocalizations.of(context)
                        .getText('9vr3ekng' /* Full Name */),
                    hintText: FFLocalizations.of(context)
                        .getText('error_empty_full_name'),
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return FFLocalizations.of(context)
                            .getText('fieldIsRequired');
                      }
                      return null;
                    },
                    context: context,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      SizedBox(height: ResponsiveUtils.height(context, 16)),

      // Date of Birth Field
      TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: Expanded(
                  child: buildTextField(
                    controller: dateOfBirthController,
                    focusNode: dateOfBirthFocusNode,
                    labelText: FFLocalizations.of(context)
                        .getText('glzsjd4b' /* Date of Birth */),
                    hintText: FFLocalizations.of(context)
                        .getText('dateOfBirthIsRequired'),
                    prefixIcon: Icons.cake_rounded,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 18)),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: FlutterFlowTheme.of(context).primary,
                                onPrimary: FlutterFlowTheme.of(context).info,
                                surface: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                onSurface:
                                    FlutterFlowTheme.of(context).primaryText,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              textTheme: TextTheme(
                                headlineMedium: TextStyle(
                                  fontSize: ResponsiveUtils.fontSize(context, 18),
                                ),
                                bodyLarge: TextStyle(
                                  color: FlutterFlowTheme.of(context).info,
                                ), // Changes year color
                                bodyMedium: TextStyle(
                                  color: FlutterFlowTheme.of(context).info,
                                ), // Ensure other text changes
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        dateOfBirthController.text =
                            date.toIso8601String().split('T')[0];
                      }
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return FFLocalizations.of(context)
                            .getText('fieldIsRequired');
                      }
                      return null;
                    },
                    context: context,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
