import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_deals/imageSelection/round_images.dart';
import 'dart:io';

class UserImage extends StatefulWidget {
  final Function(File image) onFileChanged;
  UserImage({
    this.onFileChanged,
  });

  @override
  State<UserImage> createState() => _UerImageState();
}

class _UerImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();
  String imageUrl;
  File image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image == null)
          Icon(
            Icons.image,
            size: 100,
            color: Colors.teal,
          )
        else if (image != null)
          InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _selectedPhoto(),
              child: Image.file(
                image,
                width: 100,
                height: 150,
              )),
        InkWell(
          onTap: () => _selectedPhoto(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              image != null ? 'Change' : 'Select',
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  Future _selectedPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt_rounded),
                    title: Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.filter),
                    title: Text('Pick a file'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              onClosing: () {},
            ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedfile = await _picker.pickImage(source: source);
    if (pickedfile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
        sourcePath: pickedfile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (file == null) {
      return;
    }

    setState(() {
      image = file;
    });
    widget.onFileChanged(file);
  }
}
