import 'package:flutter/material.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart' hide LatLng;
import 'package:iron_fit/flutter_flow/form_field_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

/// Model class for the coach information entry form.
/// Handles the state management for all form fields and file upload functionality.
class CoachEnterInfoModel extends FlutterFlowModel {
  /// Stores the locally uploaded file
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  /// Stores the URL of the uploaded file
  String uploadedFileUrl = '';

  /// Indicates if the form is currently being saved
  bool isSaving = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for FullName widget.
  final TextEditingController fullNameTextController = TextEditingController();
  late FocusNode fullNameFocusNode = FocusNode();
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  // State field(s) for dateOfBirth widget.
  final TextEditingController dateOfBirthTextController =
      TextEditingController();
  late FocusNode dateOfBirthFocusNode = FocusNode();
  String? Function(BuildContext, String?)? dateOfBirthTextControllerValidator;
  // State field(s) for YearsofExperience widget.
  final TextEditingController yearsofExperienceTextController =
      TextEditingController();
  late FocusNode yearsofExperienceFocusNode = FocusNode();
  String? Function(BuildContext, String?)?
      yearsofExperienceTextControllerValidator;
  // State field(s) for AboutMe widget.
  final TextEditingController aboutMeTextController = TextEditingController();
  late FocusNode aboutMeFocusNode = FocusNode();
  String? Function(BuildContext, String?)? aboutMeTextControllerValidator;
  // State field(s) for Specializations widget.
  String? specializationsValue;
  FormFieldController<List<String>>? specializationsValueController;
  // State field(s) for Price widget.
  final TextEditingController priceTextController = TextEditingController();
  late FocusNode priceFocusNode = FocusNode();
  String? Function(BuildContext, String?)? priceTextControllerValidator;
  // State field(s) for GymName widget.
  final TextEditingController gymNameController = TextEditingController();
  late FocusNode gymNameFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymNameTextControllerValidator;

  // Gym Info Controllers
  final TextEditingController gymWebsiteController = TextEditingController();

  late FocusNode gymWebsiteFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymWebsiteTextControllerValidator;

  final TextEditingController gymCountryController = TextEditingController();

  late FocusNode gymCountryFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymCountryTextControllerValidator;

  final TextEditingController gymCityController = TextEditingController();

  late FocusNode gymCityFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymCityTextControllerValidator;

  final TextEditingController gymAddressController = TextEditingController();

  late FocusNode gymAddressFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymAddressTextControllerValidator;

  final TextEditingController gymPhoneController = TextEditingController();

  late FocusNode gymPhoneFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymPhoneTextControllerValidator;

  final TextEditingController gymEmailController = TextEditingController();

  late FocusNode gymEmailFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymEmailTextControllerValidator;

  final TextEditingController gymInstagramController = TextEditingController();

  late FocusNode gymInstagramFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymInstagramTextControllerValidator;

  final TextEditingController gymFacebookController = TextEditingController();

  late FocusNode gymFacebookFocusNode = FocusNode();
  String? Function(BuildContext, String?)? gymFacebookTextControllerValidator;

  // Gym Location
  gmaps.LatLng? gymLocation;

  // Gym Photos
  List<String> gymPhotos = [];

  // Gym Facilities
  Set<String> selectedFacilities = {};

  // Working Hours
  final Map<String, TextEditingController> workingHoursControllers = {
    'Monday': TextEditingController(),
    'Tuesday': TextEditingController(),
    'Wednesday': TextEditingController(),
    'Thursday': TextEditingController(),
    'Friday': TextEditingController(),
    'Saturday': TextEditingController(),
    'Sunday': TextEditingController(),
  };

  /// Initializes all controllers and focus nodes
  @override
  void initState(BuildContext context) {
    fullNameFocusNode = FocusNode();
    dateOfBirthFocusNode = FocusNode();
    yearsofExperienceFocusNode = FocusNode();
    aboutMeFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    gymNameFocusNode = FocusNode();
  }

  /// Disposes all controllers and focus nodes to prevent memory leaks
  @override
  void dispose() {
    fullNameTextController.dispose();
    fullNameFocusNode.dispose();

    dateOfBirthTextController.dispose();
    dateOfBirthFocusNode.dispose();

    yearsofExperienceTextController.dispose();
    yearsofExperienceFocusNode.dispose();

    aboutMeTextController.dispose();
    aboutMeFocusNode.dispose();

    priceTextController.dispose();
    priceFocusNode.dispose();

    gymNameController.dispose();
    gymNameFocusNode.dispose();

    gymWebsiteController.dispose();
    gymCountryController.dispose();
    gymCityController.dispose();
    gymAddressController.dispose();
    gymPhoneController.dispose();
    gymEmailController.dispose();
    gymInstagramController.dispose();
    gymFacebookController.dispose();

    workingHoursControllers.values
        .forEach((controller) => controller.dispose());
  }
}
