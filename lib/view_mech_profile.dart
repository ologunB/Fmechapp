import 'package:firebase_database/firebase_database.dart';
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

class _ViewMechProfileState extends State<ViewMechProfile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String jobsDone = "--";

  Future<String> getJobs() async {
    DatabaseReference dataRef = FirebaseDatabase.instance
        .reference()
        .child("All Jobs Collection")
        .child(widget.mechanic.uid);

    await dataRef.once().then((snapshot) {
      jobsDone = snapshot.value['Total Job'];
    });
    return jobsDone;
  }

  bool jobVisibility = false;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

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
                              fontSize: 24,
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
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w700),
                          ),
                          Flexible(
                            child: Text(
                              widget.mechanic.descrpt,
                              style: TextStyle(
                                  fontSize: 22,
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
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w700),
                          ),
                          Flexible(
                            child: Text(
                              widget.mechanic.streetName,
                              style: TextStyle(
                                  fontSize: 22,
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
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                              FutureBuilder<String>(
                                  future: getJobs(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          jobsDone,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "--",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                                  })
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
                                  widget.mechanic.rating,
                                  style: TextStyle(
                                      fontSize: 25,
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
                        StatefulBuilder(builder: (context, _setState) {
                          return CustomButton(
                            title: "Call Now",
                            onPress: () {
                              setState(() {
                                jobVisibility = true;
                              });
                              launch(
                                "tel://${widget.mechanic.phoneNumber}",
                              );
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          );
                        }),
                        Visibility(
                          visible: jobVisibility,
                          child: CustomButton(
                            title: "Create Job",
                            onPress: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => CustomDialog(
                                  title:
                                      "Are you sure you have reached the mechanic before you proceed with further payment?",
                                  onClicked: () {
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
