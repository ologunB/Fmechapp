import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/home_fragment.dart';
import 'package:url_launcher/url_launcher.dart';

import 'libraries/custom_button.dart';
import 'libraries/custom_dialog.dart';
import 'pay_mechanic.dart';

class ViewMechProfile extends StatefulWidget {
  final EachMechanic mechanic;
  ViewMechProfile({Key key, @required this.mechanic}) : super(key: key);
  @override
  _ViewMechProfileState createState() => _ViewMechProfileState();
}

class _ViewMechProfileState extends State<ViewMechProfile> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    bool jobVisibility = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mechanic"),
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
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/engineer.png"),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.mechanic.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Description: ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w700),
                          ),
                          Flexible(
                            child: Text(
                              widget.mechanic.descrpt,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Location: ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w700),
                          ),
                          Flexible(
                            child: Text(
                              widget.mechanic.streetName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Jobs Done:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "--",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Rating:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "--",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomButton(
                          title: "Call Now",
                          onPress: () {
                            launch(
                              "tel://${widget.mechanic.phoneNumber}",
                            );
                            setState(() {
                              jobVisibility = true;
                            });
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                        Visibility(
                          child: CustomButton(
                            title: "Create Job",
                            onPress: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => CustomDialog(
                                  title:
                                      "Are you sure you have reached the mechanic before you proceed with further payment?",
                                  onPress: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => PayMechanicPage(
                                          mechanic: widget.mechanic,
                                        ),
                                      ),
                                    );
                                  },
                                  includeHeader: true,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            iconLeft: false,
                          ),
                          visible: jobVisibility,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
