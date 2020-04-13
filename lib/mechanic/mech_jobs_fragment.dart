import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/libraries/custom_dialog.dart';
import 'package:mechapp/utils/type_constants.dart';

class JobModel {
  String otherPersonName,
      phoneNumber,
      amount,
      time,
      cusStatus,
      mechStatus,
      transactID,
      otherPersonUID;
  JobModel(
      {this.otherPersonName,
      this.phoneNumber,
      this.amount,
      this.time,
      this.cusStatus,
      this.mechStatus,
      this.otherPersonUID,
      this.transactID});
}

class MechJobsF extends StatefulWidget {
  @override
  _MechJobsFState createState() => _MechJobsFState();
}

var rootRef = FirebaseDatabase.instance.reference();
List<JobModel> list = [];

class _MechJobsFState extends State<MechJobsF> {
  Stream<List<JobModel>> _getJobs() async* {
    DatabaseReference dataRef =
        rootRef.child("Jobs Collection").child(userType).child(mUID);

    await dataRef.once().then((snapshot) {
      var kEYS = snapshot.value.keys;
      var dATA = snapshot.value;

      list.clear();
      for (var index in kEYS) {
        String tempName = dATA[index]['Customer Name'];
        String tempPrice = dATA[index]['Trans Amount'];
        String tempCusStatus = dATA[index]['Trans Confirmation'];
        String tempNumber = dATA[index]['Customer Number'];
        String tempTime = dATA[index]['Trans Time'];
        String tempMechStatus = dATA[index]['Mech Confirmation'];
        String tempCusUID = dATA[index]['Customer UID'];
        String tempTransactID = dATA[index]['Trans ID'];

        list.add(
          JobModel(
              otherPersonName: tempName,
              amount: tempPrice,
              phoneNumber: tempNumber,
              cusStatus: tempCusStatus,
              time: tempTime,
              mechStatus: tempMechStatus,
              otherPersonUID: tempCusUID,
              transactID: tempTransactID),
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
                                  ButtonConfirm(index: index),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.8),
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

class ButtonConfirm extends StatefulWidget {
  final int index;

  ButtonConfirm({this.index});

  @override
  _ButtonConfirmState createState() => _ButtonConfirmState();
}

class _ButtonConfirmState extends State<ButtonConfirm> {
  String status = "Confirm Job?";
  Color statusColor = Colors.blue;
  void confirmJob(int index, asetState) async {
    String received =
        "Payment has been confirmed by you. Thanks for using FABAT";

    String sent =
        "Your payment has been confirmed by the mechanic. Thanks for using FABAT";
    Map<String, String> sentMessage = Map();
    sentMessage.putIfAbsent("notification_message", () => sent);
    sentMessage.putIfAbsent("notification_time", () => thePresentTime());

    Map<String, String> receivedMessage = Map();
    receivedMessage.putIfAbsent("notification_message", () => received);
    receivedMessage.putIfAbsent("notification_time", () => thePresentTime());

    Map<String, Object> valuesToMech = Map();
    valuesToMech.putIfAbsent("Mech Confirmation", () => "Confirmed");

    Map<String, Object> valuesToCustomer = Map();
    valuesToCustomer.putIfAbsent("Mech Confirmation", () => "Confirmed");

    String transactID = list[index].transactID;
    String cusUID = list[index].otherPersonUID;
    rootRef
        .child("Notification Collection")
        .child("Mechanic")
        .child(mUID)
        .child(transactID)
        .set(receivedMessage);
    rootRef
        .child("Jobs Collection")
        .child("Mechanic")
        .child(mUID)
        .child(transactID)
        .update(valuesToMech);

    rootRef
        .child("Jobs Collection")
        .child("Customer")
        .child(cusUID)
        .child(transactID)
        .update(valuesToCustomer);
    await rootRef
        .child("Notification Collection")
        .child("Customer")
        .child(cusUID)
        .child(transactID)
        .set(sentMessage)
        .then((t) => () {
              Navigator.pop(context);
              showToast("Updated Job", context);
            });
    asetState(() {
      bool isConfirmed = list[widget.index].cusStatus == "Confirmed";
      status = isConfirmed ? "COMPLETED!" : "PENDING!";
      statusColor = isConfirmed ? Colors.black12 : Colors.red;
    });
    Navigator.pop(context);
    showToast("Updated Job", context);
  }

  @override
  Widget build(BuildContext context) {
    if (list[widget.index].cusStatus == "Confirmed" &&
        list[widget.index].mechStatus == "Confirmed") {
      status = "COMPLETED!";
      statusColor = Colors.black12;
    } else if (list[widget.index].mechStatus == "Confirmed") {
      status = "PENDING!";
      statusColor = Colors.red;
    } else {
      status = "Confirm Job?";
      statusColor = Colors.blue;
    }
    return StatefulBuilder(
      builder: (context, _setState) => Center(
        child: RaisedButton(
          color: statusColor,
          onPressed: status == "Confirm Job?"
              ? () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => CustomDialog(
                      title: "Are you sure you want to confirm the Customer?",
                      onClicked: () {
                        confirmJob(widget.index, _setState);
                      },
                      includeHeader: true,
                    ),
                  );
                }
              : () {},
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
