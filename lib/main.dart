import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello there!"),
        ),
        body: Center(
          child: MasterInterface(),
        ),
      ),
    );
  }
}



class MasterInterface extends StatelessWidget {
  const MasterInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}