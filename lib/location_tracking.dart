import 'dart:async';

import 'package:admin_app/google_map_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

import 'driverlist.dart';
import 'profileScreen.dart';

class LocationTracking extends StatefulWidget {
  const LocationTracking(
      {Key? key,
      required this.firestore,
      required this.firebaseAuth,
      required this.firebaseStorage})
      : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  LatLng sourceLocation = LatLng(21.51851, 39.181057);
  LatLng destinationLatlng = LatLng(21.49407, 39.23902);

  bool isLoading = false;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _marker = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;

  StreamSubscription<LocationData>? subscription;

  LocationData? currentLocation;
  LocationData? destiationLocation;
  Location? location;

  @override
  void initState() {
    super.initState();

    location = Location();
    polylinePoints = PolylinePoints();

    subscription = location!.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    // currentLocation = await location!.getLocation();
    currentLocation = LocationData.fromMap({
      "latitude": sourceLocation.latitude,
      "longitude": sourceLocation.longitude,
    });

    destiationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    var destinationPosition =
        LatLng(destinationLatlng.latitude, destinationLatlng.longitude);

    _marker.add(Marker(
      markerId: MarkerId('sourcePosition'),
      position: sourceposition,
    ));

    _marker.add(Marker(
      markerId: MarkerId('destinationPosition'),
      position: destinationPosition,
    ));

    setPolylinesInMap();
  }

  void setPolylinesInMap() async {
    var result = await polylinePoints!.getRouteBetweenCoordinates(
        GoogleMapApi().url,
        PointLatLng(currentLocation!.latitude ?? 0.0,
            currentLocation!.longitude ?? 0.0),
        PointLatLng(destinationLatlng.latitude, destinationLatlng.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blueAccent,
        points: polylineCoordinates,
      ));
    });
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    setState(() {
      _marker
          .removeWhere((marker) => marker.markerId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 20,
      tilt: 80,
      bearing: 30,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => driverlist(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                },
              );
            },
          ),
          backgroundColor: Color(0xff6b88ef),
          title: Center(
            child: Text(
              "Track Driver",
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profileScreen(
                            firestore: widget.firestore,
                            firebaseAuth: widget.firebaseAuth,
                            firebaseStorage: widget.firebaseStorage)),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30.0,
                ))
          ],
        ),
        body: GoogleMap(
          markers: _marker,
          polylines: _polylines,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            showLocationPins();
          },
        ),
      ),
    );
  }
}
