import 'package:flutter/material.dart';

class GuideSubwayScreen extends StatelessWidget {
  final Map<String, dynamic> routeData;

  GuideSubwayScreen({required this.routeData});

  @override
  Widget build(BuildContext context) {
    int stationCount = routeData['features'].length; // 지하철역 수

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$stationCount 정류장 후\n내리세요",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stationCount,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: 300,
                    height: 79.59,
                    decoration: BoxDecoration(
                      color: Color(0xFFE75531).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "역 ${index + 1}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
