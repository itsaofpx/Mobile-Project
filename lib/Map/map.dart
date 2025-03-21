import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Add this package for reverse geocoding

class StadiumMapScreen extends StatefulWidget {
  final Map<String, dynamic> stadium;

  const StadiumMapScreen({super.key, required this.stadium});

  @override
  State<StadiumMapScreen> createState() => _StadiumMapScreenState();
}

class _StadiumMapScreenState extends State<StadiumMapScreen> {
  late final MapController _mapController;
  late final LatLng _stadiumLocation;
  LatLng? _currentLocation;
  String _currentLocationName = "Fetching location...";
  bool _isLocationFetched = false;
  double _currentZoom = 15.0;
  static const double _minZoom = 3.0;
  static const double _maxZoom = 18.0;
  static const double _zoomStep = 1.0;

  String _selectedMapStyle = 'Standard';
  final List<String> _mapStyles = ['Standard', 'Terrain'];

  @override
  void initState() {
    _mapController = MapController();
    _stadiumLocation = LatLng(
      widget.stadium['stadium_location']?.latitude ?? 0.0,
      widget.stadium['stadium_location']?.longitude ?? 0.0,
    );
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
          timeLimit: const Duration(seconds: 15),
        );

        // Get address from coordinates using reverse geocoding
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            String locationName = place.name ?? '';
            String locality = place.locality ?? '';
            String address = locationName.isNotEmpty ? locationName : locality;

            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
              _currentLocationName =
                  address.isNotEmpty ? address : "Current Location";
              _isLocationFetched = true;
              _mapController.move(_currentLocation!, _currentZoom);
            });
          } else {
            _setMockLocation();
          }
        } catch (e) {
          _setMockLocation();
        }
      } else {
        _setMockLocation();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
      }
    } catch (e) {
      _setMockLocation();
    }
  }

  void _setMockLocation() {
    // Use Kasetsart University as mock location
    setState(() {
      _currentLocation = const LatLng(13.8466, 100.5698);
      _currentLocationName = "Kasetsart University";
      _isLocationFetched = true;
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + _zoomStep).clamp(_minZoom, _maxZoom);
    _mapController.move(_mapController.camera.center, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - _zoomStep).clamp(_minZoom, _maxZoom);
    _mapController.move(_mapController.camera.center, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  String getTileUrl() {
    switch (_selectedMapStyle) {
      case 'Terrain':
        return 'https://tile.opentopomap.org/{z}/{x}/{y}.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.stadium['stadium_name'] ?? 'Stadium Location',
          style: const TextStyle(
            color: Color(0xFF1A1F36),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1F36)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Current Location Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5850EC).withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFF5850EC).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      size: 18,
                      color: Color(0xFF5850EC),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isLocationFetched
                            ? "Your location: $_currentLocationName"
                            : "Unable to fetch current location",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1F36),
                        ),
                      ),
                    ),
                    if (!_isLocationFetched)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF5850EC),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _stadiumLocation,
                    initialZoom: _currentZoom,
                    minZoom: _minZoom,
                    maxZoom: _maxZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: getTileUrl(),
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _stadiumLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF5850EC),
                            size: 40,
                          ),
                        ),
                        if (_currentLocation != null)
                          Marker(
                            point: _currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.person_pin_circle,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.stadium['stadium_name'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1F36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFF5850EC),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.stadium['stadium_address'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF4A5568),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _mapController.move(
                                _stadiumLocation,
                                _currentZoom,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5850EC),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.center_focus_strong,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Center on Stadium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _currentLocation != null
                                    ? () {
                                      _mapController.move(
                                        _currentLocation!,
                                        _currentZoom,
                                      );
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'My Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    DropdownButton<String>(
                      value: _selectedMapStyle,
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: const Color(0xFF5850EC),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMapStyle = newValue!;
                        });
                      },
                      items:
                          _mapStyles.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: MediaQuery.of(context).size.height * 0.4,
            bottom: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                _ZoomButton(
                  icon: Icons.add,
                  onPressed: _currentZoom < _maxZoom ? _zoomIn : null,
                ),
                const SizedBox(height: 8),
                _ZoomButton(
                  icon: Icons.remove,
                  onPressed: _currentZoom > _minZoom ? _zoomOut : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ZoomButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color:
                  onPressed != null
                      ? const Color(0xFF1A1F36)
                      : const Color(0xFFBBBBBB),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
