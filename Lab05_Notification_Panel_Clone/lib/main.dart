// import 'package:flutter/material.dart';
// void main() {
//   runApp(const MyApp());
// }
// Color _getUniqueColor(int number) {
//     double hue = ((number - 1) * 3.6) % 360.0;
//     return HSVColor.fromAHSV(1.0, hue, 0.8, 1.0).toColor();
//   }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF2B3240),
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         centerTitle: true,
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//         mainAxisAlignment:MainAxisAlignment.spaceEvenly,
//         children:<Widget>[
//         for (int i = 0 ; i< 10 ; i++)
//         Row(
//           mainAxisAlignment:MainAxisAlignment.spaceEvenly,
//           children:<Widget>[
//             for (int j = 0 ; j < 10 ; j++)
//             Text(
//             '${(i * 10 ) + j+1}',
//             style: TextStyle(
//               color: _getUniqueColor ((i * 10) + j + 1),
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//             )
//           ]
//         )]
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const NotificationPanelApp());
}

class NotificationPanelApp extends StatelessWidget {
  const NotificationPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Panel Clone',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const NotificationPanelScreen(),
    );
  }
}

class NotificationPanelScreen extends StatelessWidget {
  const NotificationPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold ตัวนอกสุด ทำหน้าที่เป็นพื้นหลังโต๊ะ (สีเทาเข้ม)
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        // ConstrainedBox ล็อคความกว้างให้ไม่เกิน 412 pixels (สัดส่วนมือถือ)
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 412),
          child: Container(
            // ตกแต่งเพิ่มเติม: ใส่เงาและขอบโค้งมนให้ดูเหมือนจำลองหน้าจอมือถือ
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              // ทำให้มุมจอมือถือจำลองโค้งมนนิดๆ (ไม่บังคับ)
              borderRadius: BorderRadius.circular(20),
              // Scaffold ตัวใน คือตัว UI แจ้งเตือนของเรา (โค้ดเดิม)
              child: Scaffold(
                backgroundColor: const Color(0xFFE8ECEF),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 16),
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildQuickSettings(),
                        const SizedBox(height: 20),
                        _buildActionButtons(),
                        const SizedBox(height: 24),

                        // 1. การ์ด Messages
                        _buildNotificationCard(
                          icon: Icons.message,
                          iconColor: Colors.blue,
                          appName: 'Messages',
                          time: '12:35',
                          content: Column(
                            children: [
                              _buildSubMessage(
                                'True',
                                'TrueSpecial ดีลพิเศษ! เน็ตไม่อั้น ความเร็วสูงสุด...',
                              ),
                              const SizedBox(height: 8),
                              _buildSubMessage(
                                'TrueID',
                                'ชิงรางวัลแพ็กเกจดูบอล EPL ฟรีตลอดฤดูกาล...',
                              ),
                            ],
                          ),
                          extraText: 'อีก +3 รายการ',
                        ),

                        // 2. การ์ด ตั้งค่า
                        _buildNotificationCard(
                          icon: Icons.settings,
                          iconColor: Colors.black,
                          appName: 'ตั้งค่า Galaxy M23 5G ให้เสร็จ',
                          time: '',
                          content: const Text(
                            'อีกเพียงไม่กี่ขั้นตอน',
                            style: TextStyle(color: Colors.black54),
                          ),
                          backgroundColor: const Color(0xFFE3EFFF),
                        ),

                        // 3. การ์ด OneDrive
                        _buildNotificationCard(
                          icon: Icons.cloud,
                          iconColor: Colors.blue,
                          appName: 'ซิงค์รูปถ่ายของคุณไปยัง OneDrive',
                          time: '7/7/23',
                          content: const Text(
                            'เชื่อมต่อบัญชี Samsung และ Microsoft ของคุณเพื่อดูวิดีโอ...',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 4. การ์ด แอพที่แนะนำ
                        _buildNotificationCard(
                          icon: Icons.grid_view,
                          iconColor: Colors.grey,
                          appName: 'แอพที่แนะนำ',
                          time: '',
                          content: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'มีอัพเดทแอพ 1 พร้อมใช้งาน',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Smart Tutor',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          isExpandable: true,
                        ),

                        // 5. การ์ด เลื่อนการอัพเดทแล้ว
                        _buildNotificationCard(
                          icon: Icons.schedule,
                          iconColor: Colors.blue,
                          appName: 'เลื่อนการอัพเดทแล้ว',
                          time: '',
                          content: const SizedBox.shrink(),
                        ),

                        // 6. การ์ด Photos
                        _buildNotificationCard(
                          icon: Icons.photo_camera_back,
                          iconColor: Colors.blue,
                          appName: 'Photos',
                          time: '13:05',
                          content: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'วันนี้เมื่อ 9 ปีที่แล้ว... ย้อนความทรงจำเมื่อ 12 ก.ค. 2557',
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'วันนี้เมื่อ 9 ปีที่แล้ว... ย้อนความทรงจำเมื่อ 10 ก.ค. 2557',
                                  ),
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 7. การ์ด โทรศัพท์
                        _buildNotificationCard(
                          icon: Icons.phone_missed,
                          iconColor: Colors.green,
                          appName: 'โทรศัพท์',
                          time: '28/6/23',
                          content: const Text(
                            'เบอร์ที่ไม่ได้รับสาย 0600031910',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ส่วนฟังก์ชันอื่นๆ (Header, QuickSettings, ฯลฯ) คงเดิมเหมือนโค้ดก่อนหน้านี้...
  // คุณสามารถคัดลอกส่วน _buildHeader, _buildQuickSettings ลงมาต่อได้เลยครับ
  // ส่วนหัว (Header)
  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'พ. 12 ก.ค.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.settings, size: 28),
      ],
    );
  }

  // ส่วนเมนูตั้งค่าด่วน (Quick Settings)
  Widget _buildQuickSettings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleIcon(Icons.wifi, isActive: true),
        _buildCircleIcon(Icons.volume_up, isActive: true),
        _buildCircleIcon(Icons.bluetooth, isActive: true),
        _buildCircleIcon(Icons.screen_rotation, isActive: true),
        _buildCircleIcon(Icons.flight, isActive: false),
        _buildCircleIcon(Icons.flashlight_on, isActive: false),
      ],
    );
  }

  Widget _buildCircleIcon(IconData icon, {required bool isActive}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.black12,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.black54,
        size: 26,
      ),
    );
  }

  // ปุ่มควบคุมอุปกรณ์และสื่อ
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                'ควบคุมอุปกรณ์',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                'เอาต์พุตมีเดีย',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // โครงสร้างการ์ดแจ้งเตือน (Notification Card Base) - แก้ไขตำแหน่งเวลา
  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String appName,
    required String time,
    required Widget content,
    String? extraText,
    Color backgroundColor = Colors.white,
    bool isExpandable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 1. ไอคอนแอป
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),

              // 2. ชื่อแอป
              Text(
                appName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),

              // 3. ข้อความเสริม (ถ้ามี)
              if (extraText != null) ...[
                const SizedBox(width: 4),
                Text(
                  extraText,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],

              // 4. เวลา/วันที่ (ย้ายมาต่อท้ายชื่อแอปตรงนี้)
              if (time.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ],

              // 5. Spacer() ตัวดันลูกศรไปชิดขวาสุด (ต้องอยู่หลังสุด)
              const Spacer(),

              // 6. ลูกศร
              Icon(
                isExpandable ? Icons.expand_less : Icons.expand_more,
                color: Colors.black38,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          content, // เนื้อหาด้านล่าง
        ],
      ),
    );
  }

  // ไวเจ็ตย่อยสำหรับรายชื่อข้อความ
  Widget _buildSubMessage(String sender, String message) {
    return Row(
      children: [
        const Icon(Icons.person, color: Colors.black26, size: 20),
        const SizedBox(width: 8),
        Text(
          sender,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
