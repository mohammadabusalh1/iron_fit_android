import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gym_model.dart';

class GymService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'gyms';

  // Create a new gym
  Future<String> createGym(GymModel gym) async {
    try {
      final docRef = await _firestore.collection(_collection).add(gym.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create gym: $e');
    }
  }

  // Get a gym by ID
  Future<GymModel?> getGym(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return GymModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get gym: $e');
    }
  }

  // Update a gym
  Future<void> updateGym(String id, GymModel gym) async {
    try {
      await _firestore.collection(_collection).doc(id).update(gym.toMap());
    } catch (e) {
      throw Exception('Failed to update gym: $e');
    }
  }

  // Delete a gym
  Future<void> deleteGym(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete gym: $e');
    }
  }

  // Get all gyms
  Stream<List<GymModel>> getGyms() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => GymModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Search gyms by name
  Future<List<GymModel>> searchGymsByName(String name) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: name + '\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => GymModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to search gyms: $e');
    }
  }

  // Filter gyms by country and city
  Future<List<GymModel>> filterGyms({String? country, String? city}) async {
    try {
      Query query = _firestore.collection(_collection);

      if (country != null) {
        query = query.where('country', isEqualTo: country);
      }
      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) =>
              GymModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to filter gyms: $e');
    }
  }
}
