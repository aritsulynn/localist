import 'dart:convert';
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

class mapTest extends StatefulWidget {
  const mapTest({super.key});

  @override
  State<mapTest> createState() => _mapTestState();
}

class _mapTestState extends State<mapTest> {
  LatLng _center = LatLng(13.8818018, 100.0247795); // Default location
  late LatLng _latlontest = LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    _updateLocation();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _updateLocation() async {
    Position position = await _getCurrentLocation();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void _updateNewLocation() async {
    Position position = await _getCurrentLocation();
    setState(() {
      _latlontest = LatLng(position.latitude, position.longitude);
    });
  }

  final map = GlobalKey<LongdoMapState>();
  final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 2,
            child: LongdoMapWidget(
              apiKey: "75feccc26ae0b1138916c66602a2e791",
              key: map,
              options: {
                "location": {"lat": 13.8818018, "lon": 100.0247795},
                "zoom": 10,
              },
              eventName: [
                JavascriptChannel(
                  name: "Click",
                  onMessageReceived: (message) async {
                    var jsonObj = json.decode(message.message);
                    final location = await map.currentState
                        ?.objectCall(jsonObj["data"], "location");
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // _updateLocation();
              // print(_center);
              final location = map.currentState?.call("location");
              print("Location: ");
              print(await location);
            },
            child: const Text('Get Current Location'),
          ),
        ],
      )),
    );
  }
}
