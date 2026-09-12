import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class CovidData {
  int year = 0;
  int weekNum = 0;
  int newCases = 0;
  int totalCases = 0;
  int newCasesExcludeAbroad = 0;
  int totalCasesExcludeAbroad = 0;
  int newRecovered = 0;
  int totalRecovered = 0;
  int newDeaths = 0;
  int totalDeaths = 0;
  int caseForeign = 0;
  int casePrison = 0;
  int caseWalkin = 0;
  int caseNewPrev = 0;
  int caseNewDiff = 0;
  int deathNewPrev = 0;
  int deathNewDiff = 0;
  String updateDate = '';

  void mapData(Map<String, dynamic> dataIn) {
    year = dataIn['year'] ?? 0;
    weekNum = dataIn['weeknum'] ?? 0;
    newCases = dataIn['new_case'] ?? 0;
    totalCases = dataIn['total_case'] ?? 0;
    newCasesExcludeAbroad = dataIn['new_case_excludeabroad'] ?? 0;
    totalCasesExcludeAbroad = dataIn['total_case_excludeabroad'] ?? 0;
    newRecovered = dataIn['new_recovered'] ?? 0;
    totalRecovered = dataIn['total_recovered'] ?? 0;
    newDeaths = dataIn['new_death'] ?? 0;
    totalDeaths = dataIn['total_death'] ?? 0;
    caseForeign = dataIn['case_foreign'] ?? 0;
    casePrison = dataIn['case_prison'] ?? 0;
    caseWalkin = dataIn['case_walkin'] ?? 0;
    caseNewPrev = dataIn['case_new_prev'] ?? 0;
    caseNewDiff = dataIn['case_new_diff'] ?? 0;
    deathNewPrev = dataIn['death_new_prev'] ?? 0;
    deathNewDiff = dataIn['death_new_diff'] ?? 0;
    updateDate = dataIn['update_date']?.toString() ?? '';
  }

  Future<dynamic> getData() async {
    String url = 'https://rmuti.ac.th/user/wudthipong/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body.substring(1, response.body.length - 1));
      mapData(data);
    } else {
      throw Exception('Failed to load COVID-19 data');
    }
  }
  String get thaiUpdateDate {
    if (updateDate.isEmpty) return '';
    try {
      final parts = updateDate.split(RegExp(r'[- ]'));
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      const months = [
        '',
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม'
      ];
      final buddhistYear = y + 543;
      return '$d ${months[m]} $buddhistYear';
    } catch (_) {
      return updateDate;
    }
  }
}

CovidData covidData = CovidData();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  String formatNumber(int num) {
    return num.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
        body: FutureBuilder(
          future: covidData.getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4C4773)));
            }
            else if (snapshot.connectionState == ConnectionState.done) {
              final data = covidData; 
              return Center(
                child: Container(
                  width: 600,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C4773),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(data),
                      const SizedBox(height: 10),

                      // แถวที่ 1 (เขียว)
                      SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildCard(
                                color: const Color(0xFF8CC63F),
                                title: 'หายป่วยวันนี้',
                                value: '+${formatNumber(data.newRecovered)}',
                              ),
                            ),
                            const SizedBox(width:8),
                            Expanded(
                              child: _buildCard(
                                color: const Color(0xFF7CB342),
                                title: 'หายป่วยสะสม',subtitle: 'ตั้งแต่ 1 มกราคม 2565', 
                                value: formatNumber(data.totalRecovered),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // แถวที่ 2 (แดง)
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildNewCasesCard(data),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildCard(
                                color: const Color(0xFFE57373),
                                title: 'ป่วยสะสม',
                                subtitle: 'ตั้งแต่ 1 มกราคม 2565',
                                value: formatNumber(data.totalCases),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // แถวที่ 3 (ฟ้า, ม่วง, เทา)
                      SizedBox(
                        height: 110,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildCard(
                                color: const Color(0xFF90CAF9),
                                title: 'กำลังรักษา',
                                value: formatNumber(data.totalCases -
                                    data.totalRecovered -
                                    data.totalDeaths),
                                valueSize: 26,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 4,
                              child: _buildCard(
                                color: const Color(0xFFB39DDB),
                                title: 'ผู้ป่วยปอดอักเสบ\nรักษาตัวอยู่ในโรงพยาบาล',
                                value: formatNumber(data.caseNewPrev),
                                valueSize: 26,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 4,
                              child: _buildDeathCard(data),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
                child: Text('Error', style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }

  // ==== Widget ส่วนหัว: ชื่อเรื่อง + กล่องวันที่สีเหลือง (ไม่มีโลโก้) ====
  Widget _buildHeader(CovidData data) {
    return Column(
      children: [
        const Text(
          'สถานการณ์ COVID-19\nในประเทศไทย',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEB3B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            data.thaiUpdateDate.isNotEmpty ? data.thaiUpdateDate : '-',
            style: const TextStyle(
              color: Color(0xFF4C4773),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Widget สำหรับสร้างการ์ดปกติทั่วไป
  Widget _buildCard({
  required Color color,
  required String title,
  String? subtitle,
  required String value,
  double valueSize = 46,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // ลดจาก all(8)
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // แทน Spacer 2 อัน
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        Flexible( 
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Widget พิเศษสำหรับการ์ด "ผู้ป่วยใหม่วันนี้"
  Widget _buildNewCasesCard(CovidData data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEF5350),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        children: [
          const Text(
            'จำนวนผู้ป่วยใหม่วันนี้',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '+${formatNumber(data.newCases)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('ผู้ป่วยในประเทศ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    Text('+${formatNumber(data.newCasesExcludeAbroad)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(width: 1, height: 24, color: Colors.white54),
              Expanded(
                child: Column(
                  children: [
                    const Text('ผู้ป่วยจากต่างประเทศ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    Text('+${formatNumber(data.caseForeign)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget พิเศษสำหรับการ์ด "เสียชีวิตเพิ่ม"
  Widget _buildDeathCard(CovidData data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF757575),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'เสียชีวิตเพิ่ม',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatNumber(data.newDeaths),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(color: Colors.white54, height: 8, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text('เสียชีวิตสะสม\nตั้งแต่ 1 มกราคม 2565',
                    style: TextStyle(color: Colors.white70, fontSize: 8),
                    textAlign: TextAlign.right),
              ),
              const SizedBox(width: 4),
              Text(
                formatNumber(data.totalDeaths),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}