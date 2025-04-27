import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class SubscriptionService {
  // Get active subscriptions
  static Stream<List<SubscriptionsRecord>> getActiveSubscriptions(
      DocumentReference coach) {
    return SubscriptionsRecord.collection
        .where('coach', isEqualTo: coach)
        .where('endDate', isGreaterThan: Timestamp.now())
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubscriptionsRecord.fromSnapshot(doc))
            .where((sub) =>
                sub.isActive == true ||
                (sub.isActive == false && sub.isAnonymous == true))
            .toList());
  }

  // Get inactive subscriptions
  static Stream<List<SubscriptionsRecord>> getInactiveSubscriptions(
      DocumentReference coach) {
    return SubscriptionsRecord.collection
        .where('coach', isEqualTo: coach)
        .where('endDate', isLessThan: Timestamp.now())
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubscriptionsRecord.fromSnapshot(doc))
            .where((sub) =>
                sub.isActive == true ||
                (sub.isActive == false && sub.isAnonymous == true))
            .toList());
  }

  // Get requests
  static Stream<List<SubscriptionsRecord>> getRequests(
      DocumentReference coach) {
    return SubscriptionsRecord.collection
        .where('coach', isEqualTo: coach)
        .where('isActive', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .where('isAnonymous', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubscriptionsRecord.fromSnapshot(doc))
            .toList());
  }

  // Get deleted subscriptions
  static Stream<List<SubscriptionsRecord>> getDeletedSubscriptions(
      DocumentReference coach) {
    return SubscriptionsRecord.collection
        .where('coach', isEqualTo: coach)
        .where('isDeleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SubscriptionsRecord.fromSnapshot(doc))
            .toList());
  }

  // Create alert for a trainee
  static Future<void> createAlert({
    required BuildContext context,
    required DocumentReference traineeRef,
    required String name,
    required String desc,
    required DocumentReference? coach,
  }) async {
    if (coach == null) return;

    final alertData = createAlertRecordData(
      name: name,
      desc: desc,
      coach: coach,
      date: getCurrentTimestamp,
      trainees: [
        {'ref': traineeRef, 'isRead': false}
      ],
    );

    await AlertRecord.collection.doc().set(alertData);
  }

  // Filter subscriptions by search query
  static List<SubscriptionsRecord> filterSubscriptionsBySearch(
      List<SubscriptionsRecord> subscriptions, String query) {
    if (query.isEmpty) return subscriptions;

    final lowerQuery = query.toLowerCase();
    return subscriptions
        .where((sub) => sub.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Restore a deleted subscription
  static Future<void> restoreSubscription(
      SubscriptionsRecord subscription) async {
    await subscription.reference.update({'isDeleted': false});
  }

  // Permanently delete a subscription
  static Future<void> permanentlyDeleteSubscription(
      SubscriptionsRecord subscription) async {
    await subscription.reference.delete();
  }

  // Mark subscription as deleted
  static Future<void> markAsDeleted(SubscriptionsRecord subscription) async {
    await subscription.reference.update({'isDeleted': true});
  }
}
