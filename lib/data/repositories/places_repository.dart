import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_paths;

import 'package:favorite_places/core/constants/app_constants.dart';
import 'package:favorite_places/data/datasources/places_local_datasource.dart';
import 'package:favorite_places/models/place.dart';

class PlacesRepository {
  Future<List<Place>> loadPlaces() async {
    final rows = await PlacesLocalDatasource.fetchAll();
    return rows
        .map((r) => Place(
              id: r['id'] as String,
              title: r['title'] as String,
              image: File(r['image'] as String),
              location: PlaceLocation(
                latitude: r['lat'] as double,
                longitude: r['lng'] as double,
                address: r['address'] as String,
              ),
            ))
        .toList();
  }

  Future<Place> addPlace(
      String title, File image, PlaceLocation location) async {
    final appDir = await sys_paths.getApplicationDocumentsDirectory();
    final copied = await image.copy(
        '${appDir.path}/${path.basename(image.path)}');

    final place = Place(title: title, image: copied, location: location);

    await PlacesLocalDatasource.insert({
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });

    return place;
  }

  Future<void> deletePlace(String id) =>
      PlacesLocalDatasource.delete(id);

  Future<String> getAddress(double lat, double lng) async {
    final response =
        await http.get(Uri.parse(AppConstants.geocodeUrl(lat, lng)));
    final data = json.decode(response.body);
    return data['results'][0]['formatted_address'] as String;
  }
}
