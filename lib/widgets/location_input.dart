import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:native_feature/helpers/location_helper.dart';
import 'package:native_feature/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlaces;

  LocationInput(this.onSelectPlaces);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? prevImageUrl;

  void _showPreview(double? lat, double? long) async {
    try {
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: lat, longitude: long);

      setState(() {
        prevImageUrl = staticMapImageUrl;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);

      widget.onSelectPlaces(locData.latitude, locData.longitude);
    } catch (err) {}
  }

  Future<void> _selectOnMap() async {
    try {
      final selectedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => MapScreen(
            isSelecting: true,
          ),
        ),
      );

      if (selectedLocation == null) {
        return;
      }

      _showPreview(selectedLocation.latitude, selectedLocation.longitude);

      widget.onSelectPlaces(
          selectedLocation.latitude, selectedLocation.longitude);
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          child: prevImageUrl != null
              ? Image.network(
                  prevImageUrl.toString(),
                  fit: BoxFit.cover,
                  width: 300,
                )
              : Text(
                  'NO location choosen',
                  textAlign: TextAlign.center,
                ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: _getUserCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text(
                'Current Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text(
                'Location on Map',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
