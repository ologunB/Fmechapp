import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/utils/my_models.dart';
import 'package:mechapp/utils/type_constants.dart';

import 'add_car_activity.dart';
import 'libraries/custom_button.dart';
import 'libraries/custom_dialog.dart';

class MyGarage extends StatefulWidget {
  @override
  _ListViewNoteState createState() => _ListViewNoteState();
}

final carsReference =
    FirebaseDatabase.instance.reference().child("Car Collection").child(mUID);

class _ListViewNoteState extends State<MyGarage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Car> items;
  StreamSubscription<Event> _onCarAddedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onCarAddedSubscription = carsReference.onChildAdded.listen(_onCarAdded);
  }

  @override
  void dispose() {
    _onCarAddedSubscription.cancel();
    super.dispose();
  }

  void _onCarAdded(Event event) {
    setState(() {
      items.add(new Car.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xb090A1AE);
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomButton(
              title: "   Add Car   ",
              onPress: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return AddCarActivity();
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                child: items.length == 0
                    ? emptyList("Cars")
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.black12)],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        Text(
                                          items[index].brand,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          " - ${items[index].date}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54),
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                      items[index].model,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    /*leading: Image.network(
                                    items[index].img,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  ),*/
                                    leading: CachedNetworkImage(
                                      imageUrl: items[index].img,
                                      height: 50,
                                      width: 50,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 50,
                                        width: 50,
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/car.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => CustomDialog(
                                              title:
                                                  "Are you sure you want to remove the car from garage?",
                                              onPress: () {
                                                Navigator.pop(context);
                                                carsReference
                                                    .child(items[index].id)
                                                    .remove();
                                                setState(() {
                                                  items.removeAt(index);
                                                });
                                              },
                                              includeHeader: true,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
