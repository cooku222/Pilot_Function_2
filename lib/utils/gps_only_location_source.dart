import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class GpsOnlyLocationSource implements LocationSource {
  final BuildContext context;
  LocationSource.OnLocationChangedListener? listener;
  final LocationManager? locationManager;

  GpsOnlyLocationSource(this.context)
      : locationManager = context.getSystemService(Context.LOCATION_SERVICE);

  @override
  void activate(LocationSource.OnLocationChangedListener listener) {
    this.listener = listener;
    // 권한 확인 로직 필요
    locationManager?.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 10f, this);
  }

  @override
  void deactivate() {
    listener = null;
    locationManager?.removeUpdates(this);
  }

  @override
  void onLocationChanged(Location location) {
    listener?.onLocationChanged(location);
  }

  @override
  void onStatusChanged(String provider, int status, Bundle extras) {}

  @override
  void onProviderEnabled(String provider) {}

  @override
  void onProviderDisabled(String provider) {}
}
