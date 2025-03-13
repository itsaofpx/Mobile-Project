import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StadiumMapScreen extends StatefulWidget {
  final Map<String, dynamic> stadium;

  const StadiumMapScreen({super.key, required this.stadium});

  @override
  State<StadiumMapScreen> createState() => _StadiumMapScreenState();
}

class _StadiumMapScreenState extends State<StadiumMapScreen> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  Set<Marker> _markers = {};
  LatLng? _stadiumLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _getStadiumLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final hasPermission = await _requestLocationPermission();
      if (hasPermission) {
        final locationData = await _location.getLocation();
        setState(() {
          _currentLocation = locationData;
        });
        _updateMarkers();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<void> _getStadiumLocation() async {
    try {
      final GeoPoint? location = widget.stadium['location'] as GeoPoint?;
      if (location != null) {
        setState(() {
          _stadiumLocation = LatLng(location.latitude, location.longitude);
        });
        _updateMarkers();
      }
    } catch (e) {
      debugPrint('Error getting stadium location: $e');
    }
  }

  void _updateMarkers() {
    final Set<Marker> markers = {};

    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    if (_stadiumLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('stadium_location'),
          position: _stadiumLocation!,
          infoWindow: InfoWindow(title: widget.stadium['stadium_name'] ?? 'Stadium'),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _openGoogleMaps() async {
    if (_stadiumLocation != null) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${_stadiumLocation!.latitude},${_stadiumLocation!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stadium['stadium_name'] ?? 'Stadium Direction'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: _openGoogleMaps,
          ),
        ],
      ),
      body: _stadiumLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _stadiumLocation!,
                zoom: 15,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
