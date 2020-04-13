import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechapp/libraries/custom_button.dart';
import 'package:mechapp/libraries/toast.dart';
import 'package:mechapp/utils/type_constants.dart';

class MechRequestPayment extends StatefulWidget {
  @override
  _MechRequestPaymentState createState() => _MechRequestPaymentState();
}

var rootRef = FirebaseDatabase.instance.reference();
String t6 = "--", t7 = "--";

class _MechRequestPaymentState extends State<MechRequestPayment> {
  Future getJobs() async {
    DatabaseReference dataRef = FirebaseDatabase.instance
        .reference()
        .child("All Jobs Collection")
        .child(mUID);

    await dataRef.once().then((snapshot) {
      var dATA = snapshot.value;

      setState(() async {
        t6 = dATA['Pay pending Amount'];
        t7 = dATA['Payment Request'];
      });
    });
  }

  Widget _buildFutureBuilder() {
    return Center(
      child: FutureBuilder(
        future: getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  height: double.infinity,
                  color: Color(0xb090A1AE),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "Balance: ₦" + t6,
                              style: TextStyle(
                                  fontSize: 26,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Amount",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                labelStyle: TextStyle(
                                    fontSize: 24, color: primaryColor),
                              ),
                              controller: _amountC,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Amount cannot be empty!';
                                } else if (value.length < 4) {
                                  return 'Amount must be greater than ₦999!';
                                } else if (double.parse(_amountC.text) >
                                    double.parse(t6)) {
                                  return 'Balance is ₦$t6!';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            StatefulBuilder(
                              builder: (context, _setState) {
                                return CustomButton(
                                  onPress: () {
                                    _formKey.currentState.save();
                                    _formKey.currentState.validate();

                                    _setState(() {
                                      _autoValidate = true;
                                    });

                                    if (_formKey.currentState.validate()) {
                                      processRequest(_setState);
                                      Toast.show("Request Made!", context,
                                          duration: Toast.LENGTH_SHORT,
                                          gravity: Toast.BOTTOM);
                                    }
                                  },
                                  title: "REQUEST PAYMENT  ",
                                  iconLeft: false,
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          ]),
                    ),
                  )),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController _amountC = TextEditingController();

  bool _autoValidate = false;
  void processRequest(_setState) {
    String amount = _amountC.toString().trim();

    final String ppA = (double.parse(t6) - double.parse(amount)).toString();
    final String pR = (double.parse(t7) + double.parse(amount)).toString();

    final Map<String, Object> allJobs = Map();
    allJobs.putIfAbsent("Pay pending Amount", () => ppA);
    allJobs.putIfAbsent("Payment Request", () => pR);

    Map<String, String> pRequest = Map();
    allJobs.putIfAbsent("amount", () => amount);
    allJobs.putIfAbsent("uid", () => amount);
    allJobs.putIfAbsent("date", () => thePresentTime());

    rootRef.child("Payment Request").child("Pending").child(mUID).set(pRequest);
    rootRef.child("All Jobs Collection").child(mUID).update(allJobs);

    _setState(() {
      t6 = ppA;
      t7 = pR;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Color(0xb090A1AE), child: _buildFutureBuilder());
  }
}
