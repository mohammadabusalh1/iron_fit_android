import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gym_model.dart';
import '../services/gym_service.dart';

final gymServiceProvider = Provider<GymService>((ref) => GymService());

final gymsProvider = StreamProvider<List<GymModel>>((ref) {
  final gymService = ref.watch(gymServiceProvider);
  return gymService.getGyms();
});

final selectedGymProvider = StateProvider<GymModel?>((ref) => null);

final filteredGymsProvider =
    FutureProvider.family<List<GymModel>, Map<String, String?>>(
        (ref, filters) async {
  final gymService = ref.watch(gymServiceProvider);
  return gymService.filterGyms(
    country: filters['country'],
    city: filters['city'],
  );
});

final gymSearchProvider =
    FutureProvider.family<List<GymModel>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }
  final gymService = ref.watch(gymServiceProvider);
  return gymService.searchGymsByName(query);
});
