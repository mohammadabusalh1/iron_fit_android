import 'package:iron_fit/flutter_flow/custom_functions.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'edit_user_info_dialog_model.dart';
import 'components/index.dart';
export 'edit_user_info_dialog_model.dart';

class EditUserInfoDialogWidget extends StatefulWidget {
  const EditUserInfoDialogWidget({
    super.key,
    required this.name,
    required this.trainee,
    this.onProfileUpdated,
  });

  final String? name;
  final TraineeRecord? trainee;
  final VoidCallback? onProfileUpdated;

  @override
  State<EditUserInfoDialogWidget> createState() =>
      _EditUserInfoDialogWidgetState();
}

class _EditUserInfoDialogWidgetState extends State<EditUserInfoDialogWidget>
    with SingleTickerProviderStateMixin {
  late EditUserInfoDialogModel _model;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Animation controller for dialog animations
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Memoized widgets
  DialogHeader? _dialogHeader;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditUserInfoDialogModel());
    try {
      _initializeControllers();

      // Initialize animation controller
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );

      _scaleAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
        ),
      );

      _animationController.forward();
    } catch (e, stackTrace) {
      Logger.error('Error initializing dialog widget', e, stackTrace);
    }
  }

  void _initializeControllers() {
    try {
      _model.fullNameTextController ??=
          TextEditingController(text: widget.name);
      _model.weightTextController ??=
          TextEditingController(text: widget.trainee?.weight.toString());
      _model.heightTextController ??=
          TextEditingController(text: widget.trainee?.height.toString());
      _model.goalTextController ??=
          TextEditingController(text: widget.trainee?.goal);
      _model.fullNameFocusNode ??= FocusNode();
      _model.weightFocusNode ??= FocusNode();
      _model.heightFocusNode ??= FocusNode();
      _model.goalFocusNode ??= FocusNode();
      _model.uploadedFileUrl = currentUserPhoto;
      _model.dateOfBirthTextController =
          TextEditingController(text: widget.trainee?.dateOfBirth.toString());
      _model.dateOfBirthFocusNode = FocusNode();
      _model.gender = widget.trainee?.gender;
      Logger.debug('Controllers initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Error initializing controllers', e, stackTrace);
      // Continue execution as controllers might be partially initialized
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Trigger haptic feedback on save attempt
      HapticFeedback.mediumImpact();

      setState(() => _isSaving = true);
      try {
        Logger.info('Updating user profile information');
        while (_model.isDataUploading) {
          Logger.info('Waiting for image upload to complete');
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Update user record
        await currentUserReference!.update(createUserRecordData(
          displayName: _model.fullNameTextController.text,
          photoUrl: _model.uploadedFileUrl,
        ));
        Logger.debug('User record updated successfully');

        // Update trainee record
        await widget.trainee?.reference.update(createTraineeRecordData(
          weight: int.parse(_model.weightTextController.text),
          height: int.parse(_model.heightTextController.text),
          goal: _model.goalTextController.text,
          dateOfBirth: DateTime.parse(_model.dateOfBirthTextController!.text),
          gender: _model.gender,
        ));
        Logger.debug('Trainee record updated successfully');

        if (mounted) {
          Logger.info('Profile update completed successfully');

          // Notify parent widget that profile was updated
          if (widget.onProfileUpdated != null) {
            widget.onProfileUpdated!();
          }

          // Display success animation and message
          _showSuccessOverlay();
        }

        // Delay pop to show success animation
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          await context.pushNamed('userProfile');
        }
      } catch (e, stackTrace) {
        Logger.error('Error updating profile', e, stackTrace);

        if (mounted) {
          String errorMessage = FFLocalizations.of(context).getText('2184r6dy');
          if (e is FormatException) {
            Logger.warning('Invalid format in form fields');
            errorMessage = FFLocalizations.of(context).getText('invalidFormat');
          } else if (e.toString().contains('permission')) {
            Logger.warning('Permission denied while updating profile');
            errorMessage =
                FFLocalizations.of(context).getText('permissionDenied');
          }

          showErrorDialog(errorMessage, context);
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    } else {
      // Trigger haptic feedback for validation failure
      HapticFeedback.vibrate();

      Logger.warning('Form validation failed - empty or invalid fields');
      showErrorDialog(
          FFLocalizations.of(context).getText('emptyOrErrorFields'), context);
    }
  }

  void _showSuccessOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset(
              'assets/lottie/success.json', // Use local asset instead of network
              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
        ),
      ),
    );
  }

  // Get or create header
  DialogHeader _getHeader(BuildContext context) {
    return _dialogHeader ??= DialogHeader(
      title: FFLocalizations.of(context).getText('7fjp01ai'),
      onClose: () {
        // Trigger haptic feedback
        HapticFeedback.lightImpact();
        _animationController.reverse().then((_) {
          context.safePop();
        });
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Backdrop with blur
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: () {}, // Prevents taps from passing through
                  child: Container(
                    color: FlutterFlowTheme.of(context).black.withOpacity(0.2),
                  ),
                ),
              ),
            ),

            // Card Container with glass-like effect
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    maxHeight: screenSize.height * 0.9,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(28.0),
                    boxShadow: [
                      BoxShadow(
                        color:
                            FlutterFlowTheme.of(context).black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.05),
                        blurRadius: 30,
                        spreadRadius: -5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: FlutterFlowTheme.of(context)
                          .primary
                          .withOpacity(0.08),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with Title and Close Button
                              _getHeader(context),

                              // Profile Section
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: ProfileImageComponent(
                                      uploadedFileUrl: _model.uploadedFileUrl,
                                      onImageUploaded: (url) {
                                        // Trigger haptic feedback on image upload
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          _model.uploadedFileUrl = url;
                                          _model.isDataUploading = false;
                                        });
                                      },
                                      onImageChanged: () {
                                        setState(() {
                                          _model.isDataUploading = true;
                                        });
                                      }),
                                ),
                              ),

                              CustomTextField(
                                label: FFLocalizations.of(context)
                                    .getText('u3yo2th2'),
                                hintText: FFLocalizations.of(context)
                                    .getText('enter_full_name_hint'),
                                controller: _model.fullNameTextController!,
                                focusNode: _model.fullNameFocusNode!,
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? FFLocalizations.of(context)
                                            .getText('fullNameIsRequired')
                                        : null,
                                icon: Icons.person,
                                onChanged: (_) {},
                              ),
                              const SizedBox(height: 20.0),

                              DateOfBirthField(
                                dateOfBirthFocusNode:
                                    _model.dateOfBirthFocusNode!,
                                dateOfBirthTextController:
                                    _model.dateOfBirthTextController!,
                                onDateSelected: (date) {
                                  // Trigger haptic feedback on date selection
                                  HapticFeedback.selectionClick();
                                  _model.dateOfBirthTextController!.text =
                                      date.toString();
                                },
                              ),

                              const SizedBox(height: 20.0),

                              GenderField(
                                initialGender: widget.trainee?.gender,
                                onGenderSelected: (gender) {
                                  // Set the selected gender in model
                                  setState(() {
                                    _model.gender = gender;
                                  });
                                  Logger.debug('Gender selected: $gender');
                                },
                              ),

                              const SizedBox(height: 20.0),

                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: FFLocalizations.of(context)
                                          .getText('g6q5j6kk'),
                                      hintText: FFLocalizations.of(context)
                                          .getText('weight_input_label'),
                                      controller: _model.weightTextController!,
                                      focusNode: _model.weightFocusNode!,
                                      keyboardType: TextInputType.number,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? FFLocalizations.of(context)
                                                  .getText('weightIsRequired')
                                              : null,
                                      icon: Icons.monitor_weight_outlined,
                                      onChanged: (_) {},
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 16.0), // Increased spacing
                                  Expanded(
                                    child: CustomTextField(
                                      label: FFLocalizations.of(context)
                                          .getText('jpb8oaaf'),
                                      hintText: FFLocalizations.of(context)
                                          .getText('ipep4d7i'),
                                      controller: _model.heightTextController!,
                                      focusNode: _model.heightFocusNode!,
                                      keyboardType: TextInputType.number,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? FFLocalizations.of(context)
                                                  .getText('heightIsRequired')
                                              : null,
                                      icon: Icons.height_outlined,
                                      onChanged: (_) {},
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20.0), // Increased spacing

                              // Fitness Goals Section
                              CustomTextField(
                                label: FFLocalizations.of(context)
                                    .getText('8nhiubwi'),
                                controller: _model.goalTextController!,
                                focusNode: _model.goalFocusNode!,
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? FFLocalizations.of(context)
                                            .getText('goalIsRequired')
                                        : null,
                                icon: Icons.flag_outlined,
                                maxLines: 3,
                                hintText: FFLocalizations.of(context)
                                    .getText('label_training_goals'),
                                isLastField: true,
                                onChanged: (_) {},
                              ),

                              const SizedBox(
                                  height:
                                      32.0), // Increased spacing for better layout

                              // Save Button
                              SaveButton(
                                isSaving: _isSaving,
                                onSave: _saveChanges,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Floating close button for larger screens
            if (!isSmallScreen)
              Positioned(
                top: -15,
                right: -15,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context)
                                .black
                                .withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            // Trigger haptic feedback
                            HapticFeedback.lightImpact();
                            _animationController.reverse().then((_) {
                              context.safePop();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.close_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
