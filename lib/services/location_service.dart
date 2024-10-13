import 'package:flutter/services.dart';
import 'location_service.dart';

class AppService {
  final LocationService locationService = LocationService();

  Future<void> startTracking() async {
    try {
      await locationService.startLocationTracking();
      // 추가 로직 (필요할 경우)
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }
}