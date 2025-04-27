import 'package:iron_fit/Ad/AdService.dart';
import 'package:logging/logging.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'coach_home_widget.dart' show CoachHomeWidget;
import 'package:flutter/material.dart';

class CoachHomeModel extends FlutterFlowModel<CoachHomeWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for coachNav component.
  final Logger logger = Logger('CoachHomeModel');
  static bool isRouteActive = false;
  late AdService adService;

  // UI state management
  late ValueNotifier<bool> isLoading = ValueNotifier(false);
  late ValueNotifier<String?> error = ValueNotifier(null);

  @override
  void initState(BuildContext context) {
    adService = AdService();
    isRouteActive = true;
  }

  @override
  void dispose() {
    isLoading.dispose();
    error.dispose();
    isRouteActive = false;
  }
}
