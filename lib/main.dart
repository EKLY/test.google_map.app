// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:maptestapp/openstreetmap.dart';

// ignore: prefer_const_constructors


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Google Maps Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<double>> _coords = [[ -71.975556, -47.0 ],[ -72.025, -47.183333 ], [ -72.333333, -47.416667 ], [ -72.55, -47.925 ], [ -72.366667, -48.116667 ], [ -72.366667, -48.316667 ], [ -72.608333, -48.45 ], [ -72.6, -48.783333 ], [ -73.466667, -49.3 ], [ -73.566667, -49.55 ], [ -73.541667, -50.15 ], [ -73.166667, -50.8 ], [ -72.383333, -50.683333 ], [ -72.45, -51.566667 ], [ -71.916667, -52.0 ], [ -70.0, -52.0 ], [ -68.55, -52.291667 ], [ -68.6, -52.666667 ], [ -68.6, -54.9 ], [ -67.966667, -54.883333 ], [ -67.116667, -54.933333 ], [ -66.833333, -55.0 ], [ -66.666667, -55.133333 ], [ -66.078333, -55.183333 ], [ -65.726667, -55.381667 ], [ -65.726667, -56.38 ], [ -67.266667, -56.38 ], [ -67.266667, -58.351667 ], [ -53.0, -58.351667 ], [ -53.0, -90.0 ], [ -90.0, -90.0 ], [ -90.0, -47.0 ], [ -71.975556, -47.0 ] ];

  @override
  Widget build(BuildContext context) {
    // create polylines;
    Set<Polyline>? _polylines = {};

    _polylines.add(
      Polyline(
        polylineId: PolylineId('testPolyline'),
        color: Colors.red,
        width: 2,
        points: [
          for (var i = 0; i < _coords.length; i++)
            LatLng(_coords[i][1], _coords[i][0]),
        ]
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          
          Expanded(
            child: GoogleMap(
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(-71.975556, -47.0),
                zoom: 0,
              ),
              trafficEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              buildingsEnabled: false,
              gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                      () => EagerGestureRecognizer())),
            ),
          ),
        ]
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
