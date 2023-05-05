import 'package:flutter/material.dart';
import 'package:socket_race_flutter/fourthp_page.dart';
import 'package:socket_race_flutter/socket_service.dart';

void main() {
  runApp(const MyApp());
  initSocket();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FourthPage(),
    );
  }
}
