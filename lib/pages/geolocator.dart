import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});

  @override
  _LocationStatusScreenState createState() => _LocationStatusScreenState();
}

class _LocationStatusScreenState extends State<LocationStatusScreen> {
  final double _thresholdDistance = 5.0;
  Position? _lastPosition;
  DateTime? _lastUpdateTime;
  final int _minTimeBetweenUpdates = 5;
  String _locationStatus = 'Desconocido';

  // Obtener ubicación y procesar anomalías
  Future<void> _getLocationStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus = 'Servicio de localización deshabilitado';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = 'Permiso de localización denegado';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = 'Permiso de localización denegado permanentemente';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    DateTime currentTime = DateTime.now();

    bool isMocked = position.isMocked;

    if (isMocked) {
      setState(() {
        _locationStatus = 'Ubicación FALSA detectada.';
      });
      return;
    }

    if (_lastPosition != null && _lastUpdateTime != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      int timeDifference = currentTime.difference(_lastUpdateTime!).inSeconds;

      if (distance > _thresholdDistance && timeDifference < _minTimeBetweenUpdates) {
        setState(() {
          _locationStatus = 'Ubicación FALSA detectada. Movimiento rápido de ${distance.toStringAsFixed(2)} metros en $timeDifference segundos.';
        });
      } else {
        setState(() {
          _locationStatus = 'Ubicación REAL: ${position.latitude}, ${position.longitude}';
        });
      }
    } else {
      setState(() {
        _locationStatus = 'Ubicación REAL: ${position.latitude}, ${position.longitude}';
      });
    }

    _lastPosition = position;
    _lastUpdateTime = currentTime;
  }

  // Abrir Google Maps con las coordenadas actuales
  Future<void> _openInGoogleMaps() async {
    if (_lastPosition != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${_lastPosition!.latitude},${_lastPosition!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se pudo abrir Google Maps';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubicacion en tiempo real ',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 50,
                    color: _locationStatus.contains('FALSA') ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _locationStatus,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _locationStatus.contains('FALSA') ? Colors.red : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getLocationStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Actualizar Ubicación'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _lastPosition != null ? _openInGoogleMaps : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Ver en Google Maps'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}