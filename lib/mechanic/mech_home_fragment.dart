import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/utils/type_constants.dart';

class MechHomeFragment extends StatefulWidget {
  @override
  _MechHomeFragmentState createState() => _MechHomeFragmentState();
}

class _MechHomeFragmentState extends State<MechHomeFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<String> list = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  List<String> tempList = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  Future<List<String>> getJobs() async {
    DatabaseReference dataRef = FirebaseDatabase.instance
        .reference()
        .child("All Jobs Collection")
        .child(mUID);

    await dataRef.once().then((snapshot) {
      var DATA = snapshot.value;

      String t1 = DATA['Total Job'];
      String t2 = DATA['Total Amount'];
      String t3 = DATA['Pending Job'];
      String t4 = DATA['Pending Amount'];
      String t5 = DATA['Pay pending Job'];
      String t6 = DATA['Pay pending Amount'];
      String t7 = DATA['Completed Job'];
      String t8 = DATA['Completed Amount'];

      tempList.clear();
      tempList.insert(0, t1);
      tempList.insert(1, t2);
      tempList.insert(2, t3);
      tempList.insert(3, t4);
      tempList.insert(4, t5);
      tempList.insert(5, t6);
      tempList.insert(6, t7);
      tempList.insert(7, t8);
    });

    return list;
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: FutureBuilder<List<String>>(
        future: getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _eachItem("Total Jobs", list[0], list[1], context),
                    _eachItem("Pending Jobs", list[2], list[3], context),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _eachItem("Pay Pending", list[4], list[5], context),
                    _eachItem("Pay Completed", list[6], list[7], context),
                  ],
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _eachItem("Total Jobs", "--", "--", context),
                  _eachItem("Pending Jobs", "--", "--", context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _eachItem("Pay Pending", "--", "--", context),
                  _eachItem("Pay Completed", "--", "--", context),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    list = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    ];
    getJobs();
    setState(() {
      list = tempList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/bg_image.jpg",
              ),
              fit: BoxFit.fill),
        ),
        child: _buildFutureBuilder());
  }
}

Widget _eachItem(
    String type, String noJobs, String amount, BuildContext context) {
  var height = MediaQuery.of(context).size.height / 3;
  var width = MediaQuery.of(context).size.width / 2.5;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 4,
      child: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              type,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 8.0,
              ),
            ),
            Text(
              "Jobs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(
              noJobs,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Text(
              "Amount",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(
              "₦" + " $amount",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}
