import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechapp/each_service.dart';

import 'libraries/carousel_slider.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class EachMechanic {
  String id,
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
      {this.id,
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
  }

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

/**
  Future<List<EachMechanic>> getAllMechanics() async {
    DatabaseReference dataRef =
        FirebaseDatabase.instance.reference().child("Mechanic Collection");

    await dataRef.once().then((snapshot) {
      var KEYS = snapshot.value.keys;
      var DATA = snapshot.value;

      mechList.clear();
      for (var index in KEYS) {
        String tempName = DATA[index]['Company Name'];
        String tempPhoneNumber = DATA[index]['Phone Number'];
        String tempStreetName = DATA[index]['Street Name'];
        String tempCity = DATA[index]['City'];
        String tempLocality = DATA[index]['Locality'];
        String tempDescription = DATA[index]['Description'];
        String tempImage = DATA[index]['Image Url'];
        String tempMechUid = DATA[index]['Mech Uid'];
        String tempLongPos = DATA[index]['LOc Longitude'];
        String tempLatPos = DATA[index]['LOc Latitude'];

        List cat = DATA[index]["Categories"];
        List specs = DATA[index]["Specifications"];
        mechList.add(EachMechanic(
            id: tempMechUid,
            name: tempName,
            locality: tempLocality,
            phoneNumber: tempPhoneNumber,
            streetName: tempStreetName,
            city: tempCity,
            descrpt: tempDescription,
            image: tempImage,
            specs: specs,
            categories: cat));
      }
    });
    return mechList;
  }

  List<EachMechanic> filteredByService(String service) {
    List<EachMechanic> _tempList = [];
    for (EachMechanic item in mechList) {
      if (item.categories.contains(service)) {
        _tempList.add(item);
      }
    }
    return _tempList;
  }
**/
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      color: primaryColor,
      child: Column(
        children: <Widget>[
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
                        ));
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
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CupertinoTextField(
                        placeholder: "Search Mechanics...",
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
              "Services",
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
                padding: const EdgeInsets.symmetric(vertical: 11),
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
                        crossAxisCount: 3)),
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
