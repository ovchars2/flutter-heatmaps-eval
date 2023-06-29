import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_heatmap/main.dart';

class LeafletHeatmapPage extends StatefulWidget {
  const LeafletHeatmapPage({Key? key}) : super(key: key);

  @override
  State<LeafletHeatmapPage> createState() => _LeafletHeatmapPageState();
}

class _LeafletHeatmapPageState extends State<LeafletHeatmapPage> {
  final _rebuildStream = StreamController<void>.broadcast();
  final data = <WeightedLatLng>[];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _rebuildStream.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    final result = await coordinatesLoadCompleter.future;
    setState(() {
      data.addAll(
        result.map(
          (e) => WeightedLatLng(LatLng(e[0], e[1]), 0.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinates Heatmap - Leaflet'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.network('http://pngimg.com/uploads/google/google_PNG19635.png', height: 48, width: 48),
        onPressed: () => Navigator.of(context).pushReplacementNamed(googleMapRoute),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(initialLat, initialLng),
          zoom: initialZoom,
          onMapEvent: (event) {
            if (event is MapEventMoveEnd) {
              _rebuildStream.add(null);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "http://{s}.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (data.isNotEmpty)
            HeatMapLayer(
              heatMapDataSource: InMemoryHeatMapDataSource(data: data),
              heatMapOptions: HeatMapOptions(
                gradient: HeatMapOptions.defaultGradient,
                minOpacity: 0.1,
              ),
              reset: _rebuildStream.stream,
            )
        ],
      ),
    );
  }
}
