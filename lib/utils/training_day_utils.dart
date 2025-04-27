import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/backend/schema/exercises_record.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_fit/utils/logger.dart';

class TrainingDayUtils {
  /// Returns a list of bodyParts based on the localized value
  static List<String> getBodyPartsForValue(BuildContext context, String value) {
    // Convert the value to lowercase for case-insensitive comparison
    String lowerValue = value.toLowerCase();

    // Check against localized values
    if (lowerValue ==
        FFLocalizations.of(context).getText('legs').toLowerCase()) {
      return [
        'legs',
        'upper legs',
        'lower legs',
        'Calves - Gastrocnemius',
        'Calves - Soleus',
        'Legs - Hamstrings',
        'Legs - Quadriceps'
      ];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('LowerArms').toLowerCase()) {
      // Keep this for backward compatibility with existing data
      return ['lower arms'];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('chest').toLowerCase()) {
      return ['chest', 'Chest - Pectoralis'];
    } else if (lowerValue ==
            FFLocalizations.of(context).getText('core').toLowerCase() ||
        lowerValue ==
            FFLocalizations.of(context).getText('waist').toLowerCase()) {
      return [
        'waist',
        'Abdominals - Lower',
        'Abdominals - Obliques',
        'Abdominals - Total',
        'Abdominals - Upper'
      ];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('back').toLowerCase()) {
      return [
        'back',
        'Back - Latissimus Dorsi',
        'Back - Lat.Dorsi/Rhomboids',
        'Lower Back - Erector Spinae'
      ];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('neck').toLowerCase()) {
      return ['neck'];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('traps').toLowerCase()) {
      return ['traps'];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('shoulders').toLowerCase()) {
      return [
        'shoulders',
        'Shoulders',
        'Shoulders - Delts/Traps',
        'Shoulders - Rotator Cuff',
        'Shoulders - Rear'
      ];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('cardio').toLowerCase()) {
      return ['cardio'];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('biceps').toLowerCase()) {
      return ['Biceps'];
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('triceps').toLowerCase()) {
      return ['Triceps'];
    } else {
      return [];
    }
  }

  /// Returns a list of equipment types based on the localized value
  static String getEquipmentForValue(BuildContext context, String value) {
    // Convert the value to lowercase for case-insensitive comparison
    String lowerValue = value.toLowerCase();

    // Check against localized values
    if (lowerValue ==
        FFLocalizations.of(context).getText('barbell').toLowerCase()) {
      return 'barbell';
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('dumbbell').toLowerCase()) {
      return 'dumbbells';
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('machine').toLowerCase()) {
      return 'machine';
    } else if (lowerValue ==
        FFLocalizations.of(context).getText('cable').toLowerCase()) {
      return 'cable';
    } else {
      return 'other';
    }
  }

  /// Fetches exercises with pagination and filtering
  static Future<List<ExercisesRecord>> fetchExercises({
    required BuildContext context,
    required String selectedBodyPart,
    required String selectedEquipment,
    required String searchQuery,
    required int page,
    required int pageSize,
    List<ExercisesRecord>? existingExercises,
  }) async {
    try {
      // Clean and normalize search query once
      final String normalizedSearchQuery = searchQuery.trim().toLowerCase();
      final List<String> searchWords = normalizedSearchQuery.isEmpty
          ? []
          : normalizedSearchQuery
              .split(' ')
              .where((w) => w.isNotEmpty)
              .toList();

      // Start building the query
      Query query = ExercisesRecord.collection;

      // Apply body part filter
      if (_isNotAllFilter(context, selectedBodyPart)) {
        final String normalizedBodyPart = selectedBodyPart.toLowerCase();
        final List<String> bodyPartValues =
            getBodyPartsForValue(context, normalizedBodyPart);

        if (bodyPartValues.isNotEmpty) {
          query = query.where('bodyPart', whereIn: bodyPartValues);
        } else {
          query = query.where('bodyPart', isEqualTo: normalizedBodyPart);
        }
      }

      // Apply equipment filter
      if (_isOtherEquipment(context, selectedEquipment)) {
        // "Other" equipment filter
        query = query.where('equipment', isEqualTo: 'other');
      } else if (_isNotAllFilter(context, selectedEquipment)) {
        final String normalizedEquipment = selectedEquipment.toLowerCase();
        final dynamic equipmentValues =
            getEquipmentForValue(context, normalizedEquipment);

        if (equipmentValues is List && equipmentValues.isNotEmpty) {
          query = query.where('equipment', whereIn: equipmentValues);
        } else {
          query = query.where('equipment',
              isEqualTo: equipmentValues is String
                  ? equipmentValues
                  : normalizedEquipment);
        }
      }

      // For empty searches or basic filters, we use server-side ordering and pagination
      if (searchWords.isEmpty) {
        // Add server-side order and limit
        query = query.orderBy('name').limit(pageSize);

        // Implement pagination with startAfter when necessary
        if (_shouldApplyPagination(page, existingExercises)) {
          final lastDoc = await ExercisesRecord.collection
              .doc(existingExercises!.last.reference.id)
              .get();
          query = query.startAfterDocument(lastDoc);
        }

        final snapshot = await query.get();
        return snapshot.docs
            .map((doc) => ExercisesRecord.fromSnapshot(doc))
            .toList();
      }
      // For searches with keywords, use more advanced relevance calculation
      else {
        // For keyword search, we need a larger result set to perform client-side ranking
        // Start with a reasonable limit (3-5x the requested page size)

        // We still need basic ordering for consistency
        query = query.orderBy('name');

        // If paginating, we need the cursor
        if (_shouldApplyPagination(page, existingExercises)) {
          final lastDoc = await ExercisesRecord.collection
              .doc(existingExercises!.last.reference.id)
              .get();
          query = query.startAfterDocument(lastDoc);
        }

        // Get a larger result set for ranking
        final snapshot = await query.get();
        List<ExercisesRecord> results = snapshot.docs
            .map((doc) => ExercisesRecord.fromSnapshot(doc))
            .toList();

        // Score and rank the results based on relevance
        final scoredResults = results.map((exercise) {
          final name = exercise.name.toLowerCase();
          final bodyPart = exercise.bodyPart.toLowerCase();
          final equipment = exercise.equipment.toLowerCase();

          int score = 0;
          bool allWordsMatch = true;

          for (final word in searchWords) {
            bool wordMatches = false;

            // Name matches are most important (exact name match is best)
            if (name == word) {
              score += 100;
              wordMatches = true;
            } else if (name.startsWith(word)) {
              score += 50;
              wordMatches = true;
            } else if (name.contains(word)) {
              score += 25;
              wordMatches = true;
            }

            // Body part matches
            if (bodyPart == word) {
              score += 20;
              wordMatches = true;
            } else if (bodyPart.contains(word)) {
              score += 10;
              wordMatches = true;
            }

            // Equipment matches
            if (equipment == word) {
              score += 15;
              wordMatches = true;
            } else if (equipment.contains(word)) {
              score += 5;
              wordMatches = true;
            }

            // If any word doesn't match at all, exclude from results
            if (!wordMatches) {
              allWordsMatch = false;
            }
          }

          // Apply additional boost for exercises that match all search words
          if (allWordsMatch && searchWords.length > 1) {
            score += 30;
          }

          return (exercise, score, allWordsMatch);
        }).toList();

        // Filter to only results that match all words or have a minimum score
        final filteredResults = scoredResults
            .where((item) =>
                item.$3 ||
                item.$2 >= 5) // Must match all words or have significant score
            .toList();

        // Sort by score (descending)
        filteredResults.sort((a, b) => b.$2.compareTo(a.$2));

        // Take only the requested page size
        return filteredResults.take(pageSize).map((item) => item.$1).toList();
      }
    } catch (e) {
      Logger.error('Error fetching exercises', e, StackTrace.current);
      return [];
    }
  }

// Helper function to determine if a filter is not "All"
  static bool _isNotAllFilter(BuildContext context, String filter) {
    final String normalizedFilter = filter.toLowerCase();
    return normalizedFilter != 'all' &&
        normalizedFilter != 'الكل' &&
        normalizedFilter !=
            FFLocalizations.of(context).getText('all').toLowerCase();
  }

// Helper function to determine if equipment filter is "Other"
  static bool _isOtherEquipment(BuildContext context, String equipment) {
    final String normalizedEquipment = equipment.toLowerCase();
    return normalizedEquipment == 'other' ||
        normalizedEquipment == 'غير ذلك' ||
        normalizedEquipment ==
            FFLocalizations.of(context).getText('other').toLowerCase();
  }

// Helper function to check if pagination should be applied
  static bool _shouldApplyPagination(
      int page, List<ExercisesRecord>? existingExercises) {
    return page > 0 &&
        existingExercises != null &&
        existingExercises.isNotEmpty;
  }

  /// Prefetches common exercise data to improve user experience
  static Future<Map<String, List<ExercisesRecord>>> prefetchCommonData(
    BuildContext context,
  ) async {
    final exerciseCache = <String, List<ExercisesRecord>>{};

    try {
      // Prefetch 'all' category first page
      final allExercises = await fetchExercises(
        context: context,
        selectedBodyPart: FFLocalizations.of(context).getText('all'),
        selectedEquipment: FFLocalizations.of(context).getText('all'),
        searchQuery: '',
        page: 0,
        pageSize: 20,
        existingExercises: null,
      );

      exerciseCache['all_all_'] = allExercises;

      // Prefetch popular body parts
      final bodyParts = ['chest', 'back', 'legs'];
      for (final bodyPart in bodyParts) {
        final exercises = await fetchExercises(
          context: context,
          selectedBodyPart: bodyPart,
          selectedEquipment: FFLocalizations.of(context).getText('all'),
          searchQuery: '',
          page: 0,
          pageSize: 20,
          existingExercises: null,
        );

        exerciseCache['${bodyPart}_all_'] = exercises;
      }

      return exerciseCache;
    } catch (e) {
      print('Error prefetching exercise data: $e');
      return exerciseCache;
    }
  }
}
