import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart'; // GPS 위치를 가져오기 위한 패키지 추가

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'tj346mpbv2', // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({Key? key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStream;
  NaverMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // 앱 시작 시 현재 위치 가져오기
  }

  // 위치 권한 확인 및 실시간 위치 업데이트 스트림 시작
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('위치 서비스가 비활성화되어 있습니다.', name: 'GPS');
      return;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('위치 권한이 거부되었습니다.', name: 'GPS');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('위치 권한이 영구적으로 거부되었습니다.', name: 'GPS');
      return;
    }

    // 실시간 위치 업데이트 스트림 시작
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터 이동 시마다 업데이트
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
      log('실시간 위치 업데이트: ${position.latitude}, ${position.longitude}', name: 'GPS');

      // 지도를 현재 위치로 이동
      if (_mapController != null) {
        // scrollTo 메서드를 사용하여 현재 위치로 지도 이동
        _mapController!.moveCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(position.latitude, position.longitude),
          ),
        );

        // 줌 레벨을 설정
        _mapController!.moveCamera(
          NCameraUpdate.zoomBy(14),
        );
      }
    });
  }

  @override
  void dispose() {
    _positionStream.cancel(); // 위치 스트림 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            NaverMap(
              options: const NaverMapViewOptions(
                indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
              ),
              onMapReady: (controller) async {
                _mapControllerCompleter.complete(controller);
                _mapController = controller;
                log("onMapReady", name: "onMapReady");
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPosition != null && _mapController != null) {
                    // 현재 위치로 지도 이동
                    _mapController!.moveCamera(
                      NCameraUpdate.scrollAndZoomTo(
                        target: NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      ),
                    );
                    _mapController!.moveCamera(
                      NCameraUpdate.zoomBy(14),
                    );
                  }
                },
                child: const Text("내 위치로 이동"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on NaverMapController {
  void moveCamera(zoomBy) {}
}
