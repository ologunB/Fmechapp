import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/cus_main.dart';
import 'package:mechapp/dropdown_noti_cate.dart';
import 'package:mechapp/get_location_from_address.dart';
import 'package:mechapp/mechanic/mech_main.dart';
import 'package:mechapp/select_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'libraries/custom_button.dart';
import 'utils/type_constants.dart';

TabController _tabController;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
DatabaseReference _dataRef = FirebaseDatabase.instance.reference();

class LogOn extends StatefulWidget {
  @override
  _LogOnState createState() => _LogOnState();
}

class _LogOnState extends State<LogOn> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white, size: 28),
          centerTitle: true,
          title: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.blueAccent,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            indicatorColor: Colors.white,
            indicator: BoxDecoration(),
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Sign In",
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg_image.jpg",
                ),
                fit: BoxFit.fill),
          ),
          child: TabBarView(
            children: [SignInPage(), SignUpPage()],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _inEmail = TextEditingController();
  TextEditingController _inPass = TextEditingController();
  TextEditingController _inForgotPass = TextEditingController();
  bool isLoading = false;
  bool forgotPassIsLoading = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future signIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser user = value.user;

      if (value.user != null) {
        if (!value.user.isEmailVerified) {
          setState(() {
            isLoading = false;
          });
          showToast("Email not verified", context);
          _firebaseAuth.signOut();
          return;
        }
        Firestore.instance
            .collection('All')
            .document(user.uid)
            .get()
            .then((document) {
          String type = document.data["Type"];
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return type == "Customer" ? CusMainPage() : MechMainPage();
              },
            ),
          );

          String uid = type == "Customer" ? "Uid" : "Mech Uid";
          putInDB(type, document.data[uid], document.data["Email"],
              document.data["Company Name"]);

          showToast("Logged in", context);
        }).catchError((ee) {
          setState(() {
            isLoading = false;
          });
          showToast(ee.toString(), context);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("User doesn't exist", context);
      }
      return;
    }).catchError((e) {
      showToast("$e", context);
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  Future putInDB(String type, String uid, String email, String name) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", uid);
      prefs.setString("email", email);
      prefs.setString("name", name);
      prefs.setString("type", type);
    });
    _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
            child: Card(
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: SingleChildScrollView(
                        child: Container(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CupertinoTextField(
                                          controller: _inEmail,
                                          placeholder: "Email",
                                          placeholderStyle: TextStyle(
                                              fontWeight: FontWeight.w400),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          padding: EdgeInsets.all(10),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CupertinoTextField(
                                          controller: _inPass,
                                          placeholder: "Password",
                                          padding: EdgeInsets.all(10),
                                          placeholderStyle: TextStyle(
                                              fontWeight: FontWeight.w400),
                                          obscureText: true,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (_) =>
                                                CupertinoAlertDialog(
                                              title: Column(
                                                children: <Widget>[
                                                  Text("Enter Email"),
                                                ],
                                              ),
                                              content: CupertinoTextField(
                                                controller: _inForgotPass,
                                                placeholder: "Email",
                                                padding: EdgeInsets.all(10),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                placeholderStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                              actions: <Widget>[
                                                Center(
                                                  child: StatefulBuilder(
                                                    builder:
                                                        (context, _setState) =>
                                                            CustomButton(
                                                      title: forgotPassIsLoading
                                                          ? ""
                                                          : "Reset Password",
                                                      onPress:
                                                          forgotPassIsLoading
                                                              ? null
                                                              : () async {
                                                                  setState(() {
                                                                    forgotPassIsLoading =
                                                                        true;
                                                                  });
                                                                  await _firebaseAuth
                                                                      .sendPasswordResetEmail(
                                                                          email: _inForgotPass
                                                                              .text)
                                                                      .then(
                                                                          (value) {
                                                                    _setState(
                                                                        () {
                                                                      forgotPassIsLoading =
                                                                          true;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                    showMiddleToast(
                                                                        "Reset Mail Sent",
                                                                        context);
                                                                  });
                                                                },
                                                      icon: forgotPassIsLoading
                                                          ? CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Colors.white,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      iconLeft: false,
                                                      hasColor:
                                                          forgotPassIsLoading
                                                              ? true
                                                              : false,
                                                      bgColor: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Center(
                                        child: CustomButton(
                                          title: isLoading ? "" : "  SIGN IN  ",
                                          onPress: isLoading
                                              ? null
                                              : () {
                                                  if (_inEmail.text
                                                      .toString()
                                                      .isEmpty) {
                                                    showEmptyToast(
                                                        "Email", context);
                                                    return;
                                                  } else if (_inPass.text
                                                      .toString()
                                                      .isEmpty) {
                                                    showEmptyToast(
                                                        "Password", context);
                                                    return;
                                                  }
                                                  signIn(_inEmail.text,
                                                      _inPass.text);
                                                },
                                          icon: isLoading
                                              ? CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                ),
                                          iconLeft: false,
                                          hasColor: isLoading ? true : false,
                                          bgColor: Colors.blueGrey,
                                        ),
                                      ),
                                    ]))))))));
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _switchIndex = 1;
  String _switchText = "Register as Mechanic";
  bool _switchBool = false;
  List<Widget> signUps = [
    CusSignUp(),
    MechSignUp(),
  ];
  Widget currentWidget = CusSignUp();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(child: currentWidget),
        Padding(
          padding: EdgeInsets.all(11.0),
          child: CustomButton(
            title: _switchText,
            onPress: () {
              setState(() {
                _switchIndex = _switchBool ? 0 : 1;
                _switchText =
                    _switchBool ? "Register as Mechanic" : "Register as User";
                _switchBool = !_switchBool;
                currentWidget = signUps[_switchIndex];
              });
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            iconLeft: false,
          ),
        ),
      ],
    );
  }
}

class CusSignUp extends StatefulWidget {
  @override
  _CusSignUpState createState() => _CusSignUpState();
}

class _CusSignUpState extends State<CusSignUp> {
  bool isLoading = false;
  TextEditingController _upEmail = TextEditingController();
  TextEditingController _upPass = TextEditingController();
  TextEditingController _upName = TextEditingController();
  TextEditingController _upPhoNum = TextEditingController();

  List<bool> categoryBool, specBool, tempSpecBool, tempCategoryBool;

  Future cusSignUp(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser user = value.user;

      if (value.user != null) {
        user.sendEmailVerification().then((verify) {
          Map<String, Object> mData = Map();
          mData.putIfAbsent("Company Name", () => _upName.text);
          mData.putIfAbsent("Phone Number", () => _upPhoNum.text);
          mData.putIfAbsent("Email", () => _upEmail.text);
          mData.putIfAbsent("Type", () => "Customer");
          mData.putIfAbsent("Uid", () => user.uid);

          Firestore.instance
              .collection("Customer")
              .document(user.uid)
              .setData(mData);
          Firestore.instance
              .collection("All")
              .document(user.uid)
              .setData(mData);
          _dataRef
              .child("Customer Collection")
              .child(user.uid)
              .set(mData)
              .then((b) {
            showToast("User created, Verify Email!", context);
            setState(() {
              isLoading = false;
            });
            _tabController.animateTo(0);
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("User doesn't exist", context);
      }
      return;
    }).catchError((e) {
      showToast("$e", context);
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "User's SignUp",
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Email"),
                      controller: _upName, padding: EdgeInsets.all(10),
                      keyboardType: TextInputType.text,
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      placeholder: "Full Name",

                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Email"),
                      controller: _upEmail,
                      placeholder: "Email", padding: EdgeInsets.all(10),
                      keyboardType: TextInputType.emailAddress,
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Email"),
                      controller: _upPhoNum,
                      placeholder: "Phone Number", padding: EdgeInsets.all(10),
                      keyboardType: TextInputType.number,
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Password"),
                      controller: _upPass,
                      placeholder: "Password",
                      obscureText: true, padding: EdgeInsets.all(10),
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Already A Member?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        MaterialButton(
                          onPressed: () {
                            _tabController.animateTo(0);
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: CustomButton(
                      title: isLoading ? "" : "   SIGN UP   ",
                      onPress: isLoading
                          ? null
                          : () {
                              if (_upEmail.text.toString().isEmpty) {
                                showEmptyToast("Email", context);
                                return;
                              } else if (_upPass.text.toString().isEmpty) {
                                showEmptyToast("Password", context);
                                return;
                              } else if (_upName.text.toString().isEmpty) {
                                showEmptyToast("Name", context);
                                return;
                              }
                              cusSignUp(_upEmail.text, _upPass.text);
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
                      hasColor: isLoading ? true : false,
                      bgColor: Colors.blueGrey,
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
}

class MechSignUp extends StatefulWidget {
  @override
  _MechSignUpState createState() => _MechSignUpState();
}

class _MechSignUpState extends State<MechSignUp> {
  bool isLoading = false;
  double theLong, theLat;

  File _mainPicture, _previous1, _previous2, _cacImage;
  TextEditingController _upSpecify = TextEditingController();
  TextEditingController _upCategory = TextEditingController();
  TextEditingController _upName = TextEditingController();
  TextEditingController _upPhoneNo = TextEditingController();
  TextEditingController _upEmail = TextEditingController();
  TextEditingController _upPass = TextEditingController();
  TextEditingController _upStreetName = TextEditingController();
  TextEditingController _upCity = TextEditingController();
  TextEditingController _upLocality = TextEditingController();
  TextEditingController _upWebsite = TextEditingController();
  TextEditingController _upDescpt = TextEditingController();

  Future cusSignUp(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser user = value.user;

      if (value.user != null) {
        if (_upDescpt.text.isEmpty) {
          _upDescpt.text = "empty";
        }
        if (_upWebsite.text.isEmpty) {
          _upWebsite.text = "No Url";
        }

        String sample =
            "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/photos%2Fimage%3A55039?alt=media&token=e25a7e4c-fa06-452a-b630-2b89bae6f7b4";

        String p1, p2;

        if (_previous1 == null) {
          p1 = sample;
        }
        if (_previous2 == null) {
          p2 = sample;
        }

        user.sendEmailVerification().then((verify) {
          List<String> specTempList = [];
          int intA = 0;
          for (bool item in _specifyBoolList) {
            if (item == true) {
              specTempList.add(specifyList[intA]);
            }
            intA++;
          }

          List<String> catTempList = [];
          int intB = 0;
          for (bool item in _categoryBoolList) {
            if (item == true) {
              catTempList.add(categoryList[intB]);
            }
            intB++;
          }

          Map<String, Object> m = Map();
          m.putIfAbsent("Company Name", () => _upName.text);
          m.putIfAbsent("Specifications", () => specTempList);
          m.putIfAbsent("Categories", () => catTempList);
          m.putIfAbsent("Phone Number", () => _upPhoneNo.text);
          m.putIfAbsent("Email", () => _upEmail);
          // m.putIfAbsent("Password", () => Password);
          m.putIfAbsent("Street Name", () => _upStreetName.text);
          m.putIfAbsent("City", () => _upCity.text);
          m.putIfAbsent("Locality", () => _upLocality.text);
          m.putIfAbsent("Description", () => _upDescpt.text);
          m.putIfAbsent("Website Url", () => _upWebsite.text);
          m.putIfAbsent("Loc Latitude", () => theLat);
          m.putIfAbsent("LOc Longitude", () => theLong);
          //    m.putIfAbsent("Image Url", () => downloadUrl1);
          //    m.putIfAbsent("CAC Image Url", () => downloadUri4);
          m.putIfAbsent("PreviousImage1 Url", () => p1);
          m.putIfAbsent("PreviousImage2 Url", () => p2);
          m.putIfAbsent("Bank Account Name", () => "");
          m.putIfAbsent("Bank Account Number", () => "");
          m.putIfAbsent("Bank Name", () => "");
          m.putIfAbsent("Type", () => "Mechanic");
          m.putIfAbsent("Jobs Done", () => "0");
          m.putIfAbsent("Rating", () => "0.00");
          m.putIfAbsent("Reviews", () => "0");
          m.putIfAbsent("Mech Uid", () => user.uid);
          Map<String, String> allJobs = Map();
          allJobs.putIfAbsent("Total Job", () => "0");
          allJobs.putIfAbsent("Total Amount", () => "0");
          allJobs.putIfAbsent("Pending Job", () => "0");
          allJobs.putIfAbsent("Pending Amount", () => "0");
          allJobs.putIfAbsent("Pay pending Amount", () => "0");
          allJobs.putIfAbsent("Completed Amount", () => "0");
          allJobs.putIfAbsent("Payment Request", () => "0");
          allJobs.putIfAbsent("Cash Payment Debt", () => "0");

          Firestore.instance
              .collection("Mechanics")
              .document(user.uid)
              .setData(m);
          Firestore.instance.collection("All").document(user.uid).setData(m);

          _dataRef.child("Mechanic Collection").child(user.uid).set(m);

          _dataRef
              .child("All Jobs Collection")
              .child(user.uid)
              .set(allJobs)
              .then((b) {
            showToast("User created, Verify Email!", context);
            setState(() {
              isLoading = false;
            });
            _tabController.animateTo(0);
            _firebaseAuth.signOut();
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("User doesn't exist", context);
      }
      return;
    }).catchError((e) {
      showToast("$e", context);
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Mechanic's SignUp",
                      style: TextStyle(
                          fontSize: 20,
                          color: primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SelectImage(
                  url: "em",
                  defaultUrl: "assets/images/engineer.png",
                  image: _mainPicture,
                ),
                NotiAndCategory(_upSpecify, _specifyBoolList, "Specifications",
                    specifyList),
                NotiAndCategory(
                    _upCategory, _categoryBoolList, "Category", categoryList),
                /*       Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: "Choose Specification"),
                        style: TextStyle(fontSize: 18),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(
                                "Choose Specification",
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: ListView.builder(
                                  itemCount: specifyList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Material(
                                            child: StatefulBuilder(
                                          builder: (context, _setState) =>
                                              CheckboxListTile(
                                            title: Text(
                                              specifyList[index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            value: _specifyBoolList[index],
                                            onChanged: (e) {
                                              _setState(
                                                () {
                                                  if (_specifyBoolList[index]) {
                                                    _specifyBoolList[index] =
                                                        !_specifyBoolList[
                                                            index];
                                                  } else {
                                                    _specifyBoolList[index] =
                                                        !_specifyBoolList[
                                                            index];
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        )));
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Cancel",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  title: "OK",
                                  onPress: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                  iconLeft: false,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      color: primaryColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: "Choose Category"),
                        style: TextStyle(fontSize: 18),
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(
                                "Choose Category",
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: ListView.builder(
                                  itemCount: categoryList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Material(
                                            child: StatefulBuilder(
                                          builder: (context, _setState) =>
                                              CheckboxListTile(
                                            title: Text(
                                              categoryList[index],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            value: _categoryBoolList[index],
                                            onChanged: (e) {
                                              _setState(
                                                () {
                                                  if (_categoryBoolList[
                                                      index]) {
                                                    _categoryBoolList[index] =
                                                        !_categoryBoolList[
                                                            index];
                                                  } else {
                                                    _categoryBoolList[index] =
                                                        !_categoryBoolList[
                                                            index];
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        )));
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "Cancel",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  title: "OK",
                                  onPress: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                  iconLeft: false,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      color: primaryColor,
                    ),
                  ],
                ),*/
                TextField(
                  decoration: InputDecoration(hintText: "Company Name"),
                  style: TextStyle(fontSize: 18),
                  controller: _upName,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Phone Number"),
                  controller: _upPhoneNo,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Email"),
                  controller: _upEmail,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Password"),
                  controller: _upEmail,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.visiblePassword,
                ),
                GetLocationFromAddress(
                  theLat: theLat,
                  theLong: theLong,
                  upStreetName: _upStreetName,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "City"),
                  style: TextStyle(fontSize: 18),
                  controller: _upCity,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Locality"),
                  style: TextStyle(fontSize: 18),
                  controller: _upLocality,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Company's website"),
                  style: TextStyle(fontSize: 18),
                  controller: _upWebsite,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Description"),
                  style: TextStyle(fontSize: 18),
                  controller: _upDescpt,
                ),
                Center(
                  child: Text(
                    "Images of previous works/workshop or goods",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: SelectImage(
                        url: "e ",
                        defaultUrl: "assets/images/photo.png",
                        image: _previous1,
                      ),
                    ),
                    Expanded(
                      child: SelectImage(
                        url: " e",
                        defaultUrl: "assets/images/photo.png",
                        image: _previous2,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "Valid ID Certificate / CAC Image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Center(
                    child: SelectImage(
                  url: " e",
                  defaultUrl: "assets/images/photo.png",
                  image: _cacImage,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    title: isLoading ? "" : "   Register   ",
                    onPress: isLoading
                        ? null
                        : () {
                            if (_upEmail.text.toString().isEmpty) {
                              showEmptyToast("Email", context);
                            } else if (_upPass.text.toString().isEmpty) {
                              showEmptyToast("Password", context);
                            } else if (_upName.text.toString().isEmpty) {
                              showEmptyToast("Name", context);
                            } else if (_upPhoneNo.text.toString().isEmpty) {
                              showEmptyToast("Phone Number", context);
                            } else if (_upSpecify.text.toString().isEmpty) {
                              showEmptyToast("Specification", context);
                            } else if (_upCategory.text.toString().isEmpty) {
                              showEmptyToast("Category", context);
                            } else if (_upStreetName.text.toString().isEmpty) {
                              showEmptyToast("Street name", context);
                            } else if (_upCity.text.toString().isEmpty) {
                              showEmptyToast("City", context);
                            } else if (_upLocality.text.toString().isEmpty) {
                              showEmptyToast("Locality", context);
                            } else if (_cacImage == null) {
                              showEmptyToast("CAC Image", context);
                            } else if (_mainPicture == null) {
                              showEmptyToast("Image", context);
                            }
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
                    hasColor: isLoading ? true : false,
                    bgColor: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<bool> _specifyBoolList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

List<bool> _categoryBoolList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
