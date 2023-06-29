import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_heatmap/main.dart';

class GoogleMapsHeatmapPage extends StatefulWidget {
  const GoogleMapsHeatmapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsHeatmapPage> createState() => _GoogleMapsHeatmapPageState();
}

class _GoogleMapsHeatmapPageState extends State<GoogleMapsHeatmapPage> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  final points = <WeightedLatLng>[];

  Future<void> _loadData() async {
    final result = await coordinatesLoadCompleter.future;
    setState(() {
      points.addAll(
        result.map(
          (e) => WeightedLatLng(LatLng(e[0], e[1]), weight: 0.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinates Heatmap - GMaps'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Image.asset('assets/leaflet-logo.png', width: 72),
        extendedPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        onPressed: () => Navigator.of(context).pushReplacementNamed(leafletRoute),
      ),
      body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(initialLat, initialLng),
            zoom: 12,
          ),
          heatmaps: <Heatmap>{
            if (points.isNotEmpty)
              Heatmap(
                heatmapId: const HeatmapId('strava_coords'),
                data: points,
                gradient: HeatmapGradient(
                  const <HeatmapGradientColor>[
                    HeatmapGradientColor(Colors.blue, 0.25),
                    HeatmapGradientColor(Colors.green, 0.55),
                    HeatmapGradientColor(Colors.yellow, 0.85),
                    HeatmapGradientColor(Colors.red, 1.0),
                  ],
                ),
                maxIntensity: 1,
                radius: defaultTargetPlatform == TargetPlatform.android ? 20 : 40,
              )
          }),
    );
  }
}
