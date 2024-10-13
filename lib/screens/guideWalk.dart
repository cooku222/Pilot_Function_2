import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../utils/gps_only_location_source.dart';

class GuideWalkScreen extends StatefulWidget {
  final String description;

  GuideWalkScreen({required this.description});

  @override
  _GuideWalkScreenState createState() => _GuideWalkScreenState();
}

class _GuideWalkScreenState extends State<GuideWalkScreen> {
  final Completer<NaverMapController> _controller = Completer();
  late GpsOnlyLocationSource locationSource;

  @override
  void initState() {
    super.initState();
    locationSource = GpsOnlyLocationSource(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: true,
            ),
            onMapReady: (NaverMapController controller) async {
              _controller.complete(controller);
              controller.locationTrackingMode = LocationTrackingMode.Follow;
              controller.addOnLocationChangeListener((location) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("현재 위치: ${location.latitude}, ${location.longitude}"),
                ));
              });
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
