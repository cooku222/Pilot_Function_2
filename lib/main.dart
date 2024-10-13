import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // main_screen.dart를 불러옴

void main() {
  runApp(MyApp()); // MyApp을 실행
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(), // MainScreen을 홈 화면으로 설정
    );
  }
}
