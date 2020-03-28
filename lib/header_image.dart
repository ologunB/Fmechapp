import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HeaderImage extends StatefulWidget {
  String url;
  HeaderImage(this.url);
  @override
  _HeaderImageState createState() => _HeaderImageState();
}

class _HeaderImageState extends State<HeaderImage> {
  File _mainPicture;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _mainPicture = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: InkWell(
        onTap: () {
          getImage();
        },
        /*child: _mainPicture == null
                                  ? Image(
                                      image: AssetImage(
                                          "assets/images/add_camera.png"),
                                      height: 90,
                                      fit: BoxFit.contain)
                                  : Image.file(_mainPicture,
                                      height: 90, fit: BoxFit.contain), */
        child: CachedNetworkImage(
          imageUrl: widget.url,
          height: 40,
          width: 40,
          placeholder: (context, url) => Image(
              image: AssetImage("assets/images/add_camera.png"),
              height: 90,
              fit: BoxFit.contain),
          errorWidget: (context, url, error) => Image(
              image: AssetImage("assets/images/add_camera.png"),
              height: 90,
              fit: BoxFit.contain),
        ),
      ),
    );
  }
}
