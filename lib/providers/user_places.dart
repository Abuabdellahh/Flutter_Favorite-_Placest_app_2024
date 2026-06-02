import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/data/repositories/places_repository.dart';
import 'package:favorite_places/models/place.dart';

final _repo = PlacesRepository();

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    state = await _repo.loadPlaces();
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    final place = await _repo.addPlace(title, image, location);
    state = [place, ...state];
  }

  Future<void> deletePlace(String id) async {
    await _repo.deletePlace(id);
    state = state.where((p) => p.id != id).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (_) => UserPlacesNotifier(),
);
