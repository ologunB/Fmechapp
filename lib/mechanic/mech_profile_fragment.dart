import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mechapp/dropdown_noti_cate.dart';
import 'package:mechapp/libraries/custom_button.dart';
import 'package:mechapp/libraries/toast.dart';
import 'package:mechapp/select_image.dart';

import '../utils/type_constants.dart';

class MechProfileFragment extends StatefulWidget {
  @override
  _MechProfileFragmentState createState() => _MechProfileFragmentState();
}

class _MechProfileFragmentState extends State<MechProfileFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  File _mainPicture, _previous1, _previous2;
  var rootRef = FirebaseDatabase.instance
      .reference()
      .child("Mechanic Collection")
      .child(mUID);
  var _storageRef = FirebaseStorage.instance.ref();

  Map dATA = {};

  Future<Map> getProfile() async {
    await rootRef.once().then((snapshot) {
      dATA = snapshot.value;
    });
    return dATA;
  }

  TextEditingController nameC,
      emailC,
      phoneNo,
      streetNameC,
      cityC,
      localityC,
      companyWebC,
      descptC,
      accNameC,
      accNumC,
      bankNameC,
      categoryC,
      specifiC;
  String profileImageUrl, pre1image, pre2image;
  List<bool> categoryBool, specBool;
  bool isUpdating = false;

  Future getImage(_setState) async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    _setState(() {
      _mainPicture = img;
    });
  }

  Widget _buildFutureBuilder(Color primaryColor) {
    return Center(
      child: FutureBuilder<Map>(
        future: getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            nameC = TextEditingController(text: dATA["Company Name"]);
            phoneNo = TextEditingController(text: dATA["Phone Number"]);
            emailC = TextEditingController(text: dATA["Email"]);
            streetNameC = TextEditingController(text: dATA["Street Name"]);
            cityC = TextEditingController(text: dATA["City"]);
            localityC = TextEditingController(text: dATA["Locality"]);
            companyWebC = TextEditingController(text: dATA["Website Url"]);
            descptC = TextEditingController(text: dATA["Description"]);
            accNameC = TextEditingController(text: dATA["Bank Account Name"]);
            accNumC = TextEditingController(text: dATA["Bank Account Number"]);
            bankNameC = TextEditingController(text: dATA["Bank Name"]);
            profileImageUrl = dATA["Image Url"];
            pre1image = dATA["PreviousImage1 Url"];
            pre2image = dATA["PreviousImage2 Url"];

            List categories = dATA["Categories"];
            List specifications = dATA["Specifications"];
            specifiC = TextEditingController(
                text: specifications
                    .toString()
                    .substring(1, specifications.toString().length - 1));
            categoryC = TextEditingController(
                text: categories
                    .toString()
                    .substring(1, categories.toString().length - 1));

            categoryBool = List();
            specBool = List();

            for (String item in categoryList) {
              if (categories.contains(item)) {
                categoryBool.add(true);
              } else {
                categoryBool.add(false);
              }
            }

            for (String item in specifyList) {
              if (specifications.contains(item)) {
                specBool.add(true);
              } else {
                specBool.add(false);
              }
            }

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/bg_image.jpg",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          StatefulBuilder(
                            builder: (context, _setState) {
                              return Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    getImage(_setState);
                                  },
                                  child: _mainPicture == null
                                      ? CachedNetworkImage(
                                          imageUrl: profileImageUrl,
                                          height: 90,
                                          width: 90,
                                          placeholder: (context, url) => Image(
                                              image: AssetImage(
                                                  "assets/images/engineer.png"),
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.contain),
                                          errorWidget: (context, url, error) =>
                                              Image(
                                                  image: AssetImage(
                                                      "assets/images/engineer.png"),
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.contain),
                                        )
                                      : Image.file(_mainPicture,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.contain),
                                ),
                              );
                            },
                          ),
                          /*    SelectImage(
                            url: profileImageUrl,
                            defaultUrl: "assets/images/engineer.png",
                            image: _mainPicture,
                          ),*/
                          NotiAndCategory(specifiC, specBool, "Specifications",
                              specifyList),
                          NotiAndCategory(categoryC, categoryBool, "Category",
                              categoryList),
                          TextField(
                            controller: nameC,
                            decoration: InputDecoration(
                                labelText: "Company Name",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                            readOnly: true,
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Phone Number",
                                labelText: "Phone Number",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                            controller: phoneNo,
                          ),
                          TextField(
                            controller: emailC,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: streetNameC,
                                  decoration: InputDecoration(
                                      labelText: "Street name",
                                      labelStyle:
                                          TextStyle(color: Colors.blue)),
                                  style: TextStyle(fontSize: 18),
                                  readOnly: true,
                                  onTap: () {},
                                ),
                              ),
                              Icon(
                                Icons.location_on,
                                color: primaryColor,
                              ),
                            ],
                          ),
                          TextField(
                            controller: cityC,
                            decoration: InputDecoration(
                                labelText: "City",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                            readOnly: true,
                          ),
                          TextField(
                            controller: localityC,
                            decoration: InputDecoration(
                                labelText: "Locality",
                                labelStyle: TextStyle(color: Colors.blue)),
                            readOnly: true,
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: companyWebC,
                            decoration: InputDecoration(
                                hintText: "Company's website",
                                labelText: "Company's website",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: descptC,
                            decoration: InputDecoration(
                                hintText: "Description",
                                labelText: "Description",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                          ),
                          Center(
                            child: Text(
                              "Images of previous works/workshop or goods",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: SelectImage(
                                  url: pre1image,
                                  defaultUrl: "assets/images/photo.png",
                                  image: _previous1,
                                ),
                              ),
                              Expanded(
                                child: SelectImage(
                                  url: pre2image,
                                  defaultUrl: "assets/images/photo.png",
                                  image: _previous2,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              "Account Details",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextField(
                            controller: accNameC,
                            decoration: InputDecoration(
                                hintText: "Account Name",
                                labelText: "Account Name",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                          ),
                          TextField(
                            controller: accNumC,
                            decoration: InputDecoration(
                                hintText: "Account Number",
                                labelText: "Account Number",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: bankNameC,
                            decoration: InputDecoration(
                                hintText: "Bank Name",
                                labelText: "Bank Name",
                                labelStyle: TextStyle(color: Colors.blue)),
                            style: TextStyle(fontSize: 18),
                          ),
                          StatefulBuilder(
                            builder: (context, _setState) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                  title: isUpdating
                                      ? "  Updating  "
                                      : "   Update   ",
                                  onPress: isUpdating
                                      ? null
                                      : () async {
                                          if (phoneNo.text.toString().isEmpty) {
                                            showEmptyToast(
                                                "Phone Number", context);
                                            return;
                                          }
                                          if (!categoryBool.contains(true)) {
                                            showToast(
                                                "A Category must be selected",
                                                context);
                                            return;
                                          }
                                          if (!specBool.contains(true)) {
                                            showToast(
                                                "A Specification must be selected",
                                                context);
                                            return;
                                          }
                                          _setState(() {
                                            isUpdating = true;
                                          });

                                          List<String> specTempList = [];
                                          int intA = 0;
                                          for (bool item in specBool) {
                                            if (item == true) {
                                              specTempList
                                                  .add(specifyList[intA]);
                                            }
                                            intA++;
                                          }

                                          List<String> cateTempList = [];
                                          int intB = 0;
                                          for (bool item in categoryBool) {
                                            if (item == true) {
                                              cateTempList
                                                  .add(categoryList[intB]);
                                            }
                                            intB++;
                                          }

                                          //   showToast("Updating...", context);

                                          final Map<String, Object> m = Map();
                                          m.putIfAbsent("Bank Account Name",
                                              () => accNameC.text.toString());
                                          m.putIfAbsent("Bank Account Number",
                                              () => accNumC.text.toString());
                                          m.putIfAbsent("Bank Name",
                                              () => bankNameC.text.toString());
                                          m.putIfAbsent("Phone Number",
                                              () => phoneNo.text.toString());
                                          m.putIfAbsent("Description",
                                              () => descptC.text.toString());
                                          m.putIfAbsent(
                                              "Website Url",
                                              () =>
                                                  companyWebC.text.toString());
                                          m.putIfAbsent(
                                              "Categories", () => cateTempList);
                                          m.putIfAbsent("Specifications",
                                              () => specTempList);

                                          Firestore.instance
                                              .collection("Mechanics")
                                              .document(mUID)
                                              .updateData(m);
                                          Firestore.instance
                                              .collection("All")
                                              .document(mUID)
                                              .updateData(m);

                                          showMiddleToast(
                                              _mainPicture.toString(), context);

                                          if (_mainPicture != null) {
                                            StorageReference reference =
                                                _storageRef.child(
                                                    "images/${randomString()}");

                                            StorageUploadTask uploadTask =
                                                reference.putFile(_mainPicture);
                                            StorageTaskSnapshot downloadUrl =
                                                (await uploadTask.onComplete);
                                            String url = (await downloadUrl.ref
                                                .getDownloadURL());

                                            rootRef.update({"Image Url": url});
                                            _setState(() {
                                              isUpdating = false;
                                            });
                                          }
                                          if (_previous1 != null) {
                                            StorageReference reference =
                                                _storageRef.child(
                                                    "images/${randomString()}");

                                            StorageUploadTask uploadTask =
                                                reference.putFile(_previous1);
                                            StorageTaskSnapshot downloadUrl =
                                                (await uploadTask.onComplete);
                                            String url = (await downloadUrl.ref
                                                .getDownloadURL());

                                            rootRef.update(
                                                {"PreviousImage1 Url": url});
                                            _setState(() {
                                              isUpdating = false;
                                            });
                                          }
                                          if (_previous2 != null) {
                                            StorageReference reference =
                                                _storageRef.child(
                                                    "images/${randomString()}");

                                            StorageUploadTask uploadTask =
                                                reference.putFile(_previous2);
                                            StorageTaskSnapshot downloadUrl =
                                                (await uploadTask.onComplete);
                                            String url = (await downloadUrl.ref
                                                .getDownloadURL());

                                            rootRef.update(
                                                {"PreviousImage2 Url": url});
                                            _setState(() {
                                              isUpdating = false;
                                            });
                                          }
                                          rootRef.update(m).then((value) => () {
                                                Toast.show("Updated!", context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.CENTER);
                                                _setState(() {
                                                  isUpdating = false;
                                                });
                                              });
                                        },
                                  icon: isUpdating
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.white)
                                      : Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
        height: double.infinity,
        color: Color(0xb090A1AE),
        child: _buildFutureBuilder(primaryColor));
  }
}
