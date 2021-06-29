import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  //
  PickedFile? _imageFile;
  File? file;
  final ImagePicker _picker = ImagePicker();

  dynamic _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 600,
      );

      if (pickedFile == null) {
        return;
      }

      setState(() {
        _imageFile = pickedFile;
      });

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      File file = File(pickedFile.path);
      final savedImage = await file.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _imageFile == null
              ? Text('No image selected.')
              : Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.cover,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera, context: context);
            },
            label: Text(
              'Take picture',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            icon: Icon(Icons.camera),
          ),
        )
      ],
    );
  }
}
