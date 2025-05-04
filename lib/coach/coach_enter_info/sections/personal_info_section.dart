import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iron_fit/backend/firebase_storage/storage.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/upload_data.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:iron_fit/widgets/build_text_filed.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../coach_enter_info_model.dart';
import '../coach_enter_info_widget.dart';

class PersonalInfoSection extends StatelessWidget {
  final CoachEnterInfoModel model;
  final BuildContext context;
  final int currentSubStage;
  final bool isEditing;

  const PersonalInfoSection({
    super.key,
    required this.model,
    required this.context,
    required this.currentSubStage,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentInput(context),
        ),
      ],
    );
  }

  Widget _buildCurrentInput(BuildContext context) {
    // Create new widget based on current sub-stage
    switch (currentSubStage) {
      case 0:
        return _buildImage(context);
      case 1:
        return _buildPersonalInfo(context);
      default:
        return const SizedBox();
    }
  }

  Future<void> _handleImageSelection(BuildContext context) async {
    /// The above code is using the Provider package in Dart to obtain the current state of the
    /// CoachInfoState class without listening for any changes. The `listen: false` parameter ensures
    /// that the widget does not rebuild when the state changes.
    final state = Provider.of<CoachInfoState>(context, listen: false);
    final errorMessage =
        FFLocalizations.of(context).getText('failedToUploadImage');

    // Set loading state to true before upload
    state.setDataUploading(true);

    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
    );

    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      try {
        if (model.uploadedFileUrl.isNotEmpty) {
          await FirebaseStorage.instance
              .refFromURL(model.uploadedFileUrl)
              .delete();
        }

        final downloadUrls = (await Future.wait(
          selectedMedia.map(
            (m) async => await uploadData(m.storagePath, m.bytes),
          ),
        ))
            .where((u) => u != null)
            .map((u) => u!)
            .toList();

        if (downloadUrls.isNotEmpty) {
          model.uploadedFileUrl = downloadUrls.first;
        } else {
          model.uploadedFileUrl = '';
        }
      } catch (e) {
        model.uploadedFileUrl = '';
        if (context.mounted) {
          showErrorDialog(errorMessage, context);
        }
      } finally {
        state.setDataUploading(false);
      }
    }else{
      state.setDataUploading(false);
    }
  }

  Widget _buildImage(BuildContext context) {
    final state = Provider.of<CoachInfoState>(context, listen: true);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: const ValueKey('personal_info_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isEditing) SizedBox(height: ResponsiveUtils.height(context, 24)),

          if (isEditing)
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Padding(
                      padding: ResponsiveUtils.padding(context, horizontal: 16.0, vertical: 16.0),
                      child: Text(
                        FFLocalizations.of(context).getText(
                            'edit_coach_info' /* Give the Coach a Makeover! 💇‍♂️📋 */),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: ResponsiveUtils.fontSize(context, 20),
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (isEditing) SizedBox(height: ResponsiveUtils.height(context, 24)),

          // Welcome Message with Animation
          if (!isEditing)
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
                        FFLocalizations.of(context).getText(
                            'welcome_message' /* Welcome to Iron Fit */),
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
          if (!isEditing)
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

          Hero(
            tag: 'profile_image',
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Profile Image Container with Ripple Effect
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: GestureDetector(
                          onTap: () => _handleImageSelection(context),
                          child: Container(
                            width: ResponsiveUtils.width(context, 160),
                            height: ResponsiveUtils.height(context, 160),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: FlutterFlowTheme.of(context)
                                      .primary
                                      .withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _buildProfileImage(context),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.height(context, 24)),

          ElevatedButton.icon(
            onPressed: state.isDataUploading
                ? null
                : () => _handleImageSelection(context),
            icon: Icon(
              model.uploadedFileUrl.isEmpty
                  ? Icons.add_photo_alternate
                  : Icons.edit,
              size: ResponsiveUtils.iconSize(context, 20),
            ),
            label: Text(
              model.uploadedFileUrl.isEmpty
                  ? FFLocalizations.of(context).getText('upload_photo')
                  : FFLocalizations.of(context).getText('change_photo'),
              style: AppStyles.textCairo(
                context,
                fontSize: ResponsiveUtils.fontSize(context, 14),
                fontWeight: FontWeight.w700,
                color: FlutterFlowTheme.of(context).black.withOpacity(0.8),
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: FlutterFlowTheme.of(context).primaryBackground,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12)),
              ),
              elevation: 2,
            ),
          ),

          // Profile Instructions Text
          Padding(
            padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 24),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: Text(
                      FFLocalizations.of(context)
                          .getText('coachUploadImageText'),
                      textAlign: TextAlign.center,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 16),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    final state = Provider.of<CoachInfoState>(context, listen: true);

    return state.isDataUploading
        ? Container(
            width: ResponsiveUtils.width(context, 160),
            height: ResponsiveUtils.height(context, 160),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/loading_avatar.json',
                width: ResponsiveUtils.width(context, 100),
                height: ResponsiveUtils.height(context, 100),
                animate: true,
                repeat: true,
                options: LottieOptions(enableMergePaths: true),
              ),
            ),
          )
        : model.uploadedFileUrl.isEmpty
            ? Container(
                width: ResponsiveUtils.width(context, 160),
                height: ResponsiveUtils.height(context, 160),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Lottie.asset(
                  'assets/lottie/profile_placeholder.json',
                  animate: true,
                  repeat: true,
                  options: LottieOptions(enableMergePaths: true),
                ),
              )
            : Image.network(
                model.uploadedFileUrl,
                width: ResponsiveUtils.width(context, 160),
                height: ResponsiveUtils.height(context, 160),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: ResponsiveUtils.width(context, 160),
                    height: ResponsiveUtils.height(context, 160),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: FlutterFlowTheme.of(context).info,
                      size: ResponsiveUtils.iconSize(context, 40),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: ResponsiveUtils.width(context, 160),
                    height: ResponsiveUtils.height(context, 160),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  );
                },
              );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Builder(
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          key: const ValueKey('personal_info_fields_step'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header text with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Padding(
                        padding: ResponsiveUtils.padding(context, horizontal: 16.0, vertical: 16.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                              'coach_personal_info' /* Personal Info */),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 22),
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Form fields with staggered animation
              ..._buildFormFields(context),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFormFields(BuildContext context) {
    final formFields = [
      _buildAnimatedFormField(
        index: 0,
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 8),
          child: buildTextField(
            onTap: () {
              // Move cursor to end of text
              if (isEditing) {
                model.fullNameTextController.selection =
                    TextSelection.fromPosition(
                  TextPosition(
                      offset: model.fullNameTextController.text.length),
                );
              }
            },
            context: context,
            controller: model.fullNameTextController,
            focusNode: model.fullNameFocusNode,
            labelText: FFLocalizations.of(context).getText('9vr3ekng'),
            hintText: FFLocalizations.of(context).getText('hint_enter_name'),
            validator: (val) => val == null || val.isEmpty
                ? FFLocalizations.of(context).getText('thisFieldIsRequired')
                : null,
            prefixIcon: Icons.person_outline,
            onFieldSubmitted: (_) =>
                Provider.of<CoachInfoState>(context, listen: false)
                    .onFieldSubmitted(context),
          ),
        ),
      ),
      _buildAnimatedFormField(
        index: 2,
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 8),
          child: buildTextField(
            context: context,
            controller: model.dateOfBirthTextController,
            focusNode: model.dateOfBirthFocusNode,
            labelText: FFLocalizations.of(context).getText('glzsjd4b'),
            hintText: FFLocalizations.of(context).getText('prqg6mlg'),
            readOnly: true,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2007),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: FlutterFlowTheme.of(context).primary),
                      textTheme: TextTheme(
                        bodyMedium: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          textStyle: AppStyles.textCairo(context,
                              fontSize: ResponsiveUtils.fontSize(context, 16), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                model.dateOfBirthTextController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
              }
            },
            validator: (val) => val == null || val.isEmpty
                ? FFLocalizations.of(context).getText('thisFieldIsRequired')
                : null,
            prefixIcon: Icons.calendar_today,
          ),
        ),
      ),
    ];

    return formFields;
  }

  Widget _buildAnimatedFormField({
    required int index,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}
