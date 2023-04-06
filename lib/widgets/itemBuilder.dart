import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_disease_identification_app/model/comment.dart';
import 'package:plant_disease_identification_app/model/profile.dart';
import 'package:plant_disease_identification_app/ui/page/minePage.dart';
import 'package:plant_disease_identification_app/ui/page/profilePage.dart';
import '../listRepository/commentRepository.dart';
import '../model/user.dart';
import '../ui/page/viewImgPage.dart';
import '../utils/buildDate.dart';
import '../utils/specialText/special_textspan.dart';
import 'myListTile.dart';

class ItemBuilder {
  static Widget buildUserRow(BuildContext context, User user) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
          onTap: () {
            Get.to(() => ProfilePage(user: user));
          },
          left: 40,
          leading: SizedBox(
            height: ScreenUtil().setHeight(110),
            child: ClipOval(child: ExtendedImage.network(user.avatarUrl!, cache: true),
            ),
          ),
          center: SizedBox(
            height:ScreenUtil().setHeight(110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(user.username ?? '张三',
                    style: TextStyle(fontSize: ScreenUtil().setSp(48))),
                Row(
                  children: <Widget>[
                    Text('${user.postNum}笔记',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(34))),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Text('${user.likedNum}点赞',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(34))),
                  ],
                ),
              ],
            ),
          ),
          trailing: null
      ),
    );
  }

  static buildComment(BuildContext context, Comment comment,
      CommentRepository list, int index) {
    String reply;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
        onTap: () {
        },
        left: 40,
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(
                    builder: (context) => MinePage(userId: comment.userId)));
          },
          child: SizedBox(
            height: ScreenUtil().setHeight(110),
            child:
            ClipOval(
              child: ExtendedImage.network(comment.icon!, cache: true),
            ),
          ),
        ),
        center: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(comment.name ?? '张三',
                    style: TextStyle(fontSize: ScreenUtil().setSp(48))),
                SizedBox(width: ScreenUtil().setWidth(500),),
              ],
            ),
            Text(buildDate(comment.date!),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenUtil().setSp(34))),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ExtendedText(
              comment.text!,
              style: TextStyle(fontSize: ScreenUtil().setSp(46)),
              specialTextSpanBuilder:
              MySpecialTextSpanBuilder(context: context),
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            comment.imageUrl != ''
                ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewImgPage(
                                  images: comment.imageUrl!.split(','),
                                  index: 0,
                                  postId: comment.id.toString())));
                },
                child: Hero(
                    tag: '${comment.id}${comment.imageUrl}0',
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: ScreenUtil().setHeight(500),
                            maxWidth: ScreenUtil().setWidth(500)),
                        child: ExtendedImage.network(
                            comment.imageUrl!,
                            cache: true,
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.black12, width: 0.5),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(21))))))
                : const SizedBox(height: 0),
            SizedBox(height: ScreenUtil().setHeight(10)),
            Container(
              width: ScreenUtil().setWidth(800),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: Colors.grey[200]!)
              ),
            )
          ],
        ),
      ),
    );
  }

}

