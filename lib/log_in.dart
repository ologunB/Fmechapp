import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/mechanic/mech_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cus_main.dart';
import 'libraries/custom_button.dart';
import 'libraries/toast.dart';
import 'utils/type_constants.dart';

class LogOn extends StatefulWidget {
  @override
  _LogOnState createState() => _LogOnState();
}

showEmptyToast(String aa, BuildContext context) {
  Toast.show("$aa cannot be empty", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  return;
}

showToast(String aa, BuildContext context) {
  Toast.show("$aa", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  return;
}

TabController __tabController;

class _LogOnState extends State<LogOn> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    __tabController = new TabController(vsync: this, length: 2);
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
            controller: __tabController,
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
            controller: __tabController,
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
  String inEmail = "";
  String inPass = "";
  String inForgotPass = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future putInDB(String type, String uid, String email, String name) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.setBool("isLoggedIn", true);
      prefs.setString("uid", uid);
      prefs.setString("email", email);
      prefs.setString("name", name);
      prefs.setString("type", type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoTextField(
                              //decoration: InputDecoration(hintText: "Email"),
                              controller: _inEmail,
                              placeholder: "Email",
                              placeholderStyle:
                                  TextStyle(fontWeight: FontWeight.w400),

                              keyboardType: TextInputType.emailAddress,
                              padding: EdgeInsets.all(10),
                              onChanged: (String e) {
                                setState(() {
                                  e = inEmail;
                                });
                              },
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoTextField(
                              //decoration: InputDecoration(hintText: "Password"),
                              controller: _inPass,
                              placeholder: "Password",
                              padding: EdgeInsets.all(10),
                              placeholderStyle:
                                  TextStyle(fontWeight: FontWeight.w400),

                              obscureText: true,
                              onChanged: (String e) {
                                setState(() {
                                  e = inPass;
                                });
                              },
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                  title: Column(
                                    children: <Widget>[
                                      Text("Enter Email"),
                                    ],
                                  ),
                                  content: CupertinoTextField(
                                    //decoration: InputDecoration(hintText: "Password"),
                                    controller: _inForgotPass,
                                    placeholder: "Email",
                                    padding: EdgeInsets.all(10),
                                    keyboardType: TextInputType.emailAddress,
                                    placeholderStyle:
                                        TextStyle(fontWeight: FontWeight.w300),

                                    onChanged: (String e) {
                                      setState(() {
                                        e = inForgotPass;
                                      });
                                    },
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: CustomButton(
                                        title: "Reset Password",
                                        onPress: () {
                                          /*@override
                                          Future<void> resetPassword(
                                              String email) async {
                                            await _firebaseAuth
                                                .sendPasswordResetEmail(
                                                    email: email);
                                          }*/
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                        iconLeft: false,
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
                              title: "  SIGN IN  ",
                              onPress: () {
                                if (_inEmail.text.toString().isEmpty) {
                                  showEmptyToast("Email", context);
                                } else if (_inPass.text.toString().isEmpty) {
                                  showEmptyToast("Password", context);
                                }
                                //putInDB("from The DB", " ", " ");
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              iconLeft: false,
                            ),
                          ),
                          Center(
                            child: CustomButton(
                              title: "  SIGN IN as mech  ",
                              onPress: () {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return MechMainPage();
                                    },
                                  ),
                                );
                                putInDB(
                                    "Mechanic",
                                    "pF7fSGBoubOoFsAwNXB8XUZ5FDH2",
                                    "mechtest@gmail.com",
                                    "mechanic Name");
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              iconLeft: false,
                            ),
                          ),
                          Center(
                            child: CustomButton(
                              title: "  SIGN IN as cus  ",
                              onPress: () {
                                Navigator.of(context).pushReplacement(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return CusMainPage();
                                    },
                                  ),
                                );
                                putInDB(
                                    "Customer",
                                    "c7a2dRWq1eShKhhCBVzoiyys6j33",
                                    "customertest@gmail.com",
                                    "customer Name");
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              iconLeft: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
/*
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1100),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          reverseDuration: Duration(milliseconds: 1100),
          child: Center(child: _widget),
        ),
*/
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
  TextEditingController _upEmail = TextEditingController();
  TextEditingController _upPass = TextEditingController();
  TextEditingController _upName = TextEditingController();
  String upEmail = "";
  String upPass = "";
  String upName = "";
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
                      padding: const EdgeInsets.only(bottom: 8.0),
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

                      placeholder: "Name",
                      onChanged: (String e) {
                        setState(() {
                          e = upName;
                        });
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Email"),
                      controller: _upEmail,
                      placeholder: "Email", padding: EdgeInsets.all(10),
                      keyboardType: TextInputType.emailAddress,
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      onChanged: (String e) {
                        setState(() {
                          e = upEmail;
                        });
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      //decoration: InputDecoration(hintText: "Password"),
                      controller: _upPass,
                      placeholder: "Password",
                      obscureText: true, padding: EdgeInsets.all(10),
                      placeholderStyle: TextStyle(fontWeight: FontWeight.w400),

                      onChanged: (String e) {
                        setState(() {
                          e = upPass;
                        });
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Already A Member?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        MaterialButton(
                          onPressed: () {
                            __tabController.animateTo(0);
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
                      title: "   SIGN UP   ",
                      onPress: () {
                        if (_upEmail.text.toString().isEmpty) {
                          showEmptyToast("Email", context);
                        } else if (_upPass.text.toString().isEmpty) {
                          showEmptyToast("Password", context);
                        } else if (_upName.text.toString().isEmpty) {
                          showEmptyToast("Name", context);
                        }
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      iconLeft: false,
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
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

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
//    TextEditingController _inPass = TextEditingController();
//    TextEditingController _inForgotPass = TextEditingController();
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
                InkWell(
                  onTap: () {},
                  child: Image(
                    image: AssetImage("assets/images/add_camera.png"),
                    height: 90,
                  ),
                ),
                Row(
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
                                            value: specifyBoolList[index],
                                            onChanged: (e) {
                                              _setState(
                                                () {
                                                  if (specifyBoolList[index]) {
                                                    specifyBoolList[index] =
                                                        !specifyBoolList[index];
                                                  } else {
                                                    specifyBoolList[index] =
                                                        !specifyBoolList[index];
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
                                            value: categoryBoolList[index],
                                            onChanged: (e) {
                                              _setState(
                                                () {
                                                  if (categoryBoolList[index]) {
                                                    categoryBoolList[index] =
                                                        !categoryBoolList[
                                                            index];
                                                  } else {
                                                    categoryBoolList[index] =
                                                        !categoryBoolList[
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Street name"),
                        style: TextStyle(fontSize: 18),
                        readOnly: true,
                        onTap: () {},
                        controller: _upStreetName,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                  ],
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
                    Image(
                      image: AssetImage("assets/images/photo.png"),
                      height: 100,
                    ),
                    Image(
                      image: AssetImage("assets/images/photo.png"),
                      height: 100,
                    )
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
                  child: Image(
                    image: AssetImage("assets/images/photo.png"),
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    title: "   Register   ",
                    onPress: () {
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
                      }
                      /*else if (_upWebsite.text.toString().isEmpty) {
                        showEmptyToast("Company's Website", context);
                      } else if (_upDescpt.text.toString().isEmpty) {
                        showEmptyToast("Description", context);
                      }*/
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
    );
  }
}
