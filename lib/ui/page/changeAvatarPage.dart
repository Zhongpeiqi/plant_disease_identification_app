import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/page/updateUserDetailPage.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';

import '../../net/NetRequester.dart';
import '../../net/UploadUtils.dart';

class ChangeAvatarPage extends StatefulWidget {
  final int type;
  const ChangeAvatarPage({Key? key, required this.type}) : super(key: key);

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  GlobalKey<_ChangeAvatarPageState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Get.to(() => const UpdateUserDetailPage());
          },
        ),
        title: Text(widget.type == 1 ? '更改头像' : '更改背景'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              margin:
              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(150)),
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(1080),
              child: _buildImage()),
          SizedBox(
            width: ScreenUtil().setWidth(390),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                ImagePicker()
                    .pickImage(source: ImageSource.gallery, imageQuality: 60)
                    .then((image) async {
                  if (image != null) {
                    var upRes = await UpLoad.upLoadByFile("image",
                        File(image.path), "${NetConfig.ip}upload/image");
                    if (upRes.data != null) {
                      Global.profile.user!.avatarUrl = upRes.data['data'];
                      Map<String, dynamic> map = {};
                      map["id"] = Global.profile.user!.id;
                      map["username"] = Global.profile.user!.username;
                      map["avatarUrl"] = Global.profile.user!.avatarUrl;
                      var result = await NetRequester.request(
                          '/user/updateUserDetail',
                          data: map);
                      Toast.popToast(result.data['msg']);
                      setState(() {});
                    }
                    UserModel().notifyListeners();
                  }
                });
              },
              child: Text(
                '选择图片',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(46)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    StatefulWidget widget;
    widget = Global.profile.user?.avatarUrl == null
        ? Image.asset("assets/img/author.png")
        : ExtendedImage.network(
      Global.profile.user!.avatarUrl!,
      height: 250,
      width: 250,
    );
    return widget;
  }
}

