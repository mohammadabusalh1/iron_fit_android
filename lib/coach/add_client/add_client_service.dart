import 'package:flutter/material.dart';
import 'package:iron_fit/utils/logger.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddClientService {
  final BuildContext context;

  AddClientService(this.context);

  Future<UserRecord?> findUser(String email) async {
    try {
      if (email.isEmpty) {
        return null;
      }
      return await queryUserRecordOnce(
        queryBuilder: (userRecord) => userRecord.where(
          'email',
          isEqualTo: email.trim(),
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
    } catch (e) {
      Logger.warning('Error finding user: $e');
      return null;
    }
  }

  Future<TraineeRecord?> findTrainee(UserRecord user) async {
    try {
      return await queryTraineeRecordOnce(
        queryBuilder: (traineeRecord) => traineeRecord.where(
          'user',
          isEqualTo: user.reference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
    } catch (e) {
      Logger.warning('Error finding trainee: $e');
      return null;
    }
  }

  Future<UserSubscriptionCheck> checkExistingSubscription(
      CoachRecord coachRecord, TraineeRecord? trainee, String email) async {
    // Check for existing anonymous subscription
    final subscriptionByEmail = await querySubscriptionsRecord(
      queryBuilder: (q) => q
          .where('email', isEqualTo: email)
          .where('coach', isEqualTo: coachRecord.reference),
      singleRecord: true,
    ).first.then((s) => s.firstOrNull);

    if (subscriptionByEmail != null) {
      if (subscriptionByEmail.isDeleted == true) {
        return UserSubscriptionCheck(true, true, subscriptionByEmail);
      }
      return UserSubscriptionCheck(true, false, subscriptionByEmail);
    } else {
      if (trainee == null) {
        return UserSubscriptionCheck(false, false, null);
      }

      final existingSubscription = await querySubscriptionsRecordOnce(
        queryBuilder: (q) => q
            .where('coach', isEqualTo: coachRecord.reference)
            .where('trainee', isEqualTo: trainee.reference),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      if (existingSubscription != null) {
        if (existingSubscription.isDeleted == true) {
          return UserSubscriptionCheck(true, true, existingSubscription);
        }
        return UserSubscriptionCheck(true, false, existingSubscription);
      }
      return UserSubscriptionCheck(false, false, null);
    }
  }

  Future<void> createAnonymousSubscription(
      CoachRecord coach,
      String email,
      String name,
      String goal,
      String level,
      String notes,
      String startDate,
      String endDate,
      double amountPaid,
      double debts,
      PlansRecord? plan,
      NutPlanRecord? nutPlan) async {
    try {
      // Create subscription data
      final subscriptionData = {
        'coach': coach.reference,
        'startDate': DateTime.parse(startDate),
        'endDate': DateTime.parse(endDate),
        'isActive': false,
        'isAnonymous': true,
        'isDeleted': false,
        'email': email,
        'name': name,
        'debts': debts,
        'amountPaid': amountPaid,
        'goal': goal,
        'level': level,
        'notes': notes,
        if (plan != null) 'plan': plan.reference,
        if (nutPlan != null) 'nutPlan': nutPlan.reference,
        'bills': [
          {
            'id': _generateBillId(),
            'date': DateTime.now(),
            'paid': amountPaid,
          }
        ],
        'debtList': [
          {
            'id': _generateBillId(),
            'name': FFLocalizations.of(context).getText('first_debt'),
            'date': DateTime.now(),
            'debt': debts,
            'type': '+',
          }
        ],
      };

      // Create the subscription document
      await SubscriptionsRecord.collection.doc().set(subscriptionData);
    } catch (e, s) {
      Logger.error('Error creating anonymous subscription: $e');
      Logger.error('Stack trace: $s');
      throw Exception(
          FFLocalizations.of(context).getText('error_creating_subscription'));
    }
  }

  Future<void> createSubscription(
      CoachRecord coach,
      TraineeRecord trainee,
      String email,
      String name,
      String goal,
      String level,
      String notes,
      String startDate,
      String endDate,
      double amountPaid,
      double debts,
      PlansRecord? plan,
      NutPlanRecord? nutPlan) async {
    try {
      // Create subscription data
      final subscriptionData = {
        'coach': coach.reference,
        'trainee': trainee.reference,
        'email': email,
        'startDate': DateTime.parse(startDate),
        'endDate': DateTime.parse(endDate),
        'isActive': false,
        'isAnonymous': false,
        'isDeleted': false,
        'debts': debts,
        'amountPaid': amountPaid,
        'goal': goal,
        'level': level,
        'name': name,
        'notes': notes,
        if (plan != null) 'plan': plan.reference,
        if (nutPlan != null) 'nutPlan': nutPlan.reference,
        'bills': [
          {
            'id': _generateBillId(),
            'date': DateTime.now(),
            'paid': amountPaid,
          }
        ],
        'debtList': [
          {
            'id': _generateBillId(),
            'name': FFLocalizations.of(context).getText('first_debt'),
            'date': DateTime.now(),
            'debt': debts,
            'type': '+',
          }
        ],
      };

      // Create subscription document
      await SubscriptionsRecord.collection.doc().set(subscriptionData);

      // Create alert for subscription request
      await _createSubscriptionAlert(coach, trainee);
    } catch (e, s) {
      Logger.error('Error creating subscription: $e');
      Logger.error('Stack trace: $s');
      throw Exception(
          FFLocalizations.of(context).getText('error_creating_subscription'));
    }
  }

  Future<void> updateSubscription(
      CoachRecord coach,
      TraineeRecord? trainee,
      SubscriptionsRecord subscription,
      String goal,
      String level,
      String name,
      String notes,
      String startDate,
      String endDate,
      double amountPaid,
      double debts,
      PlansRecord? plan,
      NutPlanRecord? nutPlan) async {
    try {
      // Create subscription data
      final Map<String, dynamic> subscriptionData = {
        'startDate': DateTime.parse(startDate),
        'endDate': DateTime.parse(endDate),
        'isDeleted': false,
        'goal': goal,
        'level': level,
        'name': name,
        'notes': notes,
        if (plan != null) 'plan': plan.reference,
        if (nutPlan != null) 'nutPlan': nutPlan.reference,
      };

      if (debts > 0) {
        subscriptionData['debts'] = FieldValue.increment(debts);
        subscriptionData['debtList'] = FieldValue.arrayUnion([
          {
            'id': _generateBillId(),
            'name': FFLocalizations.of(context).getText('first_debt'),
            'date': DateTime.now(),
            'debt': debts,
            'type': '+',
          }
        ]);
      }

      if (amountPaid > 0) {
        subscriptionData['amountPaid'] = FieldValue.increment(amountPaid);
        subscriptionData['bills'] = FieldValue.arrayUnion([
          {
            'id': _generateBillId(),
            'date': DateTime.now(),
            'paid': amountPaid,
          }
        ]);
      }

      // Update subscription document
      await subscription.reference.update(subscriptionData);

      if (trainee != null) await _createSubscriptionAlert(coach, trainee);
    } catch (e, s) {
      Logger.error('Error updating subscription: $e');
      Logger.error('Stack trace: $s');
      throw Exception(
          FFLocalizations.of(context).getText('error_creating_subscription'));
    }
  }

  Future<void> _createSubscriptionAlert(
      CoachRecord coach, TraineeRecord trainee) async {
    try {
      final alertData = createAlertRecordData(
        name: FFLocalizations.of(context).getText('SubscriptionRequest'),
        desc:
            '${FFLocalizations.of(context).getText('subscription_requests_from_coach')} ${currentUserDocument!.displayName} ${FFLocalizations.of(context).getText('in')} ${coach.gymName}',
        coach: coach.reference,
        date: DateTime.now(),
        trainees: [
          {'ref': trainee.reference, 'isRead': false}
        ],
      );

      await AlertRecord.collection.doc().set(alertData);
    } catch (e) {
      Logger.warning('Error creating alert: $e');
    }
  }

  // Helper method to generate unique bill ID
  String _generateBillId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().toString()}';
  }
}

class UserSubscriptionCheck {
  final bool exist;
  final bool isDeleted;
  final SubscriptionsRecord? subscription;

  UserSubscriptionCheck(this.exist, this.isDeleted, this.subscription);
}
