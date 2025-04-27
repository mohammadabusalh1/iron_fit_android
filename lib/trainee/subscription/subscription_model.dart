import 'package:iron_fit/componants/user_nav/user_nav_model.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_widget.dart' show SubscriptionWidget;
import 'package:flutter/material.dart';

class SubscriptionModel extends FlutterFlowModel<SubscriptionWidget> {
  late UserNavModel userNavModel;

  @override
  void initState(BuildContext context) {
    userNavModel = createModel(context, () => UserNavModel());
  }

  @override
  void dispose() {
    userNavModel.dispose();
  }
}
