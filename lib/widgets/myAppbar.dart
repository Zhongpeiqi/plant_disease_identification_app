import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/ui/page/searchPage.dart';

class MyAppbar {
  static PreferredSizeWidget build(BuildContext context,Widget title) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
      elevation: 1,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
          child: IconButton(
            icon: const Icon(
              MyIcons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const SearchPage()));
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(-8),
        child: Container(),
      ),
    );
  }
  static Widget simpleAppbar(String title){
    return AppBar(
      title: Text(title),
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(-8),
        child: Container(),
      ),
    );
  }
}
