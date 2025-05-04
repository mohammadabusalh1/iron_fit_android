import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/form_field_controller.dart';

class TraineeService {
  // Fetch trainee subscription data
  Future<SubscriptionsRecord?> getTraineeSubscription(
      DocumentReference subscriptionRef) async {
    try {
      return await SubscriptionsRecord.getDocument(subscriptionRef).first;
    } catch (e) {
      debugPrint('Error fetching trainee subscription: $e');
      return null;
    }
  }

  // Fetch trainee record
  Future<TraineeRecord?> getTraineeRecord(DocumentReference? traineeRef) async {
    if (traineeRef == null) return null;

    try {
      return await TraineeRecord.getDocument(traineeRef).first;
    } catch (e) {
      debugPrint('Error fetching trainee record: $e');
      return null;
    }
  }

  // Fetch user record for a trainee
  Future<UserRecord?> getUserRecord(DocumentReference? userRef) async {
    if (userRef == null) return null;

    try {
      return await UserRecord.getDocument(userRef).first;
    } catch (e) {
      debugPrint('Error fetching user record: $e');
      return null;
    }
  }

  // Copy email to clipboard
  void copyEmailToClipboard(BuildContext context, String email) {
    Clipboard.setData(ClipboardData(text: email));
    showSuccessDialog(
        FFLocalizations.of(context).getText('emailCopied'), context);
  }

  // Load plans for a trainee subscription
  Future<void> loadTraineePlans(
    DocumentReference subscriptionRef,
    Function(FormFieldController<String>?, FormFieldController<String>?)
        onPlansLoaded,
  ) async {
    try {
      // Get subscription data in a single fetch
      final traineeSubscription =
          await SubscriptionsRecord.getDocument(subscriptionRef).first;

      // Create controllers for form fields
      FormFieldController<String>? trainingPlanController;
      FormFieldController<String>? nutritionalPlanController;

      // Create a list of futures to fetch plans in parallel
      final futures = <Future>[];

      if (traineeSubscription.plan != null) {
        futures.add(
          PlansRecord.getDocument(traineeSubscription.plan!)
              .first
              .then((planDoc) {
            trainingPlanController =
                FormFieldController<String>(planDoc.plan.name);
          }),
        );
      }

      if (traineeSubscription.nutPlan != null) {
        futures.add(
          NutPlanRecord.getDocument(traineeSubscription.nutPlan!)
              .first
              .then((planDoc) {
            nutritionalPlanController =
                FormFieldController<String>(planDoc.nutPlan.name);
          }),
        );
      }

      // Wait for all futures to complete in parallel
      await Future.wait(futures);

      // Call the callback with the loaded controllers
      onPlansLoaded(trainingPlanController, nutritionalPlanController);
    } catch (e, s) {
      debugPrint('Error loading plans: $e');
      debugPrint('stackTrace: $s');
    }
  }

  // Renew subscription
  Future<void> updateSubscription(
      DocumentReference subscriptionRef, Map<String, dynamic> data) async {
    try {
      await subscriptionRef.update(data);
    } catch (e) {
      debugPrint('Error updating subscription: $e');
      rethrow;
    }
  }

  // Cancel subscription
  Future<void> deleteSubscription(SubscriptionsRecord subscription) async {
    try {
      await subscription.reference.update({'isDeleted': true});
    } catch (e) {
      debugPrint('Error canceling subscription: $e');
      rethrow;
    }
  }

  // Add debts to a trainee
  Future<void> addDebts(
      DocumentReference subscriptionRef, double amount, String title) async {
    try {
      final newDebt = {
        'id': _generateBillId(),
        'name': title,
        'date': DateTime.now(),
        'debt': amount,
        'type': '+',
      };

      await subscriptionRef.update({
        'debts': FieldValue.increment(amount),
        'debtList': FieldValue.arrayUnion([newDebt]),
      });
    } catch (e) {
      debugPrint('Error adding debts: $e');
      rethrow;
    }
  }

  // Remove debts from a trainee
  Future<void> removeDebts(
      DocumentReference subscriptionRef, double amount, String title) async {
    try {
      if (amount <= 0) {
        throw Exception('Debt amount must be greater than zero');
      }

      final newDebt = {
        'id': _generateBillId(),
        'name': title,
        'date': DateTime.now(),
        'debt': amount,
        'type': '-',
      };

      final newBill = {
        'id': _generateBillId(),
        'date': DateTime.now(),
        'paid': amount,
      };

      await subscriptionRef.update({
        'debts': FieldValue.increment(-amount),
        'amountPaid': FieldValue.increment(amount),
        'bills': FieldValue.arrayUnion([newBill]),
        'debtList': FieldValue.arrayUnion([newDebt]),
      });
    } catch (e) {
      debugPrint('Error removing debts: $e');
      rethrow;
    }
  }

  // Save plans to a trainee subscription
  Future<void> savePlans(
    BuildContext context,
    SubscriptionsRecord subscription,
    PlansRecord? trainingPlan,
    NutPlanRecord? nutritionalPlan,
    DocumentReference? currentUserRef,
  ) async {
    try {
      // Prepare update data for subscription record
      final updateData = {
        if (trainingPlan?.reference != null) 'plan': trainingPlan?.reference,
        if (nutritionalPlan?.reference != null)
          'nutPlan': nutritionalPlan?.reference,
      };

      // Only proceed if there are changes to save
      if (updateData.isNotEmpty) {
        await subscription.reference.update(updateData);

        // Handle alerts and related updates
        if (subscription.trainee != null) {
          await Future.wait([
            if (trainingPlan?.reference != null)
              _createAndSaveAlert(
                context,
                subscription.trainee!,
                trainingPlan!.plan.name,
                'planAddedForYou',
                currentUserRef,
              ),
            if (nutritionalPlan?.reference != null)
              _createAndSaveAlert(
                context,
                subscription.trainee!,
                nutritionalPlan!.nutPlan.name,
                'planAddedForYou',
                currentUserRef,
              ),
            if (trainingPlan?.reference != null)
              _clearTraineeDayProgress(subscription.trainee!),
          ]);
        }
      }
    } catch (e) {
      debugPrint('Error saving plans: $e');
      rethrow;
    }
  }

  // Save notes for a trainee
  Future<void> saveNotes(
      DocumentReference subscriptionRef, String notes) async {
    try {
      await subscriptionRef.update({'notes': notes});
    } catch (e) {
      debugPrint('Error saving notes: $e');
      rethrow;
    }
  }

  // Helper to create and save alert
  Future<void> _createAndSaveAlert(
    BuildContext context,
    DocumentReference traineeRef,
    String name,
    String descKey,
    DocumentReference? coachRef,
  ) async {
    if (coachRef == null) return;

    final alertData = {
      ...createAlertRecordData(
        name: name,
        desc: FFLocalizations.of(context).getText(descKey),
        coach: coachRef,
        date: getCurrentTimestamp,
        trainees: [
          {'ref': traineeRef, 'isRead': false}
        ],
      ),
    };

    await AlertRecord.collection.doc().set(alertData);
  }

  // Helper to clear trainee's day progress
  Future<void> _clearTraineeDayProgress(DocumentReference traineeRef) async {
    try {
      final traineeRecord = await TraineeRecord.getDocument(traineeRef).first;
      await traineeRecord.reference.update({
        'dayProgress': FieldValue.delete(),
      });
    } catch (e) {
      debugPrint('Error clearing trainee day progress: $e');
    }
  }

  // Helper to generate a unique bill ID
  String _generateBillId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().toString()}';
  }

  // Update trainee name
  Future<void> updateTraineeName(
    BuildContext context,
    DocumentReference subscriptionRef,
    String newName,
  ) async {
    try {
      await subscriptionRef.update({'name': newName});
      if (context.mounted) {
        showSuccessDialog(
            FFLocalizations.of(context).getText('nameUpdated'), context);
      }
    } catch (e) {
      debugPrint('Error updating trainee name: $e');
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
      rethrow;
    }
  }

  // Update trainee email
  Future<void> updateTraineeEmail(
    BuildContext context,
    DocumentReference subscriptionRef,
    String newEmail,
  ) async {
    try {
      // check if there is trainee with this email
      final trainee = await UserRecord.collection
          .where('email', isEqualTo: newEmail)
          .where('role', isEqualTo: 'trainee')
          .get();

      if (trainee.docs.isNotEmpty) {
        await subscriptionRef.update({
          'email': newEmail,
          'isAnonymous': false,
          'trainee': trainee.docs.first.reference
        });
        if (context.mounted) {
          showSuccessDialog(
              FFLocalizations.of(context).getText('emailUpdated'), context);
        }
      } else {
        await subscriptionRef.update({'email': newEmail});
        if (context.mounted) {
          showSuccessDialog(
              FFLocalizations.of(context).getText('emailUpdated'), context);
        }
      }
    } catch (e) {
      debugPrint('Error updating trainee email: $e');
      if (context.mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('errorOccurred'), context);
      }
      rethrow;
    }
  }
}
