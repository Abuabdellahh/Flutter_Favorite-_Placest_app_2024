class AppConstants {
  AppConstants._();

  static const googleApiKey = 'AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  static const dbName = 'places.db';
  static const dbTable = 'user_places';
  static const dbVersion = 1;

  static String staticMapUrl(double lat, double lng) =>
      'https://maps.googleapis.com/maps/api/staticmap'
      '?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap'
      '&markers=color:red%7Clabel:A%7C$lat,$lng&key=$googleApiKey';

  static String geocodeUrl(double lat, double lng) =>
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$lat,$lng&key=$googleApiKey';
}

