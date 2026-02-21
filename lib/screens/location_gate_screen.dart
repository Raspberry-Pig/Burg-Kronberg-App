import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum _GateStatus {
  checking,
  allowed,
  servicesDisabled,
  permissionDenied,
  permissionDeniedForever,
  outsideArea,
  error,
}

class LocationGateScreen extends StatefulWidget {
  final Widget child;

  // Burg Kronberg (can be fine-tuned if needed).
  final double castleLatitude;
  final double castleLongitude;
  final double radiusMeters;

  const LocationGateScreen({
    super.key,
    required this.child,
    this.castleLatitude = 50.1810472,
    this.castleLongitude = 8.50705,
    this.radiusMeters = 250,
  });

  @override
  State<LocationGateScreen> createState() => _LocationGateScreenState();
}

class _LocationGateScreenState extends State<LocationGateScreen>
    with WidgetsBindingObserver {
  _GateStatus _status = _GateStatus.checking;
  double? _distanceMeters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAccess();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAccess();
    }
  }

  Future<void> _checkAccess() async {
    setState(() => _status = _GateStatus.checking);

    final servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      setState(() => _status = _GateStatus.servicesDisabled);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() => _status = _GateStatus.permissionDenied);
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _status = _GateStatus.permissionDeniedForever);
      return;
    }

    try {
      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      );
      final position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.castleLatitude,
        widget.castleLongitude,
      );

      _distanceMeters = distance;
      if (distance <= widget.radiusMeters) {
        setState(() => _status = _GateStatus.allowed);
      } else {
        setState(() => _status = _GateStatus.outsideArea);
      }
    } catch (_) {
      setState(() => _status = _GateStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == _GateStatus.allowed) {
      return widget.child;
    }

    final isBlocked = _status != _GateStatus.checking;
    final bgColor = isBlocked ? Colors.red.shade700 : Colors.blueGrey.shade700;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  _title(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _message(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: _actions(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _title() {
    switch (_status) {
      case _GateStatus.checking:
        return 'Standort wird geprüft';
      case _GateStatus.servicesDisabled:
        return 'GPS ist deaktiviert';
      case _GateStatus.permissionDenied:
      case _GateStatus.permissionDeniedForever:
        return 'Standortzugriff erforderlich';
      case _GateStatus.outsideArea:
        return 'Außerhalb des Tour-Bereichs';
      case _GateStatus.error:
        return 'Standort konnte nicht gelesen werden';
      case _GateStatus.allowed:
        return '';
    }
  }

  String _message() {
    switch (_status) {
      case _GateStatus.checking:
        return 'Bitte einen Moment warten...';
      case _GateStatus.servicesDisabled:
        return 'Bitte schalten Sie GPS ein, um die App zu nutzen.';
      case _GateStatus.permissionDenied:
        return 'Bitte erlauben Sie den Standortzugriff, um die App zu nutzen.';
      case _GateStatus.permissionDeniedForever:
        return 'Bitte aktivieren Sie den Standortzugriff in den App-Einstellungen.';
      case _GateStatus.outsideArea:
        final distance = _distanceMeters == null
            ? ''
            : '\nAktueller Abstand: ${_distanceMeters!.round()} m';
        return 'Der Audioguide ist nur in der Nähe der Burg Kronberg verfügbar.'
            '$distance';
      case _GateStatus.error:
        return 'Bitte prüfen Sie GPS/Berechtigungen und versuchen Sie es erneut.';
      case _GateStatus.allowed:
        return '';
    }
  }

  List<Widget> _actions() {
    final buttons = <Widget>[];

    if (_status == _GateStatus.servicesDisabled) {
      buttons.add(
        ElevatedButton(
          onPressed: Geolocator.openLocationSettings,
          child: const Text('GPS-Einstellungen öffnen'),
        ),
      );
    }

    if (_status == _GateStatus.permissionDenied) {
      buttons.add(
        ElevatedButton(
          onPressed: _checkAccess,
          child: const Text('Berechtigung erneut anfragen'),
        ),
      );
      buttons.add(
        ElevatedButton(
          onPressed: Geolocator.openAppSettings,
          child: const Text('App-Einstellungen öffnen'),
        ),
      );
    }

    if (_status == _GateStatus.permissionDeniedForever) {
      buttons.add(
        ElevatedButton(
          onPressed: Geolocator.openAppSettings,
          child: const Text('App-Einstellungen öffnen'),
        ),
      );
    }

    if (_status == _GateStatus.outsideArea || _status == _GateStatus.error) {
      buttons.add(
        ElevatedButton(
          onPressed: _checkAccess,
          child: const Text('Erneut prüfen'),
        ),
      );
    }

    if (_status == _GateStatus.servicesDisabled ||
        _status == _GateStatus.permissionDenied ||
        _status == _GateStatus.permissionDeniedForever) {
      buttons.add(
        ElevatedButton(
          onPressed: _checkAccess,
          child: const Text('Erneut prüfen'),
        ),
      );
    }

    return buttons;
  }
}
