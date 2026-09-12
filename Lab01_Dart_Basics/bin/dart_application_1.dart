// // void main() {
//   // List num = [1, 2.2, 3.3, 4.4, 5.8,"Hi"];
//   // print(num);

//   // Map m = {
//   //   'name': 'Akkaradet',
//   //   'soon': 'Wongbamrap',
//   //   'grade': 2.99,
//   //   'age': 20,
//   // };
//   // print(m['name']);
//   // print(m['soon']);
//   // print(m['grade']);
//   // print(m['age']+8);
//   // print(m['name'.runtimeType]);

//   // dynamic v = 6;
//   // print(v);
//   // v = 3.4;
//   // print(v);

//   // final dynamic d = 6 ;
//   // d = 3.14;
//   // d = "pi";
//   // d = true;
//   // print(d);
//   // print(d.runtimeType);

//   // const dynamic d = 6 ;
//   // d = 3.14;
//   // d = "pi";
//   // d = true;
//   // print(d);
//   // print(d.runtimeType);

//   //   var a = Point(2, 2);
//   //   var b = Point(4, 4);
//   //   var distance = Point.distanceBreween(a, b);
//   //   print(distance);
//   // }

//   // class Point {
//   //   double x, y;
//   //   Point(this.x, this.y);

//   //   static double distanceBreween(Point a, Point b) {
//   //     var dx = a.x - b.x;
//   //     var dy = a.y - b.y;
//   //     return sqrt(dx * dx + dy * dy);
//   //   }

//   // for (int i = 1; i < 20; i+=2) {
//   //   print('hello ${i}');
//   // }

//   // for (int i = 0; i < 20; i++) {
//   //   if(i%2 != 0) print('hello $i');
//   // }

// //   fa List x = [1, 2, 3, 4, 5];
// //   print(x);
// // }

// // void main() {
// //    List<int> numbers = [1, 2, 3];
// //   numbers.add(4);
// //   numbers.add(5);
// //   print('List : $numbers');
// //   numbers.addAll([6, 7, 8]);
// //   print('$numbers');
// // }

// // void main() {
// //   final currentTime = DateTime.now(); 
// //   print(currentTime);
// //   final List<int> numbers = [1, 2, 3];
// //   numbers.add(4); 
// // }

// // void main() {
// //   const double pi = 3.14159; 
// //   const List<int> numbers = [1, 2, 3];
// // }


// enum IceLevel { none, less, regular, extra }
// void main() {
//   IceLevel myOrder = IceLevel.less; 
//   switch (myOrder) {
//     case IceLevel.none:
//       print("ไม่ใส่น้ำแข็ง");
//       break;
//     case IceLevel.less:
//       print("น้ำแข็งน้อย"); 
//       break;
//     case IceLevel.regular:
//       print("น้ำแข็งปกติ");
//       break;
//     case IceLevel.extra:
//       print("น้ำแข็งพูนแก้ว");
//       break;
//   }
// }

// class Calculator {
//   int add(int num1, int num2) => num1 + num2;
//   int multiply(int num1, int num2) => num1 * num2;
// }
// void main() {
//   Calculator cal = Calculator();
//   int sumResult = cal.add(10, 5);
//   int multiplyResult = cal.multiply(10, 5);
//   print("$sumResult");
//   print("$multiplyResult");
// }

// import 'dart:math';

// class Sphere {
//   double diameter;
//   double volume = 0;
//   double surfaceArea = 0;
//   Sphere(this.diameter);
//   double get radius => diameter / 2;
//   void calculateSurfaceArea() => surfaceArea = 4 * pi * pow(radius, 2);
//   void calculateVolume() => volume = (4 / 3) * pi * pow(radius, 3);
//   void displayResult() {
//     print('Diameter : ${diameter.toInt()}');
//     print('Volume : $volume');
//     print('Area : $surfaceArea');
//     print('');
//   }
// }

// void main() {

//   Sphere s1 = Sphere(7);
//   Sphere s2 = Sphere(8);
//   Sphere s3 = Sphere(13);
//   s1.calculateSurfaceArea();
//   s1.calculateVolume();
//   s1.displayResult();
//   s2.calculateSurfaceArea();
//   s2.calculateVolume();
//   s2.displayResult();
//   s3.calculateSurfaceArea();
//   s3.calculateVolume();
//   s3.displayResult();
// }

// import 'dart:io';
// void main() {
//   var demo = Lab3();
//   demo.show(15);
// }

// class Lab3 {
//   void show(int size) {
//     int currentNumber = 1;
//     for (int row = 0; row < size; row++) {
//       for (int col = 0; col < size; col++) { 
//         bool isBorder = (row < 2 || row > size - 3 || col < 2 || col > size - 3);
//         bool isDiagonal = (row == col || row + col == size - 1);
//         if (!isBorder && isDiagonal) {
//           stdout.write('     ');
//         } else {
//           stdout.write('${currentNumber.toString().padRight(5)}');
//         }
//         currentNumber++;
//       }
//       print(''); 
//     }
//   }
// }

int add({requred int a, requred int b }){
  return a + b ;
}

void main (){
  var result = add(
    b:10,
    a:20,);
    print(result);
}