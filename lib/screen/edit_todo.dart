import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:localist/model/auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

class EditScreen extends StatefulWidget {
  final String docId;
  const EditScreen({super.key, required this.docId});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
        'location': locationController.text,
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
          // TextFormField(
          //   controller: locationController,
          //   decoration: const InputDecoration(
          //     labelText: 'Location',
          //     filled: false,
          //     prefixIcon: Icon(Icons.location_on),
          //   ),
          // ),
        ],
      ),
    );
  }

  final map = GlobalKey<LongdoMapState>();

  String formatLocation(GeoPoint location) {
    return '${location.latitude}, ${location.longitude}';
  }

  Object? marker;

  // Future<Widget> _map() async {
  //   await getTodoDetail();
  //   String location = locationController.text;
  //   String latitude = "13.7245995";
  //   String longitude = "100.6331108";
  //   if (location != '') {
  //     latitude = location.split(',')[0];
  //     longitude = location.split(',')[1];
  //   }
  //   developer.log(location, name: 'location');
  //   // developer.log(latitude, name: 'latitude');
  //   return SizedBox(
  //     height: 300,
  //     child: LongdoMapWidget(
  //       apiKey: "75feccc26ae0b1138916c66602a2e791",
  //       key: map,
  //       eventName: [
  //         JavascriptChannel(
  //           name: "ready",
  //           onMessageReceived: (message) {
  //             var marker = Longdo.LongdoObject(
  //               "Marker",
  //               args: [
  //                 {
  //                   "lat": latitude,
  //                   "lon": longitude,
  //                 },
  //               ],
  //             );
  //             map.currentState?.call("Overlays.add", args: [marker]);
  //           },
  //         ),
  //       ],
  //       options: {
  //         "location": {"lat": latitude, "lon": longitude},
  //         "zoom": 10,
  //       },
  //     ),
  //   );
  // }

  Future<Widget> _map2() async {
    await getTodoDetail();
    String location = locationController.text;
    String latitude = "13.7245995";
    String longitude = "100.6331108";
    if (location != '') {
      latitude = location.split(',')[0];
      longitude = location.split(',')[1];
    }
    developer.log(location, name: 'location');
    // developer.log(latitude, name: 'latitude');
    String apiKey = "75feccc26ae0b1138916c66602a2e791";
    // [{lat: 13.880858851674915, lon:  100.01908937169776}]}
    return SizedBox(
      height: 300,
      child: LongdoMapWidget(
        apiKey: apiKey,
        key: map,
        eventName: [
          JavascriptChannel(
            name: "ready",
            onMessageReceived: (message) async {
              var marker = Longdo.LongdoObject(
                "Marker",
                args: [
                  {
                    "lat": latitude,
                    "lon": longitude,
                  },
                ],
              );
              developer.log(marker.toString(), name: 'this marker');
              map.currentState?.call("Overlays.add", args: [marker]);
            },
          ),
        ],
        options: {
          "location": {"lat": latitude, "lon": longitude},
          "zoom": 10,
        },
      ),
    );
  }

  Stream<Widget> _map3() async* {
    await getTodoDetail();
    // how to delay

    String location = locationController.text;
    String latitude = "13.7245995";
    String longitude = "100.6331108";
    if (location != '') {
      latitude = location.split(',')[0];
      longitude = location.split(',')[1];
    }
    developer.log(location, name: 'location');
    // developer.log(latitude, name: 'latitude');
    String apiKey = "75feccc26ae0b1138916c66602a2e791";
    // [{lat: 13.880858851674915, lon:  100.01908937169776}]}
    await Future.delayed(Duration(seconds: 3));
    yield SizedBox(
      height: 300,
      child: LongdoMapWidget(
        apiKey: apiKey,
        key: map,
        options: {
          "location": {"lat": latitude, "lon": longitude},
          "zoom": 10,
        },
        eventName: [
          JavascriptChannel(
            name: "click",
            onMessageReceived: (message) async {
              var marker = Longdo.LongdoObject(
                "Marker",
                args: [
                  {
                    "lat": latitude,
                    "lon": longitude,
                  },
                ],
              );
              developer.log(marker.toString(), name: 'this marker');
              map.currentState?.call("Overlays.add", args: [marker]);
            },
          ),
        ],
      ),
    );
  }

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
            // Text(locationController.text),
            StreamBuilder<Widget>(
              stream: _map3(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            // FutureBuilder(
            //     future: _map2(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return snapshot.data!;
            //       } else if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else {
            //         return const CircularProgressIndicator();
            //       }
            //     }),
          ],
        ),
      ),
    );
  }
}
