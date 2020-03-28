import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mechapp/dropdown_noti_cate.dart';
import 'package:mechapp/header_image.dart';
import 'package:mechapp/libraries/custom_button.dart';
import 'package:mechapp/libraries/toast.dart';

import '../log_in.dart';
import '../utils/type_constants.dart';

class MechProfileFragment extends StatefulWidget {
  @override
  _MechProfileFragmentState createState() => _MechProfileFragmentState();
}

var rootRef = FirebaseDatabase.instance.reference();

class _MechProfileFragmentState extends State<MechProfileFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  File _mainPicture, _previous1, _previous2;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _mainPicture = image;
    });
  }

  Future getPre1() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _previous1 = image;
    });
  }

  Future getPre2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _previous2 = image;
    });
  }

  Map dATA = {};

  Future<Map> getProfile() async {
    DatabaseReference dataRef =
        rootRef.child("Mechanic Collection").child(mUID);

    await dataRef.once().then((snapshot) {
      dATA = snapshot.value;

/*      String t1 = DATA['Company Name'];
      List<String> t2 = DATA['Specifications'];
      List<String> t3 = DATA['Categories'];
      String t4 = DATA['Phone Number'];
      String t5 = DATA['Email'];
      String t6 = DATA['City'];
      String t7 = DATA['Locality'];
      String t8 = DATA['Description'];
      String t9 = DATA['Website Url'];
      String t10 = DATA['Image Url'];
      String t11 = DATA['PreviousImage1 Url'];
      String t12 = DATA['PreviousImage2 Url'];*/
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
  List<bool> categoryBool, specBool, tempSpecBool, tempCategoryBool;
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
                          HeaderImage(profileImageUrl),
                          NotiAndCategory(specifiC, specBool, tempCategoryBool,
                              "Specifications", specifyList),
                          NotiAndCategory(categoryC, categoryBool,
                              tempCategoryBool, "Category", categoryList),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      getPre1();
                                    },
                                    /*   child: _previous1 == null
                                        ? Image(
                                            image: AssetImage(
                                                "assets/images/photo.png"),
                                            height: 100,
                                            fit: BoxFit.contain)
                                        : Image.file(_previous1,
                                            height: 100, fit: BoxFit.contain), */
                                    child: CachedNetworkImage(
                                      imageUrl: pre1image,
                                      height: 40,
                                      width: 40,
                                      placeholder: (context, url) => Image(
                                          image: AssetImage(
                                              "assets/images/photo.png"),
                                          height: 100,
                                          fit: BoxFit.contain),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                              image: AssetImage(
                                                  "assets/images/photo.png"),
                                              height: 100,
                                              fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      getPre2();
                                    },
                                    child: _previous2 == null
                                        ? Image(
                                            image: AssetImage(
                                                "assets/images/photo.png"),
                                            height: 100,
                                            fit: BoxFit.contain)
                                        : Image.file(_previous2,
                                            height: 100, fit: BoxFit.contain),
                                  ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              title: "   Update   ",
                              onPress: () {
                                if (phoneNo.text.toString().isEmpty) {
                                  showEmptyToast("Phone Number", context);
                                  return;
                                }
                                if (!categoryBool.contains(true)) {
                                  showToast(
                                      "A Category must be selected", context);
                                  return;
                                }
                                if (!specBool.contains(true)) {
                                  showToast("A Specification must be selected",
                                      context);
                                  return;
                                }

                                List<String> specTempList = [];
                                int intA = 0;
                                for (bool item in specBool) {
                                  if (item == true) {
                                    specTempList.add(specifyList[intA]);
                                  }
                                  intA++;
                                }

                                List<String> cateTempList = [];
                                int intB = 0;
                                for (bool item in categoryBool) {
                                  if (item == true) {
                                    cateTempList.add(categoryList[intB]);
                                  }
                                  intB++;
                                }

                                showToast("Updating...", context);

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
                                m.putIfAbsent("Website Url",
                                    () => companyWebC.text.toString());
                                m.putIfAbsent("Categories", () => cateTempList);
                                m.putIfAbsent(
                                    "Specifications", () => specTempList);

                                /*        db
                                    .collection("Mechanics")
                                    .document(Uid_)
                                    .update(m);
                                db.collection("All").document(Uid_).update(m);

                                  Firestore.instance.collection("Mechanics").document(mUID).setData({
          "ID": user.uid,
          "Name": user.displayName,
          "Picture": user.photoUrl
        });
         Firestore.instance.collection("All").document(mUID).setData({
          "ID": user.uid,
          "Name": user.displayName,
          "Picture": user.photoUrl
        });*/
                                if (_mainPicture != null) {}
                                if (_previous1 != null) {}
                                if (_previous2 != null) {}
                                rootRef
                                    .child("Mechanic Collection")
                                    .child(mUID)
                                    .update(m)
                                    .then((value) => () {
                                          Toast.show("Updated!", context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.CENTER);
                                        });
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                            ),
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
