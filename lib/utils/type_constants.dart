import 'package:flutter/material.dart';

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

List<bool> specifyBoolList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

List<bool> categoryBoolList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
