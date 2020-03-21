import 'package:firebase_database/firebase_database.dart';

class Car {
  String _id;
  String _brand;
  String _model;
  String _date;
  String _regNo;
  String _img;

  Car(this._id, this._brand, this._model, this._date, this._regNo, this._img);

  String get brand => _brand;

  String get model => _model;

  String get date => _date;

  String get regNo => _regNo;

  String get id => _id;
  String get img => _img;

  Car.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _brand = snapshot.value['car_brand'];
    _model = snapshot.value['car_model'];
    _date = snapshot.value['car_date'];
    _regNo = snapshot.value['car_num'];
    _img = snapshot.value['car_image'];
  }

  Car.map(dynamic obj) {
    // this._id = obj['id'];
    this._brand = obj['car_brand'];
    this._model = obj['car_model'];
    this._date = obj['car_date'];
    this._regNo = obj['car_num'];
    this._img = obj['car_image'];
  }
}

class Mechanic {
  //categories, specs
  String id,
      name,
      locality,
      descrpt,
      email,
      phoneNumber,
      image,
      jobsDone,
      mLat,
      city,
      mLong,
      rating,
      streetName;

  Mechanic(
      this.id,
      this.name,
      this.locality,
      this.descrpt,
      this.email,
      this.phoneNumber,
      this.image,
      this.jobsDone,
      this.mLat,
      this.city,
      this.mLong,
      this.rating,
      this.streetName);

/*  String get brand => _id;

  String get model => _name;

  String get date => _locality;

  String get regNo => _descrpt;

  String get id => _id;
  String get img => _email;
  String get brand => _phoneNumber;

  String get model => _image;

  String get date => _jobsDone;

  String get regNo => _mLat;

  String get id => _city;
  String get img => _mLong;
  String get brand => _rating;

  String get model => _streetName;

  Mechanic.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _brand = snapshot.value['car_brand'];
    _model = snapshot.value['car_model'];
    _date = snapshot.value['car_date'];
    _regNo = snapshot.value['car_num'];
    _img = snapshot.value['car_image'];
  }

  Mechanic.map(dynamic obj) {
    // this._id = obj['id'];
    this._brand = obj['car_brand'];
    this._model = obj['car_model'];
    this._date = obj['car_date'];
    this._regNo = obj['car_num'];
    this._img = obj['car_image'];
  }*/
}

class EachJob {
  String id;
  String jobsDone;

  EachJob(this.jobsDone);

  String get name => jobsDone;

  EachJob.fromSnapshot(DataSnapshot snapshot) {
    jobsDone = snapshot.value["Completed Amount"];
  }
}

class ShopItem {
  String name, price, soldBy, desc, image, email, number, itemID;
  ShopItem(
      {this.name,
      this.price,
      this.soldBy,
      this.desc,
      this.image,
      this.email,
      this.number,
      this.itemID});
}
