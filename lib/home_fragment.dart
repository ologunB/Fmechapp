import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechapp/each_service.dart';
import 'package:mechapp/utils/type_constants.dart';
import 'package:mechapp/view_mech_profile.dart';

import 'libraries/carousel_slider.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class EachMechanic {
  final String uid,
      name,
      locality,
      descrpt,
      email,
      phoneNumber,
      image,
      jobsDone,
      city,
      rating,
      streetName;
  List categories, specs;
  var mLat, mLong;

  EachMechanic(
      {this.uid,
      this.name,
      this.locality,
      this.categories,
      this.specs,
      this.descrpt,
      this.email,
      this.phoneNumber,
      this.image,
      this.jobsDone,
      this.mLat,
      this.city,
      this.mLong,
      this.rating,
      this.streetName});
}

class _HomeFragmentState extends State<HomeFragment> {
  var theAddress = "---";

  LatLng locationCoordinates;
  Position currentLocation;

  @override
  void initState() {
    super.initState();
    getUserLocation();
    getProfiles();
  }

  bool closePresent = false;
  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      locationCoordinates =
          LatLng(currentLocation.latitude, currentLocation.longitude);
    });

    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);

    setState(() {
      theAddress = placeMark[0].name + ", " + placeMark[0].locality;
    });
  }

  List<EachMechanic> mechList = [];
  List<EachMechanic> sortedList = [];
  bool showService = true;
  bool showSearch = false;

  var rootRef =
      FirebaseDatabase.instance.reference().child("Mechanic Collection");

  Map dATA = {};

  Future<Map> getProfiles() async {
    await rootRef.once().then((snapshot) {
      dATA = snapshot.value;
    });
    return dATA;
  }

  void onSearchMechanic(String val) {
    if (mechList != null) {
      val = val.trim();
      if (val.isNotEmpty) {
        sortedList.clear();
        for (EachMechanic item in mechList) {
          if (item.name.toUpperCase().contains(val.toUpperCase())) {
            sortedList.add(item);
            print(sortedList[0].rating);
          }
        }
        setState(() {
          closePresent = true;
          showService = false;
          showSearch = true;
          textServices = "Found Mechanics";
        });
      } else {
        setState(() {
          closePresent = false;

          showService = true;
          showSearch = false;
          textServices = "Services";
          FocusScope.of(context).unfocus();
        });
      }
    } else {
      showMiddleToast("Geting mechanics", context);
    }
  }

  String textServices = "Services";

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      color: primaryColor,
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: getProfiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var kEYS = dATA.keys;

                print(dATA);
                mechList.clear();
                for (var key in kEYS) {
                  String tempName = dATA[key]['Company Name'];
                  String tempPhoneNumber = dATA[key]['Phone Number'];
                  String tempStreetName = dATA[key]['Street Name'];
                  String tempCity = dATA[key]['City'];
                  String tempLocality = dATA[key]['Locality'];
                  String tempDescription = dATA[key]['Description'];
                  String tempImage = dATA[key]['Image Url'];
                  String tempMechUid = dATA[key]['Mech Uid'];
                  String tempRating = dATA[key]['Rating'];
                  var tempLongPos =
                      double.parse(dATA[key]['LOc Longitude'].toString());
                  var tempLatPos =
                      double.parse(dATA[key]['Loc Latitude'].toString());

                  List cat = dATA[key]["Categories"];
                  List specs = dATA[key]["Specifications"];
                  mechList.add(EachMechanic(
                      uid: tempMechUid,
                      name: tempName,
                      locality: tempLocality,
                      phoneNumber: tempPhoneNumber,
                      streetName: tempStreetName,
                      city: tempCity,
                      descrpt: tempDescription,
                      image: tempImage,
                      specs: specs,
                      categories: cat,
                      mLat: tempLatPos,
                      mLong: tempLongPos,
                      rating: tempRating));
                }
                return Container();
              }
              return Container();
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8.0, right: 8.0),
            child: CarouselSlider(
              height: MediaQuery.of(context).size.height / 4,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              pauseAutoPlayOnTouch: Duration(seconds: 5),
              items: [
                "assets/images/cc1.jpg",
                "assets/images/cc2.jpg",
                "assets/images/cc3.jpg",
                "assets/images/cc4.jpg",
                "assets/images/cc6.jpg",
                "assets/images/cc7.jpg",
                "assets/images/cc5.jpg"
              ].map((i) {
                return Builder(
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        backgroundBlendMode: BlendMode.dstOut,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                          image: AssetImage(""),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            child: Image(
                              image: AssetImage(i),
                              fit: BoxFit.fill,
                              color: Colors.black38,
                              colorBlendMode: BlendMode.dstOut,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      backgroundColor: Colors.blueAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                              ),
                              subtitle: Text("",
                                  style: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueAccent)),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              Text(
                theAddress,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12)],
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CupertinoTextField(
                        placeholder: "Search Mechanics...",
                        onChanged: onSearchMechanic,
                        clearButtonMode: OverlayVisibilityMode.editing,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              textServices,
              style: TextStyle(
                  fontSize: 20, color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12)],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 11),
                child: Stack(
                  children: <Widget>[
                    Visibility(
                      visible: showService,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: httpServicesList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => EachService(
                                    title: httpServicesList[index].typeTitle,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          httpServicesList[index].typeImageUrl,
                                      height: 40,
                                      width: 40,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      httpServicesList[index].typeTitle,
                                      style: TextStyle(
                                          fontSize: 20, color: primaryColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                      ),
                    ),
                    Visibility(
                      visible: showSearch,
                      child: ListView.builder(
                        itemCount: sortedList.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ViewMechProfile(
                                    mechanic: mechList[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12)
                                    ],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                    child: ListTile(
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.call,
                                            color: primaryColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              sortedList[index].phoneNumber,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Icon(
                                            Icons.message,
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
/*
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: .0),
                                    child: Text(
                                      "4.5KM Away",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
*/
                                    ],
                                  ),
                                  title: Text(
                                    sortedList[index].name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  leading: CachedNetworkImage(
                                    imageUrl: sortedList[index].image,
                                    height: 48,
                                    width: 48,
                                    placeholder: (context, url) => Image(
                                      image: AssetImage(
                                          "assets/images/person.png"),
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          "assets/images/person.png"),
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ServiceType {
  String typeTitle, typeImageUrl;

  ServiceType({this.typeTitle, this.typeImageUrl});
}

List<ServiceType> httpServicesList = [
  ServiceType(
      typeTitle: "Accidented Vehicle",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Faccidentedve.png?alt=media&token=76e63037-0d2a-4678-b627-42017698238e"),
  ServiceType(
      typeTitle: "Air Conditioner",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Faircondition.png?alt=media&token=424aaf59-5948-4b7a-8bcf-038d6a8f0d49"),
  ServiceType(
      typeTitle: "Brake System",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fbrakesystem.png?alt=media&token=0c40ecb2-be53-4810-b2e1-9c6ad9052baf"),
  ServiceType(
      typeTitle: "Brake pad replacement",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fbrakepad.png?alt=media&token=efefb1c3-e589-4d42-8c45-1b067f422632"),
  ServiceType(
      typeTitle: "Call Us",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fcallus.png?alt=media&token=809bb036-c523-4528-9681-ed69cc3d52d8"),
  ServiceType(
      typeTitle: "Car Scan",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fcarscan.png?alt=media&token=4515fc81-20e6-4fd2-ace8-3f98c55ba224"),
  ServiceType(
      typeTitle: "Car Tint",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fcartint.png?alt=media&token=7f47bcea-3eb6-4dca-8cd9-db02b8080172"),
  ServiceType(
      typeTitle: "Electrician",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Felectrician.png?alt=media&token=6c6ed46b-b6d8-4982-9461-6ced94739f92"),
  ServiceType(
      typeTitle: "Engine Expert",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fengineexpert.png?alt=media&token=e164f9f0-b6ee-44da-aa73-03e732454d70"),
  ServiceType(
      typeTitle: "Exhaust System",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fexhaustsys.png?alt=media&token=7cf46711-f422-47eb-9e83-a7663439c125"),
  ServiceType(
      typeTitle: "Locking & Keys/Security",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Flockingkey.png?alt=media&token=e833e814-2029-4058-8164-aa5144c0045c"),
  ServiceType(
      typeTitle: "Oil & Filter Change",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Foilfilter.png?alt=media&token=45347067-f0bd-4ac1-b0cf-aaa74863fd77"),
  ServiceType(
      typeTitle: "Painter",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fpainterr.png?alt=media&token=e9295378-aa59-4886-bb45-49bdc4282b0c"),
  ServiceType(
      typeTitle: "Panel Beater",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fpanelbeater.png?alt=media&token=74a19b1d-58f7-4caa-b084-8bbca954bee8"),
  ServiceType(
      typeTitle: "Tow trucks",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Ftowserv.png?alt=media&token=143b603a-c356-4b1b-95ce-162be46fa506"),
  ServiceType(
      typeTitle: "Upholstery & Interior",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Finterior.png?alt=media&token=1e8c9998-b419-4209-b8a7-6f4f8597a97e"),
  ServiceType(
      typeTitle: "Wheel Balancing & Alignment",
      typeImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/mechanics-b3612.appspot.com/o/service%20images%2Fwheelbala.png?alt=media&token=a1543d44-a60b-4629-a65f-f604908a314a"),
];
