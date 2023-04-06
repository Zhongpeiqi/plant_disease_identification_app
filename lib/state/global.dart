import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/model/profile.dart';
import 'package:plant_disease_identification_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


final _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.pink,
];

class Global {
  static late SharedPreferences _prefs;
  static Profile profile = Profile.none([]);

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    //初始化加载profile
    var _profile = _prefs.getString("profile");
    try {
      profile = Profile.fromJson(jsonDecode(_profile!));
      profile.historyList = [];
    } catch (e) {
      Log().i(e);
    }
  }

  //保存配置信息包括登录的User和主题
  static void saveProfile() {
    _prefs.setString('profile', jsonEncode(profile.toJson()));
   print(jsonEncode(profile.toJson()));
  }

}
