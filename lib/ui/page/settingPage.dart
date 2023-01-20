
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/ui/page/updateUserDetailPage.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'aboutPage.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(40)),
          MyListTile(
            left: 40,
            leading: Text(
              '头像与个人信息',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right, size: ScreenUtil().setWidth(50), color: Colors.grey
            ),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const UpdateUserDetailPage()));
            },
          ),
          Divider(indent: ScreenUtil().setWidth(40)),
          MyListTile(
            left: 40,
            leading: Text(
              '缓存清理',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          Divider(indent: ScreenUtil().setWidth(40)),
          MyListTile(
            left: 40,
            leading: Text(
              '关于',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          Divider(indent: ScreenUtil().setWidth(40)),
          TextButton(
            onPressed: () async {
              // SharedPreferences _prefs = await SharedPreferences.getInstance();
              // _prefs.remove('profile');
              Navigator.pushNamedAndRemoveUntil(context, 'login_page', (route) => route == null);
            },
            child: Text(
              '退出登录',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: ScreenUtil().setSp(54),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
