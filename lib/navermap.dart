import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:insideout/style.dart';
import 'package:location/location.dart';


class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  List<NLatLng> markerPositions = [];
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.getLocation().then((locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  void _addMarker(NaverMapController controller, NLatLng position) async {
    final iconImage = await NOverlayImage.fromWidget(
      widget: const FlutterLogo(),
      size: const Size(24, 24),
      context: context,
    );

    final marker = NMarker(
      id: UniqueKey().toString(),
      position: position,
      icon: iconImage,
      caption: NOverlayCaption(text: "마커"),
    );
    controller.addOverlay(marker);
  }

  Future<void> _moveToCurrentLocation() async {
    if (_currentLocation != null) {
      final controller = await mapControllerCompleter.future;
      final position = NCameraPosition(
        target: NLatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15.0,
      );
      final cameraUpdate = NCameraUpdate.fromCameraPosition(position);
      controller.updateCamera(cameraUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naver Map App'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: false,
              consumeSymbolTapEvents: false,
              initialCameraPosition: NCameraPosition(
                target: NLatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 15.0,
              ),
            ),
            onMapReady: (controller) async {
              mapControllerCompleter.complete(controller);
              log("onMapReady", name: "onMapReady");

              for (var position in markerPositions) {
                final marker = NMarker(
                  position: position,
                  caption: NOverlayCaption(text: "마커"),
                  id: UniqueKey().toString(),
                );
                controller.addOverlay(marker);
              }

              // Adding a specific marker
              _addMarker(controller, NLatLng(37.5665, 126.9780)); // Replace with the desired coordinates
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _moveToCurrentLocation,
              backgroundColor: ColorStyle.mainColor1,
              foregroundColor: ColorStyle.bgColor2,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
