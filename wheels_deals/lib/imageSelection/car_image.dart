import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_deals/imageSelection/round_images.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class carImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;
  carImage({
    this.onFileChanged,
  });
  @override
  State<carImage> createState() => _carImageState();
}

class _carImageState extends State<carImage> {
  final ImagePicker _picker = ImagePicker();
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl == null)
          Icon(FontAwesomeIcons.image, size: 80, color: Colors.black)
        else if (imageUrl != null)
          InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _selectedPhoto(),
              child: Image.network(
                imageUrl,
                width: 200,
                height: 200,
              )),
        InkWell(
          onTap: () => _selectedPhoto(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              imageUrl != null ? 'Change photo' : 'Upload Picture',
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
                    leading: Icon(FontAwesomeIcons.image),
                    title: Text('Pick Image'),
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
    final pickedfile =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedfile == null) {
      return;
    }
    var file = await ImageCropper().cropImage(
        sourcePath: pickedfile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));

    if (file == null) {
      return;
    }
    //file = await compressImage(file.path, 35);

    await _uploadFile(file.path);
  }

  Future _uploadFile(String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child('adImages')
        .child('${DateTime.now().toIso8601String() + p.basename(path)}');
    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      imageUrl = fileUrl;
    });
    widget.onFileChanged(fileUrl);
  }
}
