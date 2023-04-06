import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:plant_disease_identification_app/ui/page/settingPage.dart';
import 'package:plant_disease_identification_app/ui/page/updateUserDetailPage.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import 'feed/articlePage.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  late bool _offLittleAvatar;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _offLittleAvatar = true;
    var downLock = true;
    var upLock = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 70 && downLock) {
        setState(() {
          _offLittleAvatar = false;
        });
        upLock = true;
        downLock = false;
      }
      if (_scrollController.position.pixels < 70 && upLock) {
        setState(() {
          _offLittleAvatar = true;
        });
        upLock = false;
        downLock = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Offstage(
          offstage: _offLittleAvatar,
          child: SizedBox(
            width: ScreenUtil().setWidth(90),
            height: ScreenUtil().setWidth(90),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.avatarUrl!),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          _buildShowUserInfo(),
        ],
      ),
    );
  }

  //页面上方的显示用户信息的那一块儿
  Widget _buildShowUserInfo() {
    return Consumer<UserModel>(builder: (BuildContext context, model, _) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).scaffoldBackgroundColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //头像和昵称
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircleAvatar(
                          backgroundImage:
                          widget.user.avatarUrl == null
                              ? const AssetImage("assets/img/author.png")
                              : NetworkImage(widget.user.avatarUrl!) as ImageProvider,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.user.username ?? "张三",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(66)),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(30),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
              ),
              margin:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildShowNum(widget.user.postNum.toString(), '记录',1),
                    Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[300]!, width: 0.5))),
                    _buildShowNum('0', '识别', 2),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey[300]!, width: 0.5)),
                    ),
                    _buildShowNum(widget.user.likedNum.toString(), '点赞',3),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //显示动态数量等的小部件
  //显示动态数量等的小部件
  Widget _buildShowNum(String num, String label,int type) {
    return TextButton(
      onPressed: () {
        switch(type){
          case 1:
            Get.to(() => ArticlePage(userId:widget.user.id,type: 5));
            break;
          case 2:
          // Get.to(() => const ArticlePage(type: 5,));
            break;
          case 3:
            Get.to(() => ArticlePage(userId:widget.user.id,type: 4,));
            break;
        }
      },
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(num.length < 4 ? num : '999+',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(60),
                    fontWeight: FontWeight.w600)),
            Text(label,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36), color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
