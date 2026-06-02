import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/place_detail.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, i) => Dismissible(
        key: ValueKey(places[i].id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) =>
            ref.read(userPlacesProvider.notifier).deletePlace(places[i].id),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[i].image),
          ),
          title: Text(
            places[i].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            places[i].location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(place: places[i]),
          )),
        ),
      ),
    );
  }
}
