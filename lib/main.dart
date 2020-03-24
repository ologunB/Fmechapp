import 'package:flutter/material.dart';
import 'package:mechapp/cus_main.dart';
import 'package:mechapp/log_in.dart';
import 'package:mechapp/mechanic/mech_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWrapper(),
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: Color.fromARGB(255, 22, 58, 78),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyWrapper extends StatefulWidget {
  @override
  _MyWrapperState createState() => _MyWrapperState();
}

class _MyWrapperState extends State<MyWrapper> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> type;

  @override
  void initState() {
    super.initState();

    type = _prefs.then((prefs) {
      return (prefs.getString('type'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: type,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String _type = snapshot.data;
            if (_type == "Mechanic") {
              return MechMainPage();
            } else if (_type == "Customer") {
              return CusMainPage();
            } else {
              return LogOn();
            }
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/app_back.jpg",
                    ),
                    fit: BoxFit.fill,),
              ),
            ),
          );
        });
  }
}

/*
Container(
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(
"assets/images/app_back.jpg",
),
fit: BoxFit.fill),
),
child: Center(
child: Container(
width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height,
decoration: BoxDecoration(
image: DecorationImage(
fit: BoxFit.fill,
image: AssetImage("assets/images/app_back.jpg"),
),
),
),
),
)*/
