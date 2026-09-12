import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // สำหรับคำสั่งสั่นเครื่อง (HapticFeedback)
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart'; // <--- เพิ่ม import ของ gallery_saver

List<CameraDescription>? cameras;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _takePicture() async {
    try {
      if (controller != null) {
        if (controller!.value.isInitialized) {
          // สั่นเครื่องขณะกดถ่ายภาพ
          HapticFeedback.vibrate();

          XFile image = await controller!.takePicture();
          await GallerySaver.saveImage(image.path, toDcim: true);
          print('Picture saved to gallery: ${image.path}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  CameraController? controller;
  bool isRecording = false;
  int selectedCameraIndex = 0;

  Future<void> _initCamera(int cameraIndex) async {
    if (cameras == null || cameras!.isEmpty) return;
    
    // เคลียร์ controller เดิมก่อนสร้างใหม่
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.max,
    );

    try {
      await controller!.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _switchCamera() async {
    if (cameras == null || cameras!.length < 2 || isRecording) return;

    // สลับไปยังกล้องถัดไป
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras!.length;
    await _initCamera(selectedCameraIndex);
  }

  Future<void> startVideoRecording() async {
    try {
      if (controller != null && controller!.value.isInitialized) {
        await controller!.startVideoRecording();
        setState(() {
          isRecording = true;
        });
        print('Started video recording');
      }
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    try {
      if (controller != null && controller!.value.isInitialized) {
        XFile file = await controller!.stopVideoRecording();
        setState(() {
          isRecording = false;
        });
        // บันทึกไฟล์วิดีโอลงในแกลเลอรี
        await GallerySaver.saveVideo(file.path, toDcim: true);
        print('Video saved to gallery: ${file.path}');
        return file;
      }
      return null;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras()
        .then((availableCameras) async {
          cameras = availableCameras;
          if (cameras != null && cameras!.isNotEmpty) {
            _initCamera(0);
          }
        })
        .catchError((err) {
          print('Error: $err');
        });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: controller == null
              ? const Text('NO any camera found')
              : controller!.value.isInitialized
                  ? CameraPreview(controller!)
                  : const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ปุ่มถ่ายภาพนิ่ง
          FloatingActionButton(
            heroTag: 'take_picture',
            onPressed: isRecording ? null : _takePicture,
            tooltip: 'Take Picture',
            child: const Icon(Icons.camera),
          ),
          // ปุ่มเริ่ม/หยุดบันทึกวิดีโอ
          FloatingActionButton(
            heroTag: 'record_video',
            backgroundColor: isRecording ? Colors.red : Colors.blue,
            onPressed: () async {
              if (isRecording) {
                await stopVideoRecording();
              } else {
                await startVideoRecording();
              }
            },
            tooltip: 'Record Video',
            child: Icon(
              isRecording ? Icons.stop : Icons.videocam,
              color: Colors.white,
            ),
          ),
          // ปุ่มสลับกล้อง (หน้า/หลัง/ตัวอื่น)
          FloatingActionButton(
            heroTag: 'switch_camera',
            backgroundColor: isRecording ? Colors.grey : Colors.deepPurple,
            onPressed: isRecording ? null : _switchCamera,
            tooltip: 'Switch Camera',
            child: const Icon(
              Icons.cameraswitch,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}