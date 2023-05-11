import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/presentation/home/home_screen.dart';
import 'presentation/welcome/get_started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: const GetStarted(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
