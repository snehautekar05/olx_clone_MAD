
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  bool _uploading = false;

  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('Image picked: ${_image!.path}');
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _image = File(''); // Provide a default value for _image
  }

  Future<void> uploadFile() async {
    if (_image != null) {
      File file = File(_image!.path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      try {
        print('Uploading image...');
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        String downloadUrl =
        await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadUrl != null) {
          var _provider =
          Provider.of<CategoryProvider>(context, listen: false);
          setState(() {
            _image = null;
            _provider.getImages([downloadUrl]);
            _uploading = false; // Update uploading state
            print('Image uploaded. Download URL: $downloadUrl');
          });
        }
      } on FirebaseException catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Canceled"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context, listen: false);

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Upload images',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                        ),
                      ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image?.path.isNotEmpty ?? false
                            ? Image.file(_image!)
                            : Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (_provider.urlList.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _provider.urlList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _provider.urlList[index],
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 20),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.green),
                          onPressed: () {
                            if (_image != null) {
                              setState(() {
                                _uploading = true;
                                uploadFile(); // Start upload
                              });
                            }

                          },
                          child: Text('Save', textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.red),
                          onPressed: () {
                            // Implement cancel functionality
                          },
                          child: Text('Cancel', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: getImage,
                        style: NeumorphicStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          _provider.urlList.isNotEmpty
                              ? 'Upload more images'
                              : 'Upload Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_uploading)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
