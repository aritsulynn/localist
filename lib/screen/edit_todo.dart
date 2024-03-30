import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

class EditTodo extends StatefulWidget {
  final String docId;
  const EditTodo({super.key, required this.docId});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool _locationDataAvailable = false;

  Future<void> editTodo() async {
    try {
      await db
          .collection('users')
          .doc(user?.uid)
          .collection('todos')
          .doc(widget.docId)
          .update({
        'title': titleController.text,
        'description': descriptionController.text,
        'date': Timestamp.fromDate(DateTime.parse(dateController.text)),
        // 'location': GeoPoint(
        //   double.parse(locationController.text.split(',')[0]), // lat
        //   double.parse(locationController.text.split(',')[1]), // lon
        // ),
        'location': locationController.text.isEmpty
            ? null
            : GeoPoint(
                double.parse(locationController.text.split(',')[0]), // lat
                double.parse(locationController.text.split(',')[1]), // lon
              ),
      });
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> getTodoDetail() async {
    try {
      DocumentSnapshot documentSnapshot = await db
          .collection('users')
          .doc(user?.uid)
          .collection('todos')
          .doc(widget.docId)
          .get();
      titleController.text = documentSnapshot['title'];
      descriptionController.text = documentSnapshot['description'];
      dateController.text =
          documentSnapshot['date'].toDate().toString().split(' ')[0];
      locationController.text = formatLocation(documentSnapshot['location']);

      setState(() {
        _locationDataAvailable = true; // Set the state to true
      });
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> pick_date() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        dateController.text = date.toString().split(' ')[0]; // get date only
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTodoDetail();
  }

  Widget _formEditTodo(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              // filled: false,
              prefixIcon: Icon(Icons.title),
            ),
            // validator: (value) =>
            //     value!.isEmpty ? 'This field is required' : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 150),
              labelText: 'Short Description',
              filled: false,
              prefixIcon: Icon(Icons.description),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              filled: false,
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => pick_date(),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: locationController,
            decoration: InputDecoration(
              labelText: "Location", // Use a variable for the label text
              filled: false,
              prefixIcon: const Icon(Icons.location_on),
            ),
            onTap: () async {
              final selectedLocation =
                  await Navigator.pushNamed(context, '/map');
              if (selectedLocation != null) {
                setState(() {
                  String locationString = selectedLocation as String;
                  List<String> locationParts = locationString.split(',');
                  String lat = locationParts[0];
                  String lon = locationParts[1];
                  locationController.text = '$lat, $lon';

                  // Update the map marker with the new location
                  // double latitude = double.parse(lat);
                  // double longitude = double.parse(lon);
                  // _updateMarker(latitude, longitude);
                });
              }
            },
            // validator: (value) =>
            //     value!.isEmpty ? 'This field is required' : null,
          ),
        ],
      ),
    );
  }

  final map = GlobalKey<LongdoMapState>();

  String formatLocation(GeoPoint location) {
    return '${location.latitude}, ${location.longitude}';
  }

  LongdoMapWidget _map4() {
    if (!_locationDataAvailable) {
      return const LongdoMapWidget(
        apiKey: "75feccc26ae0b1138916c66602a2e791",
      );
    }

    final location = locationController.text.trim();

    double? latitude;
    double? longitude;

    // if location is not null
    if (location.isNotEmpty) {
      final locationParts = location.split(',');
      latitude = double.parse(locationParts[0]);
      longitude = double.parse(locationParts[1]);
    }

    developer.log(latitude.toString(), name: 'latitude');
    developer.log(longitude.toString(), name: 'longitude');

    return LongdoMapWidget(
      apiKey: "75feccc26ae0b1138916c66602a2e791",
      key: map,
      options: {
        "location": {
          "lat": latitude,
          "lon": longitude,
        },
        "zoom": 10,
      },
      eventName: [
        JavascriptChannel(
          name: "ready",
          onMessageReceived: (message) async {
            final marker = Longdo.LongdoObject(
              "Marker",
              args: [
                {
                  "lat": latitude,
                  "lon": longitude,
                },
              ],
            );
            developer.log(marker.toString(), name: 'this marker');
            // map.currentState?.call("Overlays.clear");
            map.currentState?.call("Overlays.add", args: [marker]);
          },
        ),
      ],
    );
  }

  // void _updateMarker(double? latitude, double? longitude) {
  //   final marker = Longdo.LongdoObject(
  //     "Marker",
  //     args: [
  //       {
  //         "lat": latitude,
  //         "lon": longitude,
  //       },
  //     ],
  //   );
  //   map.currentState?.call("Overlays.add", args: [marker]);
  // }

  // LongdoMapWidget _map5() {
  //   if (!_locationDataAvailable) {
  //     return const LongdoMapWidget();
  //   }

  //   final location = locationController.text.trim();

  //   double? latitude;
  //   double? longitude;
  //   if (location.isNotEmpty) {
  //     try {
  //       final locationParts = location.split(',');
  //       latitude = double.parse(locationParts[0]);
  //       longitude = double.parse(locationParts[1]);
  //     } catch (e) {
  //       developer.log('Invalid location format: $location',
  //           name: 'location_error');
  //     }
  //   }

  //   developer.log(latitude.toString(), name: 'latitude');
  //   developer.log(longitude.toString(), name: 'longitude');
  //   return LongdoMapWidget(
  //     apiKey: "75feccc26ae0b1138916c66602a2e791",
  //     key: map,
  //     options: {
  //       "location": {
  //         "lat": latitude,
  //         "lon": longitude,
  //       },
  //       "zoom": 10,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo"),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                editTodo();
                Navigator.pop(context);
              } else {
                print('Button is disabled');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: _formEditTodo(context),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 300,
                child: _map4(),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(20),
            //   child: SizedBox(
            //     height: 300,
            //     child: _map5(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
