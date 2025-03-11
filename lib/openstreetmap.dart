import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<List<double>> _coords = [[ -71.975556, -47.0 ],[ -72.025, -47.183333 ], [ -72.333333, -47.416667 ], [ -72.55, -47.925 ], [ -72.366667, -48.116667 ], [ -72.366667, -48.316667 ], [ -72.608333, -48.45 ], [ -72.6, -48.783333 ], [ -73.466667, -49.3 ], [ -73.566667, -49.55 ], [ -73.541667, -50.15 ], [ -73.166667, -50.8 ], [ -72.383333, -50.683333 ], [ -72.45, -51.566667 ], [ -71.916667, -52.0 ], [ -70.0, -52.0 ], [ -68.55, -52.291667 ], [ -68.6, -52.666667 ], [ -68.6, -54.9 ], [ -67.966667, -54.883333 ], [ -67.116667, -54.933333 ], [ -66.833333, -55.0 ], [ -66.666667, -55.133333 ], [ -66.078333, -55.183333 ], [ -65.726667, -55.381667 ], [ -65.726667, -56.38 ], [ -67.266667, -56.38 ], [ -67.266667, -58.351667 ], [ -53.0, -58.351667 ], [ -53.0, -90.0 ], [ -90.0, -90.0 ], [ -90.0, -47.0 ], [ -71.975556, -47.0 ] ];

  @override
  Widget build(BuildContext context) {

    Set<Polyline> _polylines = {};

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('OpenStreetMaps'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(-71.975556, -47.0),
                  zoom: 2,
                  minZoom: 2,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return const Text("© OpenStreetMap contributors");
                    },
                  ),
                  PolylineLayerOptions(
                    polylineCulling: true,
                    polylines: [
                      Polyline(
                        points: [
                          for (var i = 0; i < _coords.length; i ++)
                            LatLng(_coords[i][1], _coords[i][0])
                        ],
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
