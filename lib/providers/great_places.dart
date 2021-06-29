import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:native_feature/helpers/db_helpers.dart';
import 'package:native_feature/helpers/location_helper.dart';
import 'package:native_feature/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addPlace(String title, File image, PlaceLocation pickedLocation) async {
    final getAddr = await LocationHelper.getPlacesAddress(
        pickedLocation.lat, pickedLocation.long);
    final updatedAddress = PlaceLocation(
        lat: pickedLocation.lat, long: pickedLocation.long, address: getAddr);

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedAddress,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();

    DBHelpers.insertDb('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.long,
      'loc_lng': newPlace.location.long,
      'address': newPlace.location.address!,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelpers.getData('user_places');

    // dataList.map((e) => print(e['title'])).toList();
    dataList.forEach((element) {
      final newPlace = Place(
        id: element['id'],
        title: element['title'],
        location: PlaceLocation(
          lat: element['loc_lat'],
          long: element['loc_lng'],
          address: element['address'],
        ),
        image: File(element['image']),
      );
      _items.add(newPlace);
    });
    notifyListeners();
  }
}
