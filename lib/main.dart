import 'package:flutter/material.dart';
// import 'dart:ui';
import 'pages/home_page.dart';
// import 'pages/introPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        // primarySwatch: Colors.purple,        
      ),
      // home: IntroPage(),
      home: HomePage(),  
      
    );
  }
}

