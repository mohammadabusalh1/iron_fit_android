import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/coach/trainees/components/trainee_card.dart';
import 'package:flutter/foundation.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class OptimizedSubscriptionList extends StatefulWidget {
  final List<SubscriptionsRecord> subscriptions;
  final bool isRequests;
  final Function(SubscriptionsRecord)? onRestore;
  final Function(SubscriptionsRecord)? onDelete;

  const OptimizedSubscriptionList({
    super.key,
    required this.subscriptions,
    this.isRequests = false,
    this.onRestore,
    this.onDelete,
  });

  @override
  State<OptimizedSubscriptionList> createState() =>
      _OptimizedSubscriptionListState();
}

class _OptimizedSubscriptionListState extends State<OptimizedSubscriptionList> {
  // Cache for subscription IDs to detect changes

  @override
  void initState() {
    super.initState();
    _updateSubscriptionIds();
  }

  @override
  void didUpdateWidget(OptimizedSubscriptionList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only rebuild the list if the subscriptions have changed
    if (!listEquals(_getSubscriptionIds(oldWidget.subscriptions),
            _getSubscriptionIds(widget.subscriptions)) ||
        oldWidget.isRequests != widget.isRequests) {
      _updateSubscriptionIds();
    }
  }

  void _updateSubscriptionIds() {}

  List<String> _getSubscriptionIds(List<SubscriptionsRecord> subs) {
    return subs.map((s) => s.reference.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.subscriptions.length,
        (index) {
          final subscription = widget.subscriptions[index];
          return Padding(
            padding: EdgeInsets.only(
                bottom: index < widget.subscriptions.length - 1 
                    ? ResponsiveUtils.height(context, 16.0) 
                    : 0),
            child: RepaintBoundary(
              child: TraineeCard(
                key: ValueKey(subscription.reference.id),
                subscription: subscription,
                isRequest: widget.isRequests,
                onRestore: widget.onRestore != null
                    ? () => widget.onRestore!(subscription)
                    : null,
                onDelete: widget.onDelete != null
                    ? () => widget.onDelete!(subscription)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
