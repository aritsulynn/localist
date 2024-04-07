import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';
import 'dart:async';

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<MapSelection> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> {
  double latitude = 0.0;
  double longitude = 0.0;
  final Completer<void> _locationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _updateLocation().then((_) => _locationCompleter.complete());
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

  Future<void> _updateLocation() async {
    try {
      final Position position = await _getCurrentLocation();
      // Check if the widget is mounted before updating the state
      if (!mounted) return;
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      developer.log('Latitude: $latitude, Longitude: $longitude');
    } catch (e) {
      // Handle the error here
      developer.log('Error getting location: $e');
      // You can display a user-friendly error message or perform other error-handling actions
    }
  }

  final map = GlobalKey<LongdoMapState>();
  final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
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
                developer.log('Failed to retrieve location data');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _locationCompleter.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: LongdoMapWidget(
                    apiKey: "75feccc26ae0b1138916c66602a2e791",
                    key: map,
                    options: {
                      "location": {"lat": latitude, "lon": longitude},
                      "zoom": 10,
                    },
                    eventName: [],
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     final locationObj =
                //         await map.currentState?.call("location");
                //     if (locationObj != null) {
                //       final locationString = locationObj.toString();
                //       Map<String, dynamic> location =
                //           json.decode(locationString);
                //       double lat = location['lat'];
                //       double lon = location['lon'];
                //       String latlon = lat.toString() + ',' + lon.toString();
                //       Navigator.pop(context, latlon);
                //     } else {
                //       print('Failed to retrieve location data');
                //     }
                //   },
                //   child: const Text('Get Current Location'),
                // ),
              ],
            );
          }
        },
      ),
    );
  }
}
