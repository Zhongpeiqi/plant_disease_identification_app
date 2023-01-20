
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/ui/page/clipImgPage.dart';

class ChangeAvatarPage extends StatelessWidget {
  final int type;

  const ChangeAvatarPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == 1
            ?'更改头像'
            :'更改背景'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(150)),
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(1080),
              child: _buildImage()
          ),
          SizedBox(
            width: ScreenUtil().setWidth(390),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                ImagePicker().pickImage(
                    source: ImageSource.gallery, imageQuality: 60)
                    .then((image) {
                  if (image != null) {
                    Get.to(() => ClipImgPage(image: File(image.path), type: type));
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
    if(type== 1){
      widget = Global.profile.user?.avatarUrl ==null
      ? Image.asset("assets/img/author.png")
      : ExtendedImage.network('${NetConfig.ip}/images/${Global.profile.user?.avatarUrl}');
    }else{
      widget = Global.profile.user?.backImgUrl ==null
          ? Image.asset('assets/images/back.jpg')
          : ExtendedImage.network('${NetConfig.ip}/images/${Global.profile.user?.backImgUrl}');
    }
    return widget;
  }
}
