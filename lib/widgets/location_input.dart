import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/core/constants/app_constants.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(AppConstants.geocodeUrl(lat, lng));
    final response = await http.get(url);
    final address =
        json.decode(response.body)['results'][0]['formatted_address'] as String;

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();

    if (!await location.serviceEnabled() &&
        !await location.requestService()) return;

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    setState(() => _isGettingLocation = true);

    final data = await location.getLocation();
    if (data.latitude == null || data.longitude == null) return;
    await _savePlace(data.latitude!, data.longitude!);
  }

  Future<void> _selectOnMap() async {
    final picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
    if (picked == null) return;
    await _savePlace(picked.latitude, picked.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget preview = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: cs.onBackground),
    );

    if (_isGettingLocation) {
      preview = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      preview = Image.network(
        AppConstants.staticMapUrl(
            _pickedLocation!.latitude, _pickedLocation!.longitude),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: cs.primary.withOpacity(0.2)),
          ),
          child: preview,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
