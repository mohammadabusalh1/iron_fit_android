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

  // Create a field to store validation error messages
  String? _validationErrorMessage;

  // Getter for validation error message
  String? get validationErrorMessage => _validationErrorMessage;

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
        final DocumentSnapshot gymSnapshot = await existingCoach!.gym!.get();

        try {
          existingGym = GymRecord.fromSnapshot(gymSnapshot);

          // Populate gym fields
          _populateGymFields(existingGym!);
        } catch (e) {
          Logger.error('Error loading gym record',
              error: e, extras: {'coachId': existingCoach?.reference?.id});

          // Fallback: manually extract data from snapshot
          _manuallyExtractGymData(gymSnapshot);
        }
      }

      notifyListeners();
    } catch (e) {
      Logger.error('Error loading existing coach data',
          error: e,
          stackTrace: StackTrace.current,
          extras: {'userId': currentUserUid});
    }
  }

  // New helper methods to clean up _loadExistingData
  void _populateGymFields(GymRecord gym) {
    model.gymNameController.text = gym.name;
    model.gymWebsiteController.text = gym.website;
    model.gymPhotos = gym.photos;
    model.gymCountryController.text = gym.country;
    model.gymCityController.text = gym.city;
    model.gymAddressController.text = gym.address;
    model.gymPhoneController.text = gym.phoneNumber;
    model.gymEmailController.text = gym.email;

    // Handle socialMedia
    if (gym.socialMedia.isNotEmpty) {
      model.gymInstagramController.text =
          gym.socialMedia['instagram']?.toString() ?? '';
      model.gymFacebookController.text =
          gym.socialMedia['facebook']?.toString() ?? '';
    }

    if (gym.facilities.isNotEmpty) {
      model.selectedFacilities = gym.facilities.toSet();
    }

    // Handle workingHours
    if (gym.workingHours.isNotEmpty) {
      gym.workingHours.forEach((key, value) {
        if (model.workingHoursControllers.containsKey(key)) {
          model.workingHoursControllers[key]!.text = value.toString();
        }
      });
    }
  }

  void _manuallyExtractGymData(DocumentSnapshot gymSnapshot) {
    final data = gymSnapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      model.gymNameController.text = data['name'] as String? ?? '';
      model.gymWebsiteController.text = data['website'] as String? ?? '';
      model.gymPhotos = (data['photos'] as List?)?.cast<String>() ?? [];
      model.gymCountryController.text = data['country'] as String? ?? '';
      model.gymCityController.text = data['city'] as String? ?? '';
      model.gymAddressController.text = data['address'] as String? ?? '';
      model.gymPhoneController.text = data['phoneNumber'] as String? ?? '';
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
      model.selectedFacilities =
          ((data['facilities'] as List?)?.map((e) => e.toString()).toList() ??
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

  void nextInput(BuildContext context) async {
    // Clear any previous error message
    _validationErrorMessage = null;

    // Prevent rapid clicking causing state issues
    if (_isDataUploading) {
      // Show visual feedback that we're waiting
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            FFLocalizations.of(context).getText('pleaseWaitProcessing'),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
      return;
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
    if (validateCurrentInput(context: context)) {
      nextInput(context);
    }
    // No need for SnackBar - the validation error will be displayed automatically
  }

  void previousInput() {
    // Clear any previous error message
    _validationErrorMessage = null;

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

  bool validateCurrentInput({required BuildContext context}) {
    bool isValid = true;
    _validationErrorMessage = null;

    switch (_currentStage) {
      case 0: // Personal Info
        switch (_currentSubStage) {
          case 0: // Profile Photo
            isValid = true; // Optional
            break;
          case 1: // Full Name
            if (model.fullNameTextController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterFullName');
            } else if (model.dateOfBirthTextController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterDateOfBirth');
            } else {
              // Validate date format
              try {
                DateTime.parse(model.dateOfBirthTextController.text);
              } catch (e) {
                isValid = false;
                _validationErrorMessage =
                    FFLocalizations.of(context).getText('invalidDateFormat');
                Logger.warning('Invalid date format entered',
                    extras: {'input': model.dateOfBirthTextController.text});
              }
            }
            break;
        }
        break;
      case 1: // Expertise
        switch (_currentSubStage) {
          case 0: // Years of Experience
            final yearsText = model.yearsofExperienceTextController.text;
            if (yearsText.isEmpty) {
              isValid = false;
              _validationErrorMessage = FFLocalizations.of(context)
                  .getText('pleaseEnterYearsOfExperience');
            } else {
              final years = int.tryParse(yearsText);
              if (years == null) {
                isValid = false;
                _validationErrorMessage = FFLocalizations.of(context)
                    .getText('pleaseEnterValidYearsNumber');
              } else if (years < 0 || years >= 100) {
                isValid = false;
                _validationErrorMessage =
                    FFLocalizations.of(context).getText('yearsExperienceRange');
              }
            }
            break;
          case 1: // About Me
            if (model.aboutMeTextController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseProvideAboutInfo');
            } else if (model.aboutMeTextController.text.length < 10) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('descriptionMinLength');
            }
            break;
          case 2: // Specializations
            if (model.specializationsValue == null) {
              isValid = false;
              _validationErrorMessage = FFLocalizations.of(context)
                  .getText('pleaseSelectSpecialization');
            }
            break;
        }
        break;
      case 2: // Pricing
        final priceText = model.priceTextController.text;
        if (priceText.isEmpty) {
          isValid = false;
          _validationErrorMessage =
              FFLocalizations.of(context).getText('pleaseEnterPrice');
        } else {
          final price = int.tryParse(priceText);
          if (price == null) {
            isValid = false;
            _validationErrorMessage =
                FFLocalizations.of(context).getText('pleaseEnterValidPrice');
          } else if (price <= 0) {
            isValid = false;
            _validationErrorMessage = FFLocalizations.of(context)
                .getText('priceMustBeGreaterThanZero');
          }
        }
        break;
      case 3: // Gym Info
        switch (_currentSubStage) {
          case 0: // Basic Info
            if (model.gymNameController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterGymName');
            }
            break;
          case 1: // Location
            if (model.gymCountryController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterCountry');
            } else if (model.gymCityController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterCity');
            } else if (model.gymAddressController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterAddress');
            }
            break;
          case 2: // Contact
            if (model.gymPhoneController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterGymPhone');
            } else if (model.gymEmailController.text.isEmpty) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterGymEmail');
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(model.gymEmailController.text)) {
              isValid = false;
              _validationErrorMessage =
                  FFLocalizations.of(context).getText('pleaseEnterValidEmail');
            }
            break;
          case 3: // Facilities
            isValid = true; // Optional
            break;
        }
        break;
    }

    // Notify listeners if there's an error message to show
    if (!isValid) {
      notifyListeners();
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
    int attempts = 0;
    const maxAttempts = 50; // 5 seconds timeout

    while (currentUserReference == null && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (currentUserReference == null) {
      Logger.error('Authentication timed out after 5 seconds');
      return;
    }

    if (FFAppState().userType == 'coach') {
      authenticatedCoachStream.listen((_) {});

      attempts = 0;
      while (currentCoachDocument == null && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (currentCoachDocument == null) {
        Logger.error('Coach document not found after 5 seconds');
      }
    } else if (FFAppState().userType == 'trainee') {
      authenticatedTraineeStream.listen((_) {});

      attempts = 0;
      while (currentTraineeDocument == null && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (currentTraineeDocument == null) {
        Logger.error('Trainee document not found after 5 seconds');
      }
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    if (model.isSaving) return;

    try {
      setSaving(true);

      if (_isDataUploading) {
        // Show visual feedback to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getText('finishingUploads'),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Wait with timeout for uploads to complete
        int attempts = 0;
        while (_isDataUploading && attempts < 50) {
          // 5 second timeout
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }

        if (_isDataUploading) {
          throw Exception('Upload process taking too long');
        }
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
      showErrorDialog(
          FFLocalizations.of(context).getText('errorUpdatingProfile'), context);
      Logger.error('Error updating profile',
          error: e,
          stackTrace: StackTrace.current,
          extras: {
            'userId': currentUserUid,
            'coachId': currentCoachDocument?.reference?.id
          });
    } finally {
      setSaving(false);
    }
  }

  Future<void> createProfile(BuildContext context) async {
    if (model.isSaving) return;

    try {
      setSaving(true);

      if (_isDataUploading) {
        // Show visual feedback to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FFLocalizations.of(context).getText('finishingUploads'),
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Wait with timeout for uploads to complete
        int attempts = 0;
        while (_isDataUploading && attempts < 50) {
          // 5 second timeout
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }

        if (_isDataUploading) {
          throw Exception('Upload process taking too long');
        }
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

      // Check if we have coach records
      if (coachRecord.docs.isEmpty) {
        throw Exception('No coach record found for user');
      }

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
      final errorMsg =
          FFLocalizations.of(context).getText('errorCreatingProfile');
      showErrorDialog(errorMsg, context);
      Logger.error('Error creating profile',
          error: e,
          stackTrace: StackTrace.current,
          extras: {'userId': currentUserUid});
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

    // Log page entry for analytics
    Logger.info('Coach enter info page opened',
        extras: {'isEditMode': widget.isEditing});
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
                          Colors.blue.withOpacity(0.05),
                          FlutterFlowTheme.of(context).primaryBackground,
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: ResponsiveUtils.height(context, 64)),
                      // _buildStageIndicator(context, coachInfoState),
                      // SizedBox(height: ResponsiveUtils.height(context, 16)),
                      Expanded(
                        child: SingleChildScrollView(
                          physics:
                              const ClampingScrollPhysics(), // Smoother scrolling
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
                          padding: ResponsiveUtils.padding(context,
                              horizontal: 16.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: AppStyles.textCairo(context,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).black,
                              fontSize: ResponsiveUtils.fontSize(context, 12)),
                        ),
                      ),
                    ),
                  // Loading overlay when saving
                  if (coachInfoState.isSaving)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            SizedBox(
                                height: ResponsiveUtils.height(context, 16)),
                            Text(
                              FFLocalizations.of(context)
                                  .getText('savingProfile'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize: ResponsiveUtils.fontSize(context, 16),
                                color: Colors.white,
                              ),
                            ),
                          ],
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
      child: Row(
        children: [
          Text(
            '${FFLocalizations.of(context).getText('step')} ${state.total + 1} / 10',
            style: AppStyles.textCairo(
              context,
              fontSize: ResponsiveUtils.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (state.total + 1) / 10,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              color: FlutterFlowTheme.of(context).primary,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show error message if validation failed
        if (state.validationErrorMessage != null)
          Padding(
            padding:
                ResponsiveUtils.padding(context, horizontal: 24, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: ResponsiveUtils.padding(context,
                  horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                state.validationErrorMessage!,
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).error,
                  fontSize: ResponsiveUtils.fontSize(context, 14),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -2),
              )
            ],
          ),
          padding:
              ResponsiveUtils.padding(context, horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.currentStage > 0 || state.currentSubStage > 0)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: ResponsiveUtils.width(context, 8)),
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
                    if (!state.validateCurrentInput(context: context)) {
                      // Error message will be displayed from validateCurrentInput
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
                          : FFLocalizations.of(context)
                              .getText('completeProfile')
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
                    borderRadius: BorderRadius.circular(
                        ResponsiveUtils.width(context, 28.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
