import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/guideWalk.dart'; // 도보 경로 화면 import
import '../screens/guidSubway.dart'; // 지하철 경로 화면 import

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  bool isTest1Selected = false; // 테스트 1 선택 여부
  bool isTest2Selected = false; // 테스트 2 선택 여부

  // 테스트 1의 출발지와 목적지 좌표
  final double test1StartLat = 37.321877;
  final double test1StartLng = 127.126094;
  final double test1EndLat = 37.2717293;
  final double test1EndLng = 127.1057055;

  // 테스트 2의 출발지와 목적지 좌표
  final double test2StartLat = 37.3258224;
  final double test2StartLng = 127.1057793;
  final double test2EndLat = 37.2359449;
  final double test2EndLng = 127.2057359;

  // 선택된 출발지와 도착지 좌표
  double selectedStartLat = 0;
  double selectedStartLng = 0;
  double selectedEndLat = 0;
  double selectedEndLng = 0;

  // Tmap API를 사용하여 가져온 데이터를 저장
  Map<String, dynamic> routeData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInputField("출발지", _startController),
            const SizedBox(height: 20),
            _buildInputField("목적지", _endController),
            const SizedBox(height: 422),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTestButton("테스트 1", isTest1Selected, () {
                  setState(() {
                    isTest1Selected = true;
                    isTest2Selected = false;
                    _startController.text = '단국대 죽전 캠퍼스';
                    _endController.text = '기흥 복지관';

                    // 테스트 1의 좌표 대입
                    selectedStartLat = test1StartLat;
                    selectedStartLng = test1StartLng;
                    selectedEndLat = test1EndLat;
                    selectedEndLng = test1EndLng;
                  });
                }),
                SizedBox(width: 34),
                _buildTestButton("테스트 2", isTest2Selected, () {
                  setState(() {
                    isTest2Selected = true;
                    isTest1Selected = false;
                    _startController.text = '죽전 아르피아';
                    _endController.text = '용인 중앙 시장';

                    // 테스트 2의 좌표 대입
                    selectedStartLat = test2StartLat;
                    selectedStartLng = test2StartLng;
                    selectedEndLat = test2EndLat;
                    selectedEndLng = test2EndLng;
                  });
                }),
              ],
            ),
            const SizedBox(height: 40),
            _buildGuideButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return Container(
      width: 304,
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE75531), width: 1),
        borderRadius: BorderRadius.circular(36),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Color(0x747474).withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildGuideButton() {
    return ElevatedButton(
      onPressed: () async {
        // 경로 안내하기 버튼 클릭 시 선택된 좌표를 기반으로 API 호출
        if (selectedStartLat != 0 && selectedStartLng != 0 && selectedEndLat != 0 && selectedEndLng != 0) {
          await getRoute(); // API 호출

          // mode 값에 따라 화면 전환
          int pathType = routeData['features'][0]['properties']['pathType'];
          if (pathType == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuideWalkScreen(routeData: routeData)),
            );
          } else if (pathType == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuideSubwayScreen(routeData: routeData)),
            );
          } else {
            print("지원하지 않는 경로 유형입니다.");
          }
        } else {
          print("출발지와 도착지를 선택하세요.");
        }
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(304, 64),
        backgroundColor: Color(0xFFE75531),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
      ),
      child: Text(
        "경로 안내하기",
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(130, 64),
        backgroundColor: isSelected ? Color(0xFFE75531) : Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
      ),
      child: Align(
        alignment: isSelected ? Alignment.centerLeft : Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Noto Sans',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  // Tmap API 호출 함수
  Future<void> getRoute() async {
    final apiKey = 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR'; // 발급받은 API Key
    final url = Uri.parse('https://apis.openapi.sk.com/transit/routes'); // Tmap API URL

    final body = json.encode({
      "startX": selectedStartLng.toString(),
      "startY": selectedStartLat.toString(),
      "endX": selectedEndLng.toString(),
      "endY": selectedEndLat.toString(),
      "lang": 0,
      "format": "json",
      "count": 10
    });

    try {
      print("API 호출 중...");
      print("요청 데이터: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'appKey': apiKey,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          routeData = json.decode(response.body);
        });
      } else {
        print('API 호출 실패: ${response.body}');
      }
    } catch (e) {
      print("API 호출 중 오류 발생: $e");
    }
  }
}
