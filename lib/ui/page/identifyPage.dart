import 'package:flutter/material.dart';
class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IdentifyPageState();
  }
}

class _IdentifyPageState extends State<IdentifyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('识别页面')),
    );
  }
}