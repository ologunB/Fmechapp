import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mechapp/utils/type_constants.dart';

import 'libraries/custom_button.dart';

class GetLocationFromAddress extends StatefulWidget {
  TextEditingController upStreetName;
  double theLat, theLong;
  GetLocationFromAddress({this.theLat, this.theLong, this.upStreetName});
  @override
  _GetLocationFromAddressState createState() => _GetLocationFromAddressState();
}

class _GetLocationFromAddressState extends State<GetLocationFromAddress> {
  LatLng locationCoordinates;
  Position currentLocation;
  GoogleMapController mapController;
  List<Marker> markers = <Marker>[];
  LatLng _center = LatLng(7.3034138, 5.143012800000008);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
      markers.add(
        Marker(
          markerId: MarkerId("Current Location"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: mName, snippet: placeMark[0].name),
          icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
          onTap: () {},
        ),
      );
      widget.upStreetName.text = placeMark[0].name;
      widget.theLong = currentLocation.longitude;
      widget.theLat = currentLocation.latitude;
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: "Street name"),
            style: TextStyle(fontSize: 18),
            readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: Text("Getting your location"),
                        content: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 30.0,
                              ),
                              markers: Set<Marker>.of(markers),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Cancel",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CustomButton(
                            title: "OK",
                            onPress: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            iconLeft: false,
                          ),
                        ],
                      ));
            },
            controller: widget.upStreetName,
          ),
        ),
        Icon(
          Icons.location_on,
          color: primaryColor,
        ),
      ],
    );
  }
}
