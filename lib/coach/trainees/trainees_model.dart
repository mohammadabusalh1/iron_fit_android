import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'trainees_widget.dart' show TraineesWidget;
import 'package:flutter/material.dart';

class TraineesModel extends FlutterFlowModel<TraineesWidget> {
  ///  Local state fields for this page.

  int? numOFSubs;

  @override
  void initState(BuildContext context) {}

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<SubscriptionsRecord>? subsData;
  // Model for coachNav component.

  @override
  void dispose() {}
}
