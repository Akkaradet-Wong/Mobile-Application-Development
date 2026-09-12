import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MyHomePage(title: 'GPS Lab'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum _MapLayer { street, satellite }

class _MyHomePageState extends State<MyHomePage> {
  static final LatLng _defaultCenter = LatLng(14.9899293, 102.1197642);

  final MapController _mapController = MapController();

  LatLng? _currentPosition;

  String _locationMessage = "";

  bool _isLoading = false;

  _MapLayer _mapLayer = _MapLayer.street;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _toggleLayer() {
    setState(() {
      _mapLayer = _mapLayer == _MapLayer.street
          ? _MapLayer.satellite
          : _MapLayer.street;
    });
  }

  void _resetToCenter() {
    _mapController.move(_currentPosition ?? _defaultCenter, 16);
  }

  Future<dynamic> _getLocation() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      setState(() {
        _locationMessage = 'Location services are disabled.';
        _isLoading = false;
      });
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        setState(() {
          _locationMessage = 'Location permissions are denied.';
          _isLoading = false;
        });
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log(
        'Location permissions are permanently denied, cannot request permissions.',
      );
      setState(() {
        _locationMessage = 'Location permissions are permanently denied.';
        _isLoading = false;
      });
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      ),
    );

    log("Current Position: $_currentPosition");
    setState(() {
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      _isLoading = false;
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentPosition!, 16);
    return _currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasLocation = _currentPosition != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_rounded),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: hasLocation
                        ? _currentPosition!
                        : _defaultCenter,
                    initialZoom: 16,
                  ),
                  children: [
                    _mapLayer == _MapLayer.satellite
                        ? TileLayer(
                            urlTemplate:
                                'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                            userAgentPackageName: 'com.example.gps_lab',
                          )
                        : TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.gps_lab',
                          ),
                    if (hasLocation)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.location_pin,
                              color: colorScheme.error,
                              size: 48,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.15),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    children: [
                      _MapControlButton(
                        icon: _mapLayer == _MapLayer.street
                            ? Icons.satellite_alt
                            : Icons.map,
                        tooltip: _mapLayer == _MapLayer.street
                            ? 'Satellite view'
                            : 'Street view',
                        onPressed: _toggleLayer,
                      ),
                      const SizedBox(height: 8),
                      _MapControlButton(
                        icon: Icons.center_focus_strong,
                        tooltip: 'Reset to center',
                        onPressed: _resetToCenter,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(
                      hasLocation
                          ? Icons.my_location
                          : Icons.location_searching,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationMessage != ""
                            ? _locationMessage
                            : "Press the button to get your location",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _getLocation,
        tooltip: 'Get Location',
        icon: const Icon(Icons.location_on),
        label: Text(_isLoading ? 'Locating...' : 'Get Location'),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 3,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
