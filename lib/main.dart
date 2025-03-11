// ignore_for_file: prefer_const_constructors

import 'dart:ui' as ui;
import 'dart:math' as math;
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
  bool isNoNumber = false;
  Color _statusColor = Colors.red;

  var wMarker = 300.0;
  var wMarker_2 = wMarker / 2;
  var wMarker_4 = wMarker / 4;
  var wMarker_6 = wMarker / 6;
  var wMarker_8 = wMarker / 8;
  var wMarker_10 = wMarker / 10;
  var wBorderwidth = wMarker / 15;
  var wBorderwidth_2 = wBorderwidth / 2;
  var hMarker = wMarker + wMarker_2 + (isNoNumber ? 0 : wMarker_4);

  Paint sBorderFill = Paint()
    ..color = _statusColor
    ..style = PaintingStyle.fill;
  Paint sBorderStroke = Paint()
    ..color = _statusColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = wBorderwidth;

  Paint sCircleFill = Paint()..color = Colors.white;

  ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder);

  canvas.drawRect(
      Rect.fromLTWH(0, 0, wMarker, hMarker), Paint()..color = Colors.orange);

  // ----- CIRCLE

  final Offset circleCenter =
      Offset(wMarker_2, isNoNumber ? wMarker_2 * 1.8 : wMarker + wMarker_8);
  final double circleRadius = wMarker_2 - wBorderwidth;

  var mArrow = Path()
    ..moveTo(
        wMarker_2 - wMarker_4, wMarker + (isNoNumber ? wMarker_8 : wMarker_4))
    ..lineTo(
        wMarker_2 + wMarker_4, wMarker + (isNoNumber ? wMarker_8 : wMarker_4))
    ..lineTo(wMarker_2, hMarker)
    ..close();
  canvas.drawPath(mArrow, sBorderFill);

  canvas.drawCircle(circleCenter, wMarker_2, sBorderFill);
  canvas.drawCircle(circleCenter, wMarker_2 - wBorderwidth, sCircleFill);

  // ----- ICON / IMG

  var number = "สวัสดี";
  var numberHeight = wMarker / 3;

  canvas.drawRect(
      Offset(0, wMarker_2) & ui.Size(wMarker, numberHeight),
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill);

  canvas.drawRect(
      Offset(0, wMarker_2) & ui.Size(wMarker, numberHeight),
      Paint()
        ..color = Colors.red
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke);

  TextSpan title = TextSpan(
    style: TextStyle(
        color: Colors.red,
        backgroundColor: Colors.transparent,
        fontSize: numberHeight * 0.55, // ขนาดของฟอนต์สัมพันธ์กับ numberHeight
        fontWeight: FontWeight.bold),
    text: number,
  );

  TextPainter tp = TextPainter(
      text: title,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr);
  tp.layout();

  final double textX = (wMarker - tp.width) / 2;
  final double textY = wMarker_2 +
      (numberHeight - tp.height) / 2; // ทำให้ข้อความอยู่ตรงกลางแนวตั้ง

  tp.paint(canvas, Offset(textX, textY));

  // ----- ARROW

  ui.Picture p = recorder.endRecording();
  ByteData? pngBytes = await (await p.toImage(wMarker.toInt(), hMarker.toInt()))
      .toByteData(format: ui.ImageByteFormat.png);
  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}
