import 'dart:convert';
import 'dart:developer' as developer;
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
  LatLng _center = const LatLng(13.8818018, 100.0247795); // Default location
  late LatLng _latlontest = const LatLng(0, 0);
  @override
  void initState() {
    super.initState();
    // _updateLocation();
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

  // void _updateLocation() async {
  //   Position position = await _getCurrentLocation();
  //   setState(() {
  //     _center = LatLng(position.latitude, position.longitude);
  //   });
  // }

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
              options: const {
                "location": {"lat": 13.8818018, "lon": 100.0247795},
                "zoom": 10,
              },
              eventName: [
                // JavascriptChannel(
                //   name: "click",
                //   onMessageReceived: (message) async {
                //     var jsonObj = json.decode(message.message);
                //     final location = map.currentState
                //         ?.objectCall(jsonObj["data"], "location");
                //     developer.log(location.toString(), name: 'this location');
                //     developer.log("test", name: 'this2 location');
                //   },
                // ),
                JavascriptChannel(
                  name: "ready",
                  onMessageReceived: (message) async {
                    var marker = Longdo.LongdoObject(
                      "Marker",
                      args: [
                        {
                          "lat": 13.8818018,
                          "lon": 100.0247795,
                        },
                      ],
                    );
                    developer.log(marker.toString(), name: 'this marker');
                    map.currentState?.call("Overlays.add", args: [marker]);
                  },
                ),
              ],
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // print(_center);
          //     final locationObj = map.currentState?.call("location");
          //     final locationString = locationObj.toString();
          //     Map<String, dynamic> location = json.decode(locationString);
          //     // final location = json.decode(locationObj);
          //     // print(location);
          //     // Navigator.pop(context, location);
          //     Navigator.pop(context, location);
          //   },
          //   child: const Text('Get Current Location'),
          // ),
          ElevatedButton(
            onPressed: () async {
              final locationObj = await map.currentState?.call("location");
              if (locationObj != null) {
                final locationString = locationObj.toString();
                Map<String, dynamic> location = json.decode(locationString);
                double lat = location['lat'];
                double lon = location['lon'];
                String latlon = lat.toString() + ',' + lon.toString();
                Navigator.pop(context, latlon);
              } else {
                print('Failed to retrieve location data');
              }
            },
            child: const Text('Get Current Location'),
          ),
        ],
      )),
    );
  }
}
