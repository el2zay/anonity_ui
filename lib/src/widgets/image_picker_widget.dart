// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

final _images = [];

// Fonction pour récupérer le path des images
List<String?>? getImagesPath() {
  if (_images.isEmpty) {
    return [];
  }
  
  List<String?> imagesPath = List.filled(3, null, growable: false);
  var i = 0;
  for (var image in _images.take(2)) {
    imagesPath[i++] = image.path;
  }
  return imagesPath;
}


class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future getImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      int maxSize = 10 * 1024 * 1024; // 10MB en octets
      if (image.lengthSync() <= maxSize) {
        setState(() {
          if (_images.length < 3) {
            _images.add(image);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tu ne peux pas ajouter plus de 3 images."),
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("L'image est trop volumineuse."),
          ),
        );
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageWidgets = _images.map((image) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.file(
              image,
              width: 0.3 * MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => removeImage(_images.indexOf(image)),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      children: [
        TextButton(
            onPressed: () => getImageFromGallery(context),
            child: const Text('Sélectionner une image')),
        _images.isEmpty
            ? const SizedBox()
            : // Row scrollable droite à gauche
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: imageWidgets,
                ),
              ),
      ],
    );
  }
}
