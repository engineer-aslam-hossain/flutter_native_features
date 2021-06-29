import 'package:flutter/material.dart';
import 'package:native_feature/providers/great_places.dart';
import 'package:native_feature/screens/add_place_screen.dart';
import 'package:native_feature/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  builder: (ctx, grtPlace, child) => grtPlace.items.length <= 0
                      ? child!
                      : ListView.builder(
                          itemCount: grtPlace.items.length,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                grtPlace.items[i].image,
                              ),
                            ),
                            title: Text(grtPlace.items[i].title),
                            subtitle: Text(grtPlace.items[i].location.address!),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: grtPlace.items[i].id);
                            },
                          ),
                        ),
                  child: Center(
                    child: Text('Got no places yet, start adding some!  '),
                  ),
                ),
        )
        // Center(
        //   child: CircularProgressIndicator(),
        // ),
        );
  }
}
