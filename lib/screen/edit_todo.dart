import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:localist/model/auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';
import 'package:longdo_maps_api3_flutter/view.dart';

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
        'location': GeoPoint(
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

  String _locationLabel = 'Location';

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
              labelText: _locationLabel, // Use a variable for the label text
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
                  getTodoDetail();
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
    // Get location from locationController, handle empty string case
    final location = locationController.text.trim();

    // Try parsing location into lat/lng if provided
    double? latitude;
    double? longitude;
    if (location.isNotEmpty) {
      try {
        final locationParts = location.split(',');
        latitude = double.parse(locationParts[0]);
        longitude = double.parse(locationParts[1]);
      } catch (e) {
        developer.log('Invalid location format: $location',
            name: 'location_error');
      }
    }

    // Use default or parsed values for latitude and longitude
    latitude ??= 13.7245995;
    longitude ??= 100.6331108;

    developer.log(latitude.toString(), name: 'latitude');
    developer.log(longitude.toString(), name: 'longitude');

    return LongdoMapWidget(
      apiKey: "75feccc26ae0b1138916c66602a2e791",
      key: map,
      options: const {
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
            map.currentState?.call("Overlays.add", args: [marker]);
          },
        ),
      ],
    );
  }

  // Future<LongdoMapWidget> _map5() async {
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

  //   latitude ??= 13.7245995;
  //   longitude ??= 100.6331108;

  //   developer.log(latitude.toString(), name: 'latitude');
  //   developer.log(longitude.toString(), name: 'longitude');

  //   return LongdoMapWidget(
  //     apiKey: "75feccc26ae0b1138916c66602a2e791",
  //     key: map,
  //     options: const {
  //       "zoom": 10,
  //     },
  //     eventName: [
  //       JavascriptChannel(
  //         name: "ready",
  //         onMessageReceived: (message) async {
  //           final marker = Longdo.LongdoObject(
  //             "Marker",
  //             args: [
  //               {
  //                 "lat": latitude,
  //                 "lon": longitude,
  //               },
  //             ],
  //           );
  //           map.currentState?.call("Overlays.add", args: [marker]);
  //         },
  //       ),
  //     ],
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
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 300,
                child: _map4(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
