import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mechapp/utils/type_constants.dart';

import 'libraries/custom_button.dart';
import 'libraries/toast.dart';
import 'log_in.dart';

class AddCarActivity extends StatefulWidget {
  @override
  _AddCarActivityState createState() => _AddCarActivityState();
}

final carsReference =
    FirebaseDatabase.instance.reference().child("Car Collection").child(mUID);

class _AddCarActivityState extends State<AddCarActivity>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  File _carImage;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _carImage = image;
    });
  }

  TextEditingController _carMake = TextEditingController();
  TextEditingController _carModel = TextEditingController();
  TextEditingController _carRegNum = TextEditingController();
  TextEditingController _carDate = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Car"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/bg_image.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: _carImage == null
                            ? Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/add_camera.png"),
                                  ),
                                ),
                              )
                            : Image.file(_carImage,
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.contain),
                      ),
                      TextField(
                        decoration:
                            InputDecoration(hintText: "Car Make(Brand)"),
                        style: TextStyle(fontSize: 20),
                        controller: _carMake,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Car Model"),
                        style: TextStyle(fontSize: 20),
                        controller: _carModel,
                      ),
                      TextField(
                        decoration:
                            InputDecoration(hintText: "Registration Number"),
                        style: TextStyle(fontSize: 20),
                        controller: _carRegNum,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: "Year"),
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        controller: _carDate,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomButton(
                              title: "Cancel",
                              onPress: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            CustomButton(
                              title: isLoading ? "" : "Add Car",
                              onPress: () {
                                if (_carModel.text.toString().isEmpty) {
                                  showEmptyToast("Car Model", context);
                                  return;
                                } else if (_carMake.text.toString().isEmpty) {
                                  showEmptyToast("Car Make", context);
                                  return;
                                } else if (_carRegNum.text.toString().isEmpty) {
                                  showEmptyToast("Car Reg. Number", context);
                                  return;
                                } else if (_carDate.text.toString().isEmpty) {
                                  showEmptyToast("Car Date", context);
                                  return;
                                }

                                carsReference.child(randomString()).set({
                                  'car_brand': _carMake.text,
                                  'car_model': _carModel.text,
                                  'car_date': _carDate.text,
                                  'car_num': _carRegNum.text,
                                  'car_image': "img"
                                }).then((_) {
                                  // Navigator.pop(context);

                                  /*  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return CircularProgressIndicator();
                                      });*/

                                  setState(() {
                                    isLoading = false;
                                  });
                                  Toast.show("Car added Successfully", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                });
                                Navigator.pop(context);
                              },
                              icon: isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    ),
                              iconLeft: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
