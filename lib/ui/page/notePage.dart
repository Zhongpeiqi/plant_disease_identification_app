import 'package:flutter/material.dart';
class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NotePageState();
  }
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('记录病害')),
    );
  }
}