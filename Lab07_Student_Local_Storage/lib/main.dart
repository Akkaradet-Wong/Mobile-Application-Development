import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final _listviewscrollController = ScrollController();
  List<String> entries = <String>[];

  void _incrementCounter() {
    if (_studentIdController.text.isEmpty ||
        _studentNameController.text.isEmpty)
      return;

    setState(() {
      entries.add(
        '${_studentIdController.text}   ${_studentNameController.text}',
      );
      _studentIdController.clear();
      _studentNameController.clear();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_listviewscrollController.hasClients) {
          _listviewscrollController.animateTo(
            _listviewscrollController.position.maxScrollExtent + 50,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveToFile() async {
    final path = await getFilePath();
    final file = File('$path/students.txt');
    final sink = file.openWrite();
    for (var entry in entries) {
      sink.writeln(entry);
    }
    await sink.flush();
    await sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'เพิ่มรายชื่อนักศึกษา',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: entries.isNotEmpty
                ? ListView.builder(
                    controller: _listviewscrollController,
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ), // เส้นคั่นสีเทาอ่อน
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          title: Text(
                            entries[index],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                entries.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('')),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(labelText: 'รหัสนักศึกษา'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _studentNameController,
                  decoration: const InputDecoration(labelText: 'ชื่อ นามสกุล'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
