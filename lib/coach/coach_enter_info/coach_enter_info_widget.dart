import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/utils/logger.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coach_enter_info_model.dart';
import 'sections/personal_info_section.dart';
import 'sections/expertise_section.dart';
import 'sections/pricing_section.dart';
import 'sections/gym_info_section.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
export 'coach_enter_info_model.dart';

// State provider for coach info entry
class CoachInfoState extends ChangeNotifier {
  final CoachEnterInfoModel model = CoachEnterInfoModel();
  CoachRecord? existingCoach;
  GymRecord? existingGym;

  // Stage management
  int _currentStage = 0;
  int _currentSubStage = 0;
  final List<int> _subStagesCount = const [
    2,
    3,
    1,
    4
  ]; // Personal Info, Expertise, Pricing, Gym Info
  int _total = 0;
  bool _isSaving = false;
  bool _isDataUploading = false;

  // Cached section widgets
  final Map<String, Widget> _cachedSections = {};

  // Getters
  int get currentStage => _currentStage;
  int get currentSubStage => _currentSubStage;
  int get total => _total;
  bool get isSaving => _isSaving;
  bool get isDataUploading => _isDataUploading;
  Map<String, Widget> get cachedSections => _cachedSections;

  void initialize(bool isEditing) {
    if (isEditing) {
      _loadExistingData();
    }
  }

  Future<void> _loadExistingData() async {
    try {
      existingCoach = currentCoachDocument;

      // Load coach data into model
      model.fullNameTextController.text = currentUserDisplayName;
      model.uploadedFileUrl = currentUserPhoto;
      model.dateOfBirthTextController.text = existingCoach!.dateOfBirth != null
          ? dateTimeFormat('yyyy-MM-dd', existingCoach!.dateOfBirth)
          : '';
      model.yearsofExperienceTextController.text =
          existingCoach!.experience.toString();
      model.aboutMeTextController.text = existingCoach!.aboutMe;
      model.specializationsValue = existingCoach!.specialization;
      model.priceTextController.text = existingCoach!.price.toString();
      // Load gym data if available
      if (existingCoach!.gym != null) {
        final gymSnapshot = await existingCoach!.gym!.get();

        try {
          existingGym = GymRecord.fromSnapshot(gymSnapshot);

          model.gymNameController.text = existingGym!.name;
          model.gymWebsiteController.text = existingGym!.website;
          model.gymPhotos = existingGym!.photos;
          model.gymCountryController.text = existingGym!.country;
          model.gymCityController.text = existingGym!.city;
          model.gymAddressController.text = existingGym!.address;
          // model.gymLocation = existingGym!.location;
          model.gymPhoneController.text = existingGym!.phoneNumber;
          model.gymEmailController.text = existingGym!.email;

          // Safely handle socialMedia Map<String, dynamic> to Map<String, String>
          if (existingGym!.socialMedia.isNotEmpty) {
            model.gymInstagramController.text =
                existingGym!.socialMedia['instagram']?.toString() ?? '';
            model.gymFacebookController.text =
                existingGym!.socialMedia['facebook']?.toString() ?? '';
          }

          if (existingGym!.facilities.isNotEmpty) {
            model.selectedFacilities = existingGym!.facilities.toSet();
          }

          // Safely handle workingHours Map<String, dynamic> to Map<String, String>
          if (existingGym!.workingHours.isNotEmpty) {
            existingGym!.workingHours.forEach((key, value) {
              if (model.workingHoursControllers.containsKey(key)) {
                model.workingHoursControllers[key]!.text = value.toString();
              }
            });
          }
        } catch (e) {
          Logger.error('Error creating GymRecord from snapshot: $e');
          // Fallback: manually extract data from snapshot
          final data = gymSnapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            model.gymNameController.text = data['name'] as String? ?? '';
            model.gymWebsiteController.text = data['website'] as String? ?? '';
            model.gymPhotos = (data['photos'] as List?)?.cast<String>() ?? [];
            model.gymCountryController.text = data['country'] as String? ?? '';
            model.gymCityController.text = data['city'] as String? ?? '';
            model.gymAddressController.text = data['address'] as String? ?? '';
            model.gymPhoneController.text =
                data['phoneNumber'] as String? ?? '';
            model.gymEmailController.text = data['email'] as String? ?? '';

            // Handle social media
            final socialMedia = data['socialMedia'] as Map<String, dynamic>?;
            if (socialMedia != null) {
              model.gymInstagramController.text =
                  socialMedia['instagram']?.toString() ?? '';
              model.gymFacebookController.text =
                  socialMedia['facebook']?.toString() ?? '';
            }

            // Handle facilities
            model.selectedFacilities = ((data['facilities'] as List?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    [])
                .toSet();

            // Handle working hours
            final workingHours = data['workingHours'] as Map<String, dynamic>?;
            if (workingHours != null) {
              workingHours.forEach((key, value) {
                if (model.workingHoursControllers.containsKey(key)) {
                  model.workingHoursControllers[key]!.text = value.toString();
                }
              });
            }
          }
        }
      }

      notifyListeners();
    } catch (e) {
      Logger.error('Error loading existing coach data: $e');
    }
  }

  void nextInput(BuildContext context) async {
    while (_isDataUploading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (_currentSubStage < _subStagesCount[_currentStage] - 1) {
      _currentSubStage++;
      _total++;
    } else if (_currentStage < _subStagesCount.length - 1) {
      _currentStage++;
      _currentSubStage = 0;
      _total++;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      _buildRequestFocus(context);
    });
    notifyListeners();
  }

  void onFieldSubmitted(BuildContext context) {
    if (validateCurrentInput()) {
      nextInput(context);
    }
  }

  void previousInput() {
    if (_currentSubStage > 0) {
      _currentSubStage--;
      _total--;
    } else if (_currentStage > 0) {
      _currentStage--;
      _currentSubStage = _subStagesCount[_currentStage] - 1;
      _total--;
    }
    notifyListeners();
  }

  bool validateCurrentInput() {
    bool isValid = true;

    switch (_currentStage) {
      case 0: // Personal Info
        switch (_currentSubStage) {
          case 0: // Profile Photo
            isValid = true; // Optional
            break;
          case 1: // Full Name
            isValid = model.fullNameTextController.text.isNotEmpty &&
                model.dateOfBirthTextController.text.isNotEmpty;
            break;
        }
        break;
      case 1: // Expertise
        switch (_currentSubStage) {
          case 0: // Years of Experience
            isValid = model.yearsofExperienceTextController.text.isNotEmpty &&
                int.tryParse(model.yearsofExperienceTextController.text)! < 100;
            break;
          case 1: // About Me
            isValid = model.aboutMeTextController.text.isNotEmpty;
            break;
          case 2: // Specializations
            isValid = model.specializationsValue != null;
            break;
        }
        break;
      case 2: // Pricing
        isValid = model.priceTextController.text.isNotEmpty;
        break;
      case 3: // Gym Info
        switch (_currentSubStage) {
          case 0: // Basic Info
            isValid = model.gymNameController.text.isNotEmpty;
            break;
          case 1: // Location
            isValid = model.gymCountryController.text.isNotEmpty &&
                model.gymCityController.text.isNotEmpty &&
                model.gymAddressController.text.isNotEmpty;
            break;
          case 2: // Contact
            isValid = model.gymPhoneController.text.isNotEmpty &&
                model.gymEmailController.text.isNotEmpty;
            break;
          case 3: // Facilities
            isValid = true; // Optional
            break;
        }
        break;
    }

    return isValid;
  }

  void _buildRequestFocus(BuildContext context) {
    switch (_currentStage) {
      case 0: // Personal Info
        switch (_currentSubStage) {
          case 1: // Full Name
            FocusScope.of(context).requestFocus(model.fullNameFocusNode);
            break;
        }
        break;
      case 1: // Expertise
        switch (_currentSubStage) {
          case 0: // Years of Experience
            FocusScope.of(context)
                .requestFocus(model.yearsofExperienceFocusNode);
            break;
          case 1: // About Me
            FocusScope.of(context).requestFocus(model.aboutMeFocusNode);
            break;
        }
        break;
      case 2: // Pricing
        FocusScope.of(context).requestFocus(model.priceFocusNode);
        break;
      case 3: // Gym Info
        switch (_currentSubStage) {
          case 0: // Basic Info
            FocusScope.of(context).requestFocus(model.gymNameFocusNode);
            break;
          case 1: // Location
            FocusScope.of(context).requestFocus(model.gymCountryFocusNode);
            break;
          case 2: // Contact
            FocusScope.of(context).requestFocus(model.gymPhoneFocusNode);
            break;
        }
        break;
    }
  }

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setDataUploading(bool value) {
    _isDataUploading = value;
    notifyListeners();
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

  Future<void> updateProfile(BuildContext context) async {
    if (model.isSaving) return;

    try {
      setSaving(true);

      while (_isDataUploading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Create the LatLng data properly
      final locationData = model.gymLocation != null
          ? {
              'latitude': model.gymLocation!.latitude,
              'longitude': model.gymLocation!.longitude
            }
          : null;

      // Update gym record if exists, create if doesn't
      DocumentReference gymRef;
      if (existingCoach?.gym != null) {
        gymRef = existingCoach!.gym!;
        await gymRef.update({
          'name': model.gymNameController.text,
          'website': model.gymWebsiteController.text,
          'photos': model.gymPhotos,
          'country': model.gymCountryController.text,
          'city': model.gymCityController.text,
          'address': model.gymAddressController.text,
          'location': locationData,
          'phoneNumber': model.gymPhoneController.text,
          'email': model.gymEmailController.text,
          'socialMedia': {
            'instagram': model.gymInstagramController.text,
            'facebook': model.gymFacebookController.text,
          },
          'facilities': model.selectedFacilities.toList(),
          'workingHours': model.workingHoursControllers.map(
            (key, controller) => MapEntry(key, controller.text),
          ),
        });
      } else {
        // Create new gym record
        final gymData = {
          'name': model.gymNameController.text,
          'website': model.gymWebsiteController.text,
          'photos': model.gymPhotos,
          'country': model.gymCountryController.text,
          'city': model.gymCityController.text,
          'address': model.gymAddressController.text,
          'location': locationData,
          'phoneNumber': model.gymPhoneController.text,
          'email': model.gymEmailController.text,
          'socialMedia': {
            'instagram': model.gymInstagramController.text,
            'facebook': model.gymFacebookController.text,
          },
          'facilities': model.selectedFacilities.toList(),
          'workingHours': model.workingHoursControllers.map(
            (key, controller) => MapEntry(key, controller.text),
          ),
        };
        final gymDoc = await GymRecord.collection.add(gymData);
        gymRef = gymDoc;
      }

      // Update coach record
      await currentCoachDocument!.reference.update(createCoachRecordData(
        experience: int.tryParse(model.yearsofExperienceTextController.text),
        price: int.tryParse(model.priceTextController.text),
        specialization: model.specializationsValue,
        aboutMe: model.aboutMeTextController.text,
        dateOfBirth: DateTime.parse(model.dateOfBirthTextController.text),
        gym: gymRef,
        gymName: model.gymNameController.text,
      ));

      // Update user record
      await currentUserReference!.update(createUserRecordData(
        displayName: model.fullNameTextController.text,
        photoUrl: model.uploadedFileUrl,
      ));

      showSuccessDialog(
        FFLocalizations.of(context).getText('profileUpdatedSuccessfully'),
        context,
      );

      context.pop();
    } catch (e) {
      showErrorDialog(FFLocalizations.of(context).getText('2184r6dy'), context);
      Logger.error('Error occurred: $e');
    } finally {
      setSaving(false);
    }
  }

  Future<void> createProfile(BuildContext context) async {
    if (model.isSaving) return;

    try {
      setSaving(true);

      while (_isDataUploading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Create the LatLng data properly
      final locationData = model.gymLocation != null
          ? {
              'latitude': model.gymLocation!.latitude,
              'longitude': model.gymLocation!.longitude
            }
          : null;

      // Create gym record first
      final gymData = {
        'name': model.gymNameController.text,
        'website': model.gymWebsiteController.text,
        'photos': model.gymPhotos,
        'country': model.gymCountryController.text,
        'city': model.gymCityController.text,
        'address': model.gymAddressController.text,
        'location': locationData,
        'phoneNumber': model.gymPhoneController.text,
        'email': model.gymEmailController.text,
        'socialMedia': {
          'instagram': model.gymInstagramController.text,
          'facebook': model.gymFacebookController.text,
        },
        'facilities': model.selectedFacilities.toList(),
        'workingHours': model.workingHoursControllers.map(
          (key, controller) => MapEntry(key, controller.text),
        ),
      };
      final gymRef = await GymRecord.collection.add(gymData);

      // Update coach record with gym reference
      final coachRecord = await CoachRecord.collection
          .where('user', isEqualTo: currentUserReference)
          .snapshots()
          .first;

      await coachRecord.docs.first.reference.update(createCoachRecordData(
        user: currentUserReference,
        isSub: false,
        experience: int.tryParse(model.yearsofExperienceTextController.text),
        price: int.tryParse(model.priceTextController.text),
        specialization: model.specializationsValue,
        aboutMe: model.aboutMeTextController.text,
        dateOfBirth: DateTime.parse(model.dateOfBirthTextController.text),
        gym: gymRef, // Add gym reference
        gymName: model.gymNameController.text,
      ));

      await currentUserReference!.update(createUserRecordData(
        role: FFAppState().userType,
        displayName: model.fullNameTextController.text,
        photoUrl: model.uploadedFileUrl,
        createdTime: DateTime.now(),
      ));

      await _waitForAuth();
      await context.pushNamed('CoachHome');
    } catch (e) {
      showErrorDialog(FFLocalizations.of(context).getText('2184r6dy'), context);
      Logger.error('Error occurred: $e');
    } finally {
      setSaving(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    model.dispose();
    _cachedSections.clear();
  }
}

class CoachEnterInfoWidget extends StatefulWidget {
  /// I want you to create coach Enter Information page
  const CoachEnterInfoWidget({
    super.key,
    this.isEditing = false,
  });

  final bool isEditing;

  @override
  State<CoachEnterInfoWidget> createState() => _CoachEnterInfoWidgetState();
}

class _CoachEnterInfoWidgetState extends State<CoachEnterInfoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    initIsEditing();
  }

  initIsEditing() {
    if (widget.isEditing != null) {
      isEditMode = widget.isEditing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final state = CoachInfoState();
        state.initialize(widget.isEditing);
        return state;
      },
      child: Builder(builder: (context) {
        final coachInfoState = Provider.of<CoachInfoState>(context);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
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
                          Colors.blue.withOpacity(0.05),
                          FlutterFlowTheme.of(context).primaryBackground,
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.height(context, 16)),
                      _buildStageIndicator(context, coachInfoState),
                      SizedBox(height: ResponsiveUtils.height(context, 16)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child:
                                      _getCurrentInput(context, coachInfoState),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildNavigationButtons(context, coachInfoState),
                    ],
                  ),
                  if (isEditMode)
                    Positioned(
                      top: ResponsiveUtils.height(context, 16),
                      left: ResponsiveUtils.width(context, 16),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: ResponsiveUtils.iconSize(context, 24),
                        ),
                      ),
                    ),
                  if (isEditMode)
                    Positioned(
                      top: ResponsiveUtils.height(context, 16),
                      right: ResponsiveUtils.width(context, 16),
                      child: FFButtonWidget(
                        onPressed: () {
                          coachInfoState.updateProfile(context);
                        },
                        text: FFLocalizations.of(context).getText('finish'),
                        options: FFButtonOptions(
                          height: ResponsiveUtils.height(context, 45.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: AppStyles.textCairo(context,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).black,
                              fontSize: ResponsiveUtils.fontSize(context, 12)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStageIndicator(BuildContext context, CoachInfoState state) {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 16.0),
      child: Text(
        '${FFLocalizations.of(context).getText('step')} ${state.total + 1} / 10',
        style: AppStyles.textCairo(
          context,
          fontSize: ResponsiveUtils.fontSize(context, 16),
          fontWeight: FontWeight.bold,
          color: FlutterFlowTheme.of(context).primary,
        ),
      ),
    );
  }

  Widget _getCurrentInput(BuildContext context, CoachInfoState state) {
    final sectionKey =
        'stage_${state.currentStage}_substage_${state.currentSubStage}';

    if (state.cachedSections.containsKey(sectionKey)) {
      return state.cachedSections[sectionKey]!;
    }

    Widget section;
    switch (state.currentStage) {
      case 0: // Personal Info
        section = PersonalInfoSection(
          key: ValueKey(sectionKey),
          model: state.model,
          context: context,
          currentSubStage: state.currentSubStage,
          isEditing: isEditMode,
        );
        break;
      case 1: // Expertise
        section = ExpertiseSection(
          key: ValueKey(sectionKey),
          model: state.model,
          context: context,
          currentSubStage: state.currentSubStage,
        );
        break;
      case 2: // Pricing
        section = PricingSection(
          key: ValueKey(sectionKey),
          model: state.model,
          context: context,
        );
        break;
      case 3: // Gym Info
        section = GymInfoSection(
          key: ValueKey(sectionKey),
          model: state.model,
          context: context,
          currentSubStage: state.currentSubStage,
        );
        break;
      default:
        section = const SizedBox();
    }

    state.cachedSections[sectionKey] = section;
    return section;
  }

  Widget _buildNavigationButtons(BuildContext context, CoachInfoState state) {
    final isLastInput = state.currentStage ==
            state._subStagesCount.length - 1 &&
        state.currentSubStage == state._subStagesCount[state.currentStage] - 1;

    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentStage > 0 || state.currentSubStage > 0)
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(right: ResponsiveUtils.width(context, 8)),
                child: FFButtonWidget(
                  onPressed: state.previousInput,
                  text: FFLocalizations.of(context).getText('previous'),
                  options: FFButtonOptions(
                    height: ResponsiveUtils.height(context, 45.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                    ),
                    elevation: 3.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(
                        ResponsiveUtils.width(context, 28.0)),
                  ),
                ),
              ),
            ),
          SizedBox(width: ResponsiveUtils.width(context, 8)),
          Expanded(
            child: FFButtonWidget(
              icon: state.isDataUploading
                  ? SizedBox(
                      width: ResponsiveUtils.width(context, 20),
                      height: ResponsiveUtils.height(context, 20),
                      child: CircularProgressIndicator(
                        color: FlutterFlowTheme.of(context).black,
                        strokeWidth: 2,
                      ),
                    )
                  : null,
              onPressed: () {
                if (!state.validateCurrentInput()) {
                  showErrorDialog(
                    FFLocalizations.of(context).getText('emptyOrErrorFields'),
                    context,
                  );
                  return;
                }

                if (isLastInput) {
                  if (isEditMode) {
                    state.updateProfile(context);
                  } else {
                    state.createProfile(context);
                  }
                } else {
                  state.nextInput(context);
                }
              },
              text: isLastInput
                  ? isEditMode
                      ? FFLocalizations.of(context).getText('update')
                      : FFLocalizations.of(context).getText('jj2o77x1')
                  : FFLocalizations.of(context).getText('next'),
              options: FFButtonOptions(
                height: ResponsiveUtils.height(context, 45.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: AppStyles.textCairo(
                  context,
                  fontWeight: FontWeight.w700,
                  color: FlutterFlowTheme.of(context).black,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                ),
                elevation: 3.0,
                borderRadius:
                    BorderRadius.circular(ResponsiveUtils.width(context, 28.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
