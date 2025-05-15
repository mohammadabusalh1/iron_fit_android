// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iron_fit/componants/styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:iron_fit/trainee/user_enter_info/components/error_dialog.dart';
import 'package:iron_fit/trainee/user_enter_info/components/goals_step.dart';
import 'package:iron_fit/trainee/user_enter_info/components/navigation_buttons.dart';
import 'package:iron_fit/trainee/user_enter_info/components/rest_time_step.dart';
import 'package:iron_fit/trainee/user_enter_info/components/step_indicator.dart';
import 'package:iron_fit/trainee/user_enter_info/components/training_time_step.dart';
import 'package:iron_fit/trainee/user_enter_info/components/profile_image_uploader.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_enter_info_model.dart';
import 'package:iron_fit/utils/logger.dart';
export 'user_enter_info_model.dart';

class UserEnterInfoWidget extends StatefulWidget {
  const UserEnterInfoWidget({
    super.key,
  });

  @override
  State<UserEnterInfoWidget> createState() => _UserEnterInfoWidgetState();
}

class _UserEnterInfoWidgetState extends State<UserEnterInfoWidget> {
  late UserEnterInfoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Add step tracking
  int _currentStep = 0;
  final int _totalSteps = 9; // Increased steps to separate each field

  // Cache localization strings
  late final _localizations = FFLocalizations.of(context);

  // Memoize static widgets to prevent rebuilds
  late final _stepTitles = [
    _localizations.getText('profile_image_step' /* Profile Photo */),
    _localizations.getText('name_step' /* Full Name */),
    _localizations.getText('birthdate_step' /* Date of Birth */),
    _localizations.getText('gender_step' /* Gender */),
    _localizations.getText('height_step' /* Height */),
    _localizations.getText('weight_step' /* Weight */),
    _localizations.getText('goals_step' /* Fitness Goals */),
    _localizations.getText('training_time_step' /* Training Time */),
    _localizations.getText('rest_time_step' /* Rest Time */),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserEnterInfoModel());
    _initializeControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeControllers() {
    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();
    _model.dateOfBirthTextController ??= TextEditingController();
    _model.dateOfBirthFocusNode ??= FocusNode();
    _model.hightTextController ??= TextEditingController();
    _model.hightFocusNode ??= FocusNode();
    _model.weightTextController ??= TextEditingController();
    _model.weightFocusNode ??= FocusNode();
    _model.goalValueController ??= FormFieldController<List<String>>([]);
    _model.genderValueController ??= FormFieldController<List<String>>([]);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('user_enter_info_page'),
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      FlutterFlowTheme.of(context)
                          .success
                          .withValues(alpha: 0.1),
                      FlutterFlowTheme.of(context).primaryBackground,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: ResponsiveUtils.padding(context, horizontal: 16),
                child: Column(
                  children: [
                    StepIndicator(
                      currentStep: _currentStep,
                      totalSteps: _totalSteps,
                      stepTitles: _stepTitles,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.05, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildCurrentStep(),
                          ),
                        ),
                      ),
                    ),
                    NavigationButtons(
                      currentStep: _currentStep,
                      isLastStep: _currentStep == _totalSteps - 1,
                      onPrevious: _handlePreviousStep,
                      onNext: _handleNextStep,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Memoized handler function to prevent recreating on every build
  void _handlePreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        // Profile Image Step
        return Container(
          key: const ValueKey('profile_image_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizations.getText('profile_image_title'),
                    style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context, 24),
                        ),
                  ),
                  SizedBox(height: ResponsiveUtils.height(context, 8)),
                  Text(
                    '${_localizations.getText('profile_image_description')}.',
                    style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context, 14),
                        ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              ProfileImageUploader(
                uploadedFileUrl: _model.uploadedFileUrl,
                isUploading: _model.isDataUploading,
                onImageSelected: _handleProfileImageUpload,
                localImageBytes: _model.uploadedLocalFile.bytes,
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              Text(
                textAlign: TextAlign.center,
                '${_localizations.getText('uploadImageText')}.',
                style: AppStyles.textCairo(context,
                    fontSize: ResponsiveUtils.fontSize(context, 16),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );

      case 1:
        // Full Name Step
        return Container(
          key: const ValueKey('full_name_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizations.getText('name_title'),
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 24),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                _localizations.getText('name_description'),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              TextFormField(
                controller: _model.fullNameTextController,
                focusNode: _model.fullNameFocusNode,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: _localizations.getText('9vr3ekng'),
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
                  hintText: _localizations.getText('name_hint'),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: ResponsiveUtils.padding(
                    context,
                    horizontal: 16,
                    vertical: 24,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                maxLength: 50,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return _localizations.getText('name_required');
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case 2:
        // Date of Birth Step
        return Container(
          key: const ValueKey('date_of_birth_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizations.getText('birthdate_title'),
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 24),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                _localizations.getText('birthdate_description'),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              TextFormField(
                controller: _model.dateOfBirthTextController,
                focusNode: _model.dateOfBirthFocusNode,
                readOnly: true,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: _localizations.getText('glzsjd4b'),
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
                  hintText: _localizations.getText('dateOfBirth_hint'),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: ResponsiveUtils.padding(
                    context,
                    horizontal: 16,
                    vertical: 24,
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return _localizations.getText('dateOfBirth_required');
                  }
                  return null;
                },
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now()
                        .subtract(const Duration(days: 6570)), // ~18 years
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: FlutterFlowTheme.of(context).primary),
                          textTheme: TextTheme(
                            bodyMedium: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .copyWith(
                                  fontSize:
                                      ResponsiveUtils.fontSize(context, 14),
                                ),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              textStyle: AppStyles.textCairo(context,
                                  fontSize:
                                      ResponsiveUtils.fontSize(context, 16),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      _model.dateOfBirthTextController?.text =
                          date.toIso8601String().split('T')[0];
                    });
                  }
                },
              ),
            ],
          ),
        );

      case 3:
        // Gender Step
        return Container(
          key: const ValueKey('gender_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizations.getText('gender_title'),
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 24),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                _localizations.getText('gender_description'),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              Column(
                children: [
                  FFLocalizations.of(context).getText('of3kkd2s'),
                  FFLocalizations.of(context).getText('0qvrqp4v'),
                ]
                    .map(
                      (gender) => Container(
                        margin: EdgeInsets.only(
                            bottom: ResponsiveUtils.height(context, 16)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _model.genderValue == gender
                              ? FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.1)
                              : FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                          border: Border.all(
                            color: _model.genderValue == gender
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => setState(() =>
                              _model.genderValueController!.value = [gender]),
                          child: Padding(
                            padding: ResponsiveUtils.padding(context,
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Icon(
                                  gender == 'Male' ? Icons.male : Icons.female,
                                  color: _model.genderValue == gender
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  size: ResponsiveUtils.iconSize(context, 24),
                                ),
                                SizedBox(
                                    width: ResponsiveUtils.width(context, 12)),
                                Text(
                                  gender,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .copyWith(
                                        fontSize: ResponsiveUtils.fontSize(
                                            context, 16),
                                        color: _model.genderValue == gender
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : FlutterFlowTheme.of(context)
                                                .primaryText,
                                        fontWeight: _model.genderValue == gender
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                                const Spacer(),
                                if (_model.genderValue == gender)
                                  Icon(
                                    Icons.check_circle,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: ResponsiveUtils.iconSize(context, 24),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );

      case 4:
        // Height Step
        return Container(
          key: const ValueKey('height_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizations.getText('height_title'),
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 24),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                _localizations.getText('height_description'),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              TextFormField(
                controller: _model.hightTextController,
                focusNode: _model.hightFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _localizations.getText('ipep4d7i'),
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
                  hintText: _localizations.getText('height_hint'),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: ResponsiveUtils.padding(
                    context,
                    horizontal: 16,
                    vertical: 24,
                  ),
                  prefixIcon: Icon(
                    Icons.height,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  suffixText: 'cm',
                  suffixStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return _localizations.getText('height_required');
                  }
                  final height = int.tryParse(val);
                  if (height == null || height < 100 || height > 250) {
                    return _localizations.getText('invalid_height_range');
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case 5:
        // Weight Step
        return Container(
          key: const ValueKey('weight_step'),
          padding: ResponsiveUtils.padding(context, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizations.getText('kt2idkx2'),
                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 24),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 8)),
              Text(
                _localizations.getText('weight_description'),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
              ),
              SizedBox(height: ResponsiveUtils.height(context, 30)),
              TextFormField(
                controller: _model.weightTextController,
                focusNode: _model.weightFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _localizations.getText('kt2idkx2'),
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
                  hintText: _localizations.getText('weight_hint'),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                      ),
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
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding: ResponsiveUtils.padding(
                    context,
                    horizontal: 16,
                    vertical: 24,
                  ),
                  prefixIcon: Icon(
                    Icons.monitor_weight_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: ResponsiveUtils.iconSize(context, 24),
                  ),
                  suffixText: 'kg',
                  suffixStyle: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return _localizations.getText('weight_required');
                  }
                  final weight = int.tryParse(val);
                  if (weight == null || weight < 30 || weight > 200) {
                    return _localizations.getText('invalid_weight_range');
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case 6:
        // Goals Step
        return GoalsStep(
          key: const ValueKey('goals_step'),
          selectedGoal: _model.goalValue,
          onGoalSelected: _handleGoalSelected,
        );

      case 7:
        // Training Time Step - updated to use single time
        return TrainingTimeStep(
          key: const ValueKey('training_time_step'),
          initialTime: _model.trainingTime,
          onTimeSelected: _handleTrainingTimeSelected,
        );

      case 8:
        // Rest Time Step
        return RestTimeStep(
          key: const ValueKey('rest_time_step'),
          initialRestTime: _model.preferredRestTime,
          onRestTimeSelected: _handleRestTimeSelected,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // Handler callbacks
  void _handleGoalSelected(String goal) {
    if (_model.goalValue != goal) {
      setState(() => _model.goalValue = goal);
    }
  }

  void _handleTrainingTimeSelected(TimeOfDay time) {
    setState(() => _model.trainingTime = time);
  }

  void _handleRestTimeSelected(int seconds) {
    setState(() => _model.preferredRestTime = seconds);
  }

  Future<void> _handleNextStep() async {
    bool isValid = false;

    switch (_currentStep) {
      case 0: // Profile Image Step
        // Check if we have either a local image or a remote URL
        if (_model.uploadedFileUrl.isEmpty &&
            (_model.uploadedLocalFile.bytes == null ||
                _model.uploadedLocalFile.bytes!.isEmpty)) {
          Logger.warning('Photo upload step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('photoHint'),
          );
          isValid = false;
          break;
        }
        isValid = true;
        break;

      case 1: // Full Name Step
        isValid = _model.fullNameTextController.text.isNotEmpty;
        if (!isValid) {
          Logger.warning('Name step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('name_required'),
          );
        }
        break;

      case 2: // Date of Birth Step
        isValid = _model.dateOfBirthTextController.text.isNotEmpty;
        if (!isValid) {
          Logger.warning('Date of birth step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('dateOfBirth_required'),
          );
        }
        break;

      case 3: // Gender Step
        isValid = _model.genderValue != null;
        if (!isValid) {
          Logger.warning('Gender step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('gender_required'),
          );
        }
        break;

      case 4: // Height Step
        isValid = _model.hightTextController.text.isNotEmpty;

        if (isValid) {
          final height = int.tryParse(_model.hightTextController.text);
          if (height == null || height < 100 || height > 250) {
            Logger.warning(
                'Invalid height value: ${_model.hightTextController.text}');
            ErrorDialog.show(
              context,
              _localizations.getText('invalid_height_range'),
            );
            return;
          }
        } else {
          Logger.warning('Height step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('height_required'),
          );
        }
        break;

      case 5: // Weight Step
        isValid = _model.weightTextController.text.isNotEmpty;

        if (isValid) {
          final weight = int.tryParse(_model.weightTextController.text);
          if (weight == null || weight < 30 || weight > 200) {
            Logger.warning(
                'Invalid weight value: ${_model.weightTextController.text}');
            ErrorDialog.show(
              context,
              _localizations.getText('invalid_weight_range'),
            );
            return;
          }
        } else {
          Logger.warning('Weight step validation failed');
          ErrorDialog.show(
            context,
            _localizations.getText('weight_required'),
          );
        }
        break;

      case 6: // Goals Step
        isValid = _model.goalValue != null;
        if (!isValid) {
          Logger.warning('Goal step validation failed - no goal selected');
          ErrorDialog.show(
            context,
            _localizations.getText('goalIsRequired'),
          );
        }
        break;

      case 7: // Training Time Step (single time now)
        isValid = _model.trainingTime != null;
        if (!isValid) {
          Logger.warning(
              'Training time step validation failed - no time selected');
          ErrorDialog.show(
            context,
            _localizations.getText('training_time_required'),
          );
        }
        break;

      case 8: // Rest Time Step
        isValid = _model.preferredRestTime != null;
        if (!isValid) {
          Logger.warning('Rest time step validation failed - no time selected');
          ErrorDialog.show(
            context,
            _localizations.getText('rest_time_required'),
          );
        }
        break;
    }

    if (isValid) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
          // Focus the appropriate input field after step change
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setFocusForCurrentStep();
          });
        });
      } else {
        await _saveProfile();
      }
    }
  }

  // Helper method to set focus for the current step
  void _setFocusForCurrentStep() {
    switch (_currentStep) {
      case 1: // Full Name Step
        _model.fullNameFocusNode?.requestFocus();
        break;
      case 2: // Date of Birth Step
        _model.dateOfBirthFocusNode?.requestFocus();
        break;
      case 4: // Height Step
        _model.hightFocusNode?.requestFocus();
        break;
      case 5: // Weight Step
        _model.weightFocusNode?.requestFocus();
        break;
      // Other steps don't have traditional input fields to focus
    }
  }

  Future<void> _handleProfileImageUpload() async {
    try {
      setState(() => _model.isDataUploading = true);
      final selectedMedia = await selectMedia(
        mediaSource: MediaSource.photoGallery,
        multiImage: false,
      );
      if (selectedMedia != null &&
          selectedMedia
              .every((m) => validateFileFormat(m.storagePath, context))) {
        // Store selected file locally instead of uploading immediately
        final media = selectedMedia.first;
        _model.uploadedLocalFile = FFUploadedFile(
          name: media.storagePath.split('/').last,
          bytes: media.bytes ?? Uint8List(0),
          height: media.dimensions?.height,
          width: media.dimensions?.width,
          blurHash: media.blurHash,
        );

        // Store the XFile for later upload
        if (media.bytes != null) {
          _model.localImageFile = XFile.fromData(
            media.bytes!,
            name: media.storagePath.split('/').last,
          );
        }

        // Clear Firebase URL since we haven't uploaded yet
        _model.uploadedFileUrl = '';

        Logger.info('Profile image selected and stored locally');
      } else {
        Logger.warning('Invalid file format selected for profile image');
      }
    } catch (e, stackTrace) {
      Logger.error('Error selecting profile image',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        showErrorDialog(_localizations.getText('failedToUploadImage'), context);
      }
    } finally {
      if (mounted) {
        setState(() => _model.isDataUploading = false);
      }
    }
  }

  static Future<void> _waitForAuth() async {
    // Check every 100ms until authentication is available
    while (currentUserReference == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (FFAppState().userType == 'coach') {
      authenticatedCoachStream.listen((_) {});

      while (currentCoachDocument == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } else if (FFAppState().userType == 'trainee') {
      authenticatedTraineeStream.listen((_) {});
      while (currentTraineeDocument == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      await _waitForAuth();
      Logger.info('Starting profile save process');
      setState(() => _model.isSaving = true);

      if (!_validateForm()) {
        Logger.warning('Form validation failed during save');
        return;
      }

      // Upload image to Firebase if we have a local image file
      if (_model.localImageFile != null) {
        try {
          Logger.info('Uploading profile image to Firebase');
          setState(() => _model.isDataUploading = true);

          // If we already have a previous uploaded image URL, delete it
          if (_model.uploadedFileUrl.isNotEmpty) {
            try {
              await FirebaseStorage.instance
                  .refFromURL(_model.uploadedFileUrl)
                  .delete();
              Logger.info('Previous profile image deleted');
            } catch (e) {
              Logger.warning('Failed to delete previous image: $e');
            }
          }

          // Generate a unique path for the image
          final fileName =
              '${currentUserUid}_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final path = 'users/$currentUserUid/profile_images/$fileName';

          // Upload the image to Firebase Storage
          final uploadResult = await uploadData(
              path, _model.uploadedLocalFile.bytes ?? Uint8List(0));
          if (uploadResult != null) {
            _model.uploadedFileUrl = uploadResult;
            Logger.info('Profile image uploaded successfully to Firebase');
          } else {
            Logger.error('Failed to upload profile image - null result');
            if (mounted) {
              showErrorDialog(
                  _localizations.getText('failedToUploadImage'), context);
              return;
            }
          }
        } catch (e, stackTrace) {
          Logger.error('Failed to upload profile image to Firebase',
              error: e, stackTrace: stackTrace);
          if (mounted) {
            showErrorDialog(
                _localizations.getText('failedToUploadImage'), context);
            return;
          }
        } finally {
          if (mounted) {
            setState(() => _model.isDataUploading = false);
          }
        }
      }

      // Convert single TimeOfDay to serializable format for Firestore
      final trainingTimeString = _model.trainingTime != null
          ? '${_model.trainingTime!.hour.toString().padLeft(2, '0')}:${_model.trainingTime!.minute.toString().padLeft(2, '0')}'
          : '';

      Logger.info('Updating trainee information');
      currentTraineeDocument!.reference.update(createTraineeRecordData(
        user: currentUserReference,
        gender: _model.genderValue,
        height: int.tryParse(_model.hightTextController.text),
        weight: int.tryParse(_model.weightTextController.text),
        goal: _model.goalValue,
        dateOfBirth: DateTime.parse(_model.dateOfBirthTextController.text),
        trainingTimes: trainingTimeString.isNotEmpty ? trainingTimeString : '',
        preferredRestTime: _model.preferredRestTime,
        weightHistory: [
          {
            'weight': int.tryParse(_model.weightTextController.text),
            'date': DateTime.now().toIso8601String(),
          }
        ],
      ));

      Logger.info('Updating user profile');
      await currentUserReference!.update(createUserRecordData(
        role: FFAppState().userType,
        displayName: _model.fullNameTextController.text,
        photoUrl: _model.uploadedFileUrl,
      ));

      Logger.info('Profile saved successfully, navigating to home');
      if (mounted) {
        context.pushNamed('UserHome');
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to save user profile',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        showErrorDialog(_localizations.getText('2184r6dy'), context);
      }
    } finally {
      if (mounted) {
        setState(() => _model.isSaving = false);
      }
    }
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      Logger.warning('Form validation failed - form has errors');
      ErrorDialog.show(
        context,
        FFLocalizations.of(context).getText('emptyOrErrorFields'),
      );
      return false;
    }
    return true;
  }
}
