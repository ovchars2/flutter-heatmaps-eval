import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_heatmap/google_maps_heatmap_page.dart';

import 'leaflet_heatmap_page.dart';

Completer<List<List>> coordinatesLoadCompleter = Completer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var str = await rootBundle.loadString('assets/strava_coords.json');
  coordinatesLoadCompleter.complete(
    List<List<dynamic>>.from(jsonDecode(str)),
  );

  runApp(const MyApp());
}

const leafletRoute = 'leaflet';
const googleMapRoute = 'googleMap';
const initialLat = 46.9659;
const initialLng = 31.9844;
const initialZoom = 12.0;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heatmap By Coordinates',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        leafletRoute: (ctx) => const LeafletHeatmapPage(),
        googleMapRoute: (ctx) => const GoogleMapsHeatmapPage(),
      },
      initialRoute: googleMapRoute,
    );
  }
}
