import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/user.dart';
import '../state/global.dart';

class FollowButton extends StatefulWidget {
  final User user;

  const FollowButton({Key? key, required this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FollowButtonState();
  }
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().setWidth(180),
      height: ScreenUtil().setHeight(70),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        ),
        child: Text(
          '未关注',
          style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.white),
        ),
        onPressed: () async {

        },
      ),
    );
  }
}