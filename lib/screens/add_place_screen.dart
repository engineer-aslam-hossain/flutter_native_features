import 'dart:io';
import 'package:flutter/material.dart';
import 'package:native_feature/constants.dart';
import 'package:native_feature/models/place.dart';
import 'package:native_feature/providers/great_places.dart';
import 'package:native_feature/widgets/image_input.dart';
import 'package:native_feature/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add_place_screen';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectImage(File? pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlaces(double lat, double long) {
    //..........
    _pickedLocation = PlaceLocation(lat: lat, long: long);
    print(lat);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }

    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Place '),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Title',
                        labelText: 'Place Name',
                      ),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        hintText: '92.333',
                        labelText: 'Latitude',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Longitude',
                        hintText: '103.32',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    LocationInput(_selectPlaces),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _savePlace,
            label: Text(
              'Add Place',
              style: TextStyle(color: Colors.black87),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.black87,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
