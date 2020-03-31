import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String mUID, mEmail, mName, userType;

Widget emptyList(String typeOf) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.hourglass_empty,
          color: Colors.white,
          size: 30,
        ),
        Text(
          "No $typeOf!",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

List<String> specifyList = [
  "Audi",
  "BMW",
  "Chrysler",
  "Dodge",
  "Ford",
  "Honda",
  "Hyundai",
  "Jeep",
  "Kia",
  "Mazda",
  "Mercedes Benz",
  "Nissan",
  "Peugeot",
  "Porsche",
  "RAM",
  "Range Rover",
  "Suzuki",
  "Toyota",
  "Volkswagen"
];
List<String> categoryList = [
  "Accidented Vehicle",
  "Air Conditioner",
  "Brake System",
  "Brake pad replacement",
  "Call Us",
  "Car Scan",
  "Car Tint",
  "Electrician",
  "Engine Expert",
  "Exhaust System",
  "Locking & Keys/Security",
  "Oil & Filter Change",
  "Painter",
  "Panel Beater",
  "Tow trucks",
  "Upholstery & Interior",
  "Wheel Balancing & Alignment",
];

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

String randomString() {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < 12; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

String thePresentTime() {
  return DateFormat("MMM d, yyyy HH:mm:ss a").format(DateTime.now());
}
