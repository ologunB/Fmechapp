import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/log_in.dart';
import 'package:mechapp/utils/type_constants.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'libraries/custom_dialog.dart';

class JobModel {
  String otherPersonName,
      phoneNumber,
      amount,
      time,
      image,
      cusStatus,
      mechStatus,
      transactID,
      otherPersonUID,
      hasReviewed,
      carType;
  JobModel(
      {this.otherPersonName,
      this.phoneNumber,
      this.amount,
      this.time,
      this.image,
      this.cusStatus,
      this.hasReviewed,
      this.mechStatus,
      this.otherPersonUID,
      this.transactID,
      this.carType});
}

List<JobModel> list = [];
String selectedUID, preRating, preReview, a_, b_, c_, d_, e_, f_, g_, h_;
var rootRef = FirebaseDatabase.instance.reference();

class MyJobsF extends StatefulWidget {
  @override
  _MyJobsFState createState() => _MyJobsFState();
}

class _MyJobsFState extends State<MyJobsF> {
  Stream<List<JobModel>> _getJobs() async* {
    DatabaseReference dataRef =
        rootRef.child("Jobs Collection").child(userType).child(mUID);

    await dataRef.once().then((snapshot) {
      var kEYS = snapshot.value.keys;
      var dATA = snapshot.value;

      list.clear();
      for (var index in kEYS) {
        String tempName = dATA[index]['Mech Name'];
        String tempPrice = dATA[index]['Trans Amount'];
        String tempCusStatus = dATA[index]['Trans Confirmation'];
        String tempImage = dATA[index]['Mech Image'];
        String tempHasReviewed = dATA[index]['hasReviewed'];
        String tempNumber = dATA[index]['Mech Number'];
        String tempTime = dATA[index]['Trans Time'];
        String tempMechStatus = dATA[index]['Mech Confirmation'];
        String tempMechUID = dATA[index]['Mech UID'];
        String tempTransID = dATA[index]['Trans ID'];
        String tempCarType = dATA[index]['Car Type'];

        list.add(
          JobModel(
              otherPersonName: tempName,
              amount: tempPrice,
              phoneNumber: tempNumber,
              image: tempImage,
              cusStatus: tempCusStatus,
              time: tempTime,
              hasReviewed: tempHasReviewed,
              mechStatus: tempMechStatus,
              otherPersonUID: tempMechUID,
              transactID: tempTransID,
              carType: tempCarType),
        );
      }
    });
    yield list;
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: StreamBuilder<List<JobModel>>(
        stream: _getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String status = "Confirm Job?";
            Color statusColor = Colors.blue;

            return list.length == 0
                ? emptyList("Jobs")
                : Container(
                    color: Color(0xb090A1AE),
                    height: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        if (list[index].cusStatus == "Confirmed" &&
                            list[index].mechStatus == "Confirmed") {
                          if (list[index].hasReviewed == "True") {
                            status = "COMPLETED!";
                            statusColor = Colors.black38;
                          } else {
                            status = "RATE MECH.";
                            statusColor = Colors.teal;
                          }
                        } else if (list[index].cusStatus == "Confirmed") {
                          status = "PENDING!";
                          statusColor = Colors.red;
                        } else {
                          status = "Confirm Job?";
                          statusColor = Colors.blue;
                        }
                        return Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CachedNetworkImage(
                                      imageUrl: list[index].image,
                                      height: 70,
                                      width: 70,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
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
                                  ),
                                  Text(
                                    list[index].otherPersonName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.deepPurple),
                                  ),
                                  Text(
                                    list[index].phoneNumber,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    "₦" + list[index].amount,
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
                                  ConfirmButton(
                                      index: index,
                                      status: status,
                                      statusColor: statusColor),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.7),
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

void confirmJob(BuildContext context, int index) async {
  String otherUID = list[index].otherPersonUID;
  String transactID = list[index].transactID;
  String amount = list[index].amount;
  String carType = list[index].carType;
  String nameOfMech = list[index].otherPersonName;

  try {
    int aa = int.parse(a_) + 1; // Total Jobs
    int bb = int.parse(b_) + int.parse(amount); // Total Amount
    int cc = int.parse(c_) - 1; // Pending Jobs
    int dd = int.parse(d_) - int.parse(amount); // Pending Amount
    int ee = int.parse(e_) + 1; // Pay pending Jobs
    int ff = int.parse(f_) + int.parse(amount); // Pay pending Amount

    final Map<String, Object> updateJobs = Map();
    updateJobs.putIfAbsent("Total Job", () => aa.toString());
    updateJobs.putIfAbsent("Total Amount", () => bb.toString());
    updateJobs.putIfAbsent("Pending Job", () => cc.toString());
    updateJobs.putIfAbsent("Pending Amount", () => dd.toString());
    updateJobs.putIfAbsent("Pay pending Job", () => ee.toString());
    updateJobs.putIfAbsent("Pay pending Amount", () => ff.toString());

    String made = "Your payment of ₦" +
        amount +
        " to " +
        nameOfMech +
        " for " +
        carType +
        " has been confirmed by you. Thanks for using FABAT";

    String received = "You have a confirmed payment of ₦" +
        amount +
        " by " +
        mName +
        " and shall be available soonest. Thanks for using FABAT";

    final Map<String, String> sentMessage = Map();
    sentMessage.putIfAbsent("notification_message", () => made);
    sentMessage.putIfAbsent("notification_time", () => thePresentTime());

    final Map<String, String> receivedMessage = Map();
    receivedMessage.putIfAbsent("notification_message", () => received);
    receivedMessage.putIfAbsent("notification_time", () => thePresentTime());

    Map<String, Object> valuesToMech = Map();
    valuesToMech.putIfAbsent("Trans Confirmation", () => "Confirmed");

    final Map<String, Object> valuesToCustomer = Map();
    valuesToCustomer.putIfAbsent("Trans Confirmation", () => "Confirmed");

    rootRef
        .child("Jobs Collection")
        .child("Mechanic")
        .child(otherUID)
        .child(transactID)
        .update(valuesToMech);

    rootRef
        .child("Notification Collection")
        .child("Mechanic")
        .child(otherUID)
        .child(transactID)
        .set(receivedMessage);

    rootRef
        .child("Jobs Collection")
        .child("Customer")
        .child(mUID)
        .child(transactID)
        .update(valuesToCustomer);
    rootRef
        .child("Notification Collection")
        .child("Customer")
        .child(mUID)
        .push()
        .set(sentMessage);
    rootRef.child("All Jobs Collection").child(otherUID).update(updateJobs);
  } catch (exp) {
    showToast("Getting values. Try again...", context);
  }
}

void rateMechanic(BuildContext context, int index, String reviewMessage,
    double givenRate) async {
  final Map<String, String> review = Map();
  review.putIfAbsent("review_message", () => reviewMessage);
  review.putIfAbsent("review_time", () => thePresentTime());

  final Map<String, Object> cusVal = Map();
  cusVal.putIfAbsent("hasReviewed", () => "True");

  try {
    double _rate = double.parse(preRating);
    int _review = int.parse(preReview);

    int presentReview = _review + 1;
    String presentRate =
        (((_rate * _review) + givenRate) / presentReview).toString();
    final Map<String, Object> updateMech = Map();
    updateMech.putIfAbsent("Rating", () => presentRate.substring(0, 3));
    updateMech.putIfAbsent("Reviews", () => presentReview.toString());

    await rootRef
        .child("Mechanic Collection")
        .child(selectedUID)
        .update(updateMech);

    await rootRef
        .child("Mechanic Reviews")
        .child("Mechanic")
        .child(selectedUID)
        .child(randomString())
        .set(review);
    await rootRef
        .child("Jobs Collection")
        .child("Customer")
        .child(mUID)
        .child(list[index].transactID)
        .update(cusVal);
  } catch (exp) {
    showToast("Getting data, Try again", context);
  }
}

class ConfirmButton extends StatefulWidget {
  final int index;
  String status;
  Color statusColor;
  ConfirmButton({this.index, this.statusColor, this.status});
  @override
  _ConfirmButtonState createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = TextEditingController();
    double ratingNum = 3;
    return Center(
      child: RaisedButton(
        color: widget.statusColor,
        onPressed: () async {
          selectedUID = list[widget.index].otherPersonUID;

          switch (widget.status) {
            case "Confirm Job?":
              {
                rootRef
                    .child("All Jobs Collection")
                    .child(selectedUID)
                    .once()
                    .then((snapshot) => () {
                          a_ = snapshot.value["Total Job"];
                          b_ = snapshot.value["Total Amount"];
                          c_ = snapshot.value["Pending Job"];
                          d_ = snapshot.value["Pending Amount"];
                          e_ = snapshot.value["Pay pending Job"];
                          f_ = snapshot.value["Pay pending Amount"];
                          g_ = snapshot.value["Completed Job"];
                          h_ = snapshot.value["Completed Amount"];
                        });
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => CustomDialog(
                    title: "Are you sure you want to confirm the Mechanic?",
                    onClicked: () {
                      confirmJob(context, widget.index);
                      setState(() {
                        bool isConfirmed =
                            list[widget.index].mechStatus == "Confirmed";
                        widget.status = isConfirmed ? "RATE MECH." : "PENDING!";
                        widget.statusColor =
                            isConfirmed ? Colors.teal : Colors.red;
                      });
                      Navigator.pop(context);
                      showToast("Confirmed", context);
                    },
                    includeHeader: true,
                  ),
                );
                break;
              }
            case "RATE MECH.":
              {
                await rootRef
                    .child("Mechanic Collection")
                    .child(selectedUID)
                    .once()
                    .then((snapshot) {
                  preRating = snapshot.value["Rating"];
                  preReview = snapshot.value["Reviews"];
                });
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text("Rate your dealing with " +
                        list[widget.index].otherPersonName),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          "Please select some stars and give some feedback",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        StatefulBuilder(
                          builder: (context, _setState) => SmoothStarRating(
                              allowHalfRating: true,
                              onRatingChanged: (val) {
                                _setState(() {
                                  ratingNum = val;
                                });
                              },
                              starCount: 5,
                              rating: ratingNum,
                              size: 40.0,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: Colors.blue,
                              borderColor: Colors.blue,
                              spacing: 0.0),
                        ),
                        SizedBox(height: 10),
                        CupertinoTextField(
                          placeholder: "Type something here...",
                          placeholderStyle:
                              TextStyle(fontWeight: FontWeight.w400),
                          padding: EdgeInsets.all(10),
                          maxLines: 7,
                          onChanged: (e) {
                            setState(() {});
                          },
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          controller: _messageController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "NO",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromARGB(255, 22, 58, 78),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                rateMechanic(
                                    context,
                                    widget.index,
                                    _messageController.text == null
                                        ? "No review"
                                        : _messageController.text,
                                    ratingNum);

                                setState(() {
                                  widget.status = "CONFIRMED!";
                                  widget.statusColor = Colors.black12;
                                });

                                Navigator.pop(context);
                                showToast("Review Submitted", context);
                              },
                              child: Text(
                                "YES",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                break;
              }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            widget.status,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
