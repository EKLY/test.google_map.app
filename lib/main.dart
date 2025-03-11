// ignore_for_file: prefer_const_constructors

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: prefer_const_constructors

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  Map<String, Marker> markers = <String, Marker>{};
  Map<String, Polyline> polylines = <String, Polyline>{};

  _onMapCreate(GoogleMapController controller) async {
    var location = LatLng(14.0, 101.0);

    var markers = this.markers;
    markers['test2'] = Marker(
      markerId: MarkerId('test'),
      zIndex: 8,
      icon: await iconMarker(),
      position: location,
    );
    //markers['test'] =
    //    Marker(markerId: MarkerId('test'), zIndex: 8, position: location);

    var polylines = this.polylines;

    final List<LatLng> points =
        "18.6,97.2 20.4,99.9 19.5,101.3 17.6,101.1 18.5,103.2 16.3,105.0 "
                "15.7,105.6 14.3,105.3 14.2,103.1 13.3,102.3 11.8,102.7 13.6,100.7 "
                "13.9,100.1 12.3,99.9"
            .split(' ')
            .map((pair) {
      var parts = pair.split(',');
      return LatLng(double.parse(parts[0]), double.parse(parts[1]));
    }).toList();
    polylines['test'] = Polyline(
      polylineId: PolylineId('testPolyline'),
      color: Colors.red,
      width: 2,
      points: points,
    );

    setState(() {
      this.markers = markers;
      this.polylines = polylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Expanded(
              child: GoogleMap(
                polylines: Set<Polyline>.of(polylines.values),
                markers: Set<Marker>.of(markers.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(14.7, 100.7),
                  zoom: 5,
                ),
                onMapCreated: _onMapCreate,
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
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<BitmapDescriptor> iconMarker() async {
  var sMarker = 300.0;

  ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder);

  canvas.drawRect(
      Rect.fromLTWH(0, 0, sMarker, sMarker), Paint()..color = Colors.orange);

  // ----- ICON / IMG

  var number = "WVUYLJ";

  TextSpan title = TextSpan(
    style: TextStyle(color: Colors.black, fontSize: 50),
    text: number,
  );

  TextPainter tp = TextPainter(
      text: title,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr);
  tp.layout();

  final double textX = (sMarker - tp.width) / 2;
  final double textY = sMarker / 2;

  tp.paint(canvas, Offset(textX, textY));

  // ----- ARROW

  ui.Picture p = recorder.endRecording();
  ByteData? pngBytes = await (await p.toImage(sMarker.toInt(), sMarker.toInt()))
      .toByteData(format: ui.ImageByteFormat.png);
  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}
