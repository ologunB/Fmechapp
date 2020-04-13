import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage extends StatefulWidget {
  final String url, defaultUrl;
  File image;
  SelectImage({this.url, this.defaultUrl, this.image});
  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  Future getImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      widget.image = img;
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
        child: widget.image == null
            ? CachedNetworkImage(
                imageUrl: widget.url,
                height: 90,
                width: 90,
                placeholder: (context, url) => Image(
                    image: AssetImage(widget.defaultUrl),
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain),
                errorWidget: (context, url, error) => Image(
                    image: AssetImage(widget.defaultUrl),
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain),
              )
            : Image.file(widget.image,
                height: 90, width: 90, fit: BoxFit.contain),
      ),
    );
  }
}
