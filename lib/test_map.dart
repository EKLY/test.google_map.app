import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyPage());
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, Marker> markers = <String, Marker>{};

  _onMapCreate(GoogleMapController controller) async {
    markers['test2'] = Marker(
      markerId: const MarkerId('test'),
      zIndex: 8,
      icon: await iconMarker(),
      position: const LatLng(14.0, 101.0),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: Set<Marker>.of(markers.values),
      initialCameraPosition: const CameraPosition(target: LatLng(14.7, 100.7), zoom: 5),
      onMapCreated: _onMapCreate,
    );
  }
}

Future<BitmapDescriptor> iconMarker() async {
  ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder);

  canvas.drawRect(const Rect.fromLTWH(0, 0, 300, 100), Paint()..color = Colors.orange);

  TextSpan title = const TextSpan(style: TextStyle(fontSize: 70), text: "Thailand");

  TextPainter(text: title, textDirection: TextDirection.ltr)
    ..layout()
    ..paint(canvas, const Offset(10, 10));

  ui.Picture p = recorder.endRecording();
  ByteData? pngBytes = await (await p.toImage(300, 100)).toByteData(format: ui.ImageByteFormat.png);
  Uint8List data = Uint8List.view(pngBytes!.buffer);

  return BitmapDescriptor.fromBytes(data);
}
