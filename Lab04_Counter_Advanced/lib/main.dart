// import'package:flutter/material.dart';
// void main() {
//   runApp(
//     const Center(
//       child: Text('Hello,world!',textDirection:TextDirection.ltr,
//       ),
//     )
//   );
// }

// import 'package:flutter/material.dart';
// void main() {
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 8, 139, 205),
//         appBar:
//           AppBar(
//           title: Text('First Application'),
//           ),
//         body: Center(
//           child: Text('Hello, world!'),
//         ),
//       ),
//     ),
//   );
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const
// MainApp());
// }

// class MainApp extends StatelessWidget {
//   const
// MainApp({super.key});

//   @override
//   Widget
// build(BuildContext context) {

// return const MaterialApp(

// home: Scaffold(

// body: Center(

// child: Text('Hello World!'),

// ),

// ),

// );
//   }
// }

import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 31, 191, 63),
        ),
        useMaterial3: true,
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button thismany times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'ลดจำนวน',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _resetCounter,
            tooltip: 'เริ่มใหม่',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'เพิ่มจำนวน',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
