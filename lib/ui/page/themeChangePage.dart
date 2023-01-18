import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:provider/provider.dart';

import '../../state/profileChangeNotifier.dart';

class ThemeChangePage extends StatelessWidget {
  const ThemeChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主题'),
      ),
      body: ListView(
        //显示主题色块
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context, listen: false).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}
