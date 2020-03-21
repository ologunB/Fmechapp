import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/utils/type_constants.dart';

import 'libraries/custom_dialog.dart';

class TheModel {
  String name, number, price, time, image, status;
  TheModel(
      {this.name, this.number, this.price, this.time, this.image, this.status});
}

class MyJobsF extends StatefulWidget {
  @override
  _MyJobsFState createState() => _MyJobsFState();
}

class _MyJobsFState extends State<MyJobsF> {
  List<TheModel> list = [];

  Stream<List<TheModel>> _getJobs() async* {
    DatabaseReference dataRef = FirebaseDatabase.instance
        .reference()
        .child("Jobs Collection")
        .child(userType)
        .child(mUID);

    await dataRef.once().then((snapshot) {
      var kEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      String shortUserType;
      if (userType == "Customer") {
        shortUserType = "Mech";
      } else {
        shortUserType = "Customer";
      }

      list.clear();
      for (var index in kEYS) {
        String tempName = DATA[index]['$shortUserType Name'];
        String tempPrice = DATA[index]['Trans Amount'];
        String tempStatus = DATA[index]['Trans Confirmation'];
        String tempImage;
        String tempNumber = DATA[index]['$shortUserType Number'];
        String tempTime = DATA[index]['Trans Time'];
        if (userType == "Customer") {
          tempImage = DATA[index]['$shortUserType Image'];
        } else {
          tempImage = "Mech";
        }

        list.add(
          TheModel(
              name: tempName,
              price: tempPrice,
              number: tempNumber,
              image: tempImage,
              status: tempStatus,
              time: tempTime),
        );
      }
    });
    yield list;
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: StreamBuilder<List<TheModel>>(
        stream: _getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return list.length == 0
                ? emptyList("Jobs")
                : Container(
                    color: Color(0xb090A1AE),
                    height: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Column(
                                children: <Widget>[
                                  userType == "Customer"
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CachedNetworkImage(
                                            imageUrl: list[index].image,
                                            height: 70,
                                            width: 70,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              height: 70,
                                              width: 70,
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      "assets/images/engineer.png"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Text(
                                    list[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.deepPurple),
                                  ),
                                  Text(
                                    list[index].number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "N" + list[index].price,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Center(
                                    child: Text(
                                      list[index].time,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black),
                                    ),
                                  ),
                                  Center(
                                    child: userType == "Customer"
                                        ? Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Container(
                                              color: list[index].status ==
                                                      "Confirmed"
                                                  ? Colors.green
                                                  : Colors.red,
                                              child: Text(
                                                list[index]
                                                    .status
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : RaisedButton(
                                            color: Colors.blueGrey,
                                            onPressed: list[index].status ==
                                                    "Confirmed"
                                                ? null
                                                : () {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (_) =>
                                                          CustomDialog(
                                                        title:
                                                            "Are you sure you want to confirm the $userType?",
                                                        onPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        includeHeader: true,
                                                      ),
                                                    );
                                                  },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(9.0),
                                              child: Text(
                                                list[index].status ==
                                                        "Confirmed"
                                                    ? "Confirmed"
                                                    : "Confirm Job?",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: userType == "Customer" ? 0.7 : 0.9),
                    ),
                  );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(0xb090A1AE),
      child: _buildFutureBuilder(),
    );
  }
}
