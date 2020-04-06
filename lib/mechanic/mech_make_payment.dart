import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/libraries/custom_button.dart';
import 'package:mechapp/libraries/toast.dart';
import 'package:mechapp/log_in.dart';
import 'package:mechapp/utils/type_constants.dart';

var rootRef = FirebaseDatabase.instance.reference();
String t5 = "--", t8 = "--";

class MechMakePayment extends StatefulWidget {
  @override
  _MechMakePaymentState createState() => _MechMakePaymentState();
}

class _MechMakePaymentState extends State<MechMakePayment> {
  Future getJobs() async {
    DatabaseReference dataRef = FirebaseDatabase.instance
        .reference()
        .child("All Jobs Collection")
        .child(mUID);

    await dataRef.once().then((snapshot) {
      var dATA = snapshot.value;

      setState(() async {
        t5 = dATA['Cash Payment Debt'];
        t8 = dATA['Completed Amount'];
      });
    });
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: FutureBuilder(
        future: getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              height: double.infinity,
              color: Color(0xb090A1AE),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(children: <Widget>[
                    Text(
                      "Debt: ₦$t5",
                      style: TextStyle(
                          fontSize: 26,
                          color: primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      onPress: () {
                        Toast.show("Make Payment bar open!", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      },
                      title: "PAY ADMIN   ",
                      iconLeft: false,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  void doAfterSuccess(String serverData) {
    final String ppA = "0";
    final String cA = ((double.parse(t8) * 5) + double.parse(t5)).toString();

    final Map<String, Object> allJobs = Map();
    allJobs.putIfAbsent("Cash Payment Debt", () => ppA);
    allJobs.putIfAbsent("Completed Amount", () => cA);

    String made =
        "You sent a payment of $t5 to the FABAT ADMIN, your debt has been cleared.";

    final Map<String, String> sentMessage = Map();
    sentMessage.putIfAbsent("notification_message", () => made);
    sentMessage.putIfAbsent("notification_time", () => thePresentTime());

    rootRef
        .child("Notification Collection")
        .child("Mechanic")
        .child(mUID)
        .child(mUID)
        .set(sentMessage);

    rootRef.child("All Jobs Collection").child(mUID).update(allJobs);

    // startActivity(new Intent(MakePaymentActivity.this, MechMainActivity.class));
    showToast("Payment Complete", context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Color(0xb090A1AE), child: _buildFutureBuilder());
  }
}
