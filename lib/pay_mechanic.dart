import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/rave_flutter.dart';

import 'home_fragment.dart';
import 'libraries/custom_button.dart';

class PayMechanicPage extends StatefulWidget {
  final EachMechanic mechanic;
  PayMechanicPage({Key key, @required this.mechanic}) : super(key: key);
  @override
  _PayMechanicPageState createState() => _PayMechanicPageState();
}

class _PayMechanicPageState extends State<PayMechanicPage> {
  processTransaction() async {
    // Get a reference to RavePayInitializer
    var initializer = RavePayInitializer(
        amount: 500,
        publicKey: "FLWPUBK-5782e04d7522253c79dba17b7e94e754-X",
        encryptionKey: "e4c8352d12b797aa9fefae22")
      ..country = "NG"
      ..currency = "NGN"
      ..email = "customer@email.com"
      ..fName = "Ciroma"
      ..lName = "Adekunle"
      ..narration = "payment for service" ?? ''
      ..txRef = "Text Reference"
      // ..subAccounts = subAccounts
      //  ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = true
      ..acceptCardPayments = true
      // ..acceptAchPayments = acceptAchPayments
      //  ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      //  ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..staging = true
      ..isPreAuth = true
      ..displayFee = false;

    // Initialize and get the transaction result
    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pay Mechanic"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/engineer.png"),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Ariya Raymond Shaw",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12)],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Colors.red,
                                ),
                              );
                            },
                            child: Text(
                              "Add Car",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 22, 58, 78),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black12)],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage("assets/images/description.png"),
                            height: 30,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoTextField(
                              placeholder: "Description",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: FlatButton(
                            onPressed: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => BottomSheet(
                                    onClosing: () {},
                                    builder: (context) => Text("dvddbb")),
                              );
                            },
                            child: Text(
                              "SELECT",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 22, 58, 78),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black12)],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage("assets/images/naira_icon.png"),
                            height: 30,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoTextField(
                              placeholder: "Amount",
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Ensure you have agreed on Job description and price with the mechanic before you proceed with payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                CustomButton(
                  title: "   PROCEED   ",
                  onPress: () {
                    processTransaction();
                  },
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  iconLeft: false,
                ),
              ],
            ),
          ),
        ));
  }
}
