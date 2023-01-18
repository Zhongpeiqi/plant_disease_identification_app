import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({Key? key, required this.text, required this.onPress}) : super(key: key);
  final String text;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('确认执行操作'),
      content: Text(text,style: const TextStyle(fontSize: 15),),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('取消',style: TextStyle(fontSize: 15),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: onPress,
          child: const Text('确认',style: TextStyle(fontSize: 15),),
        ),
      ],
    );
  }
}
