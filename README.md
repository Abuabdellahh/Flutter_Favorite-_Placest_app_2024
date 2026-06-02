# 📍 Favorite Places

A Flutter app to save your favorite places with a photo and GPS location — stored locally on device.

---

## ✨ Features

- 📸 Capture a photo from camera
- 📍 Pick location via GPS or interactive map
- 🗺️ View location on Google Maps
- 💾 Persistent storage with SQLite
- 🗑️ Swipe to delete a place

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/     # API keys, DB config, URL builders
│   └── theme/         # App theme
├── data/
│   ├── datasources/   # SQLite raw operations
│   └── repositories/  # Business logic + geocoding
├── models/            # Place & PlaceLocation
├── providers/         # Riverpod state (UserPlacesNotifier)
├── screens/           # Places, AddPlace, PlaceDetail, Map
└── widgets/           # ImageInput, LocationInput, PlacesList
```

---

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```

> Add your Google Maps API key in `core/constants/app_constants.dart` and your platform configs (`AndroidManifest.xml` / `AppDelegate.swift`).

---

## 🛠️ Tech Stack

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `sqflite` | Local database |
| `google_maps_flutter` | Map & location picker |
| `image_picker` | Camera input |
| `location` | GPS access |
| `http` | Geocoding API |
| `google_fonts` | Ubuntu Condensed font |

---

## 📋 Requirements

- Flutter `>=2.19.2`
- Google Maps API key (Maps SDK + Geocoding API enabled)
