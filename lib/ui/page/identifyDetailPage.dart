import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/ui/page/webViewPage.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';
import 'package:get/get.dart';

class IdentifyDetailPage extends StatefulWidget {
  const IdentifyDetailPage({Key? key}) : super(key: key);

  @override
  State<IdentifyDetailPage> createState() => _IdentifyDetailPageState();
}

class _IdentifyDetailPageState extends State<IdentifyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("识别记录详情"),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            child: IconButton(
              icon: const Icon(
                MyIcons.setting,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Card(
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
        ),
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(40),
          top: ScreenUtil().setWidth(50),
          right: ScreenUtil().setWidth(40),
          bottom: ScreenUtil().setWidth(15),
        ),
        child: SizedBox(
          width: ScreenUtil().setWidth(1200),
          height: ScreenUtil().setWidth(1800),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 25.0, right: 18.0, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2023年01月18日",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: ScreenUtil().setWidth(50)),
                Center(
                  child: ExtendedImage.asset("assets/img/example1.jpg",
                      width: ScreenUtil().setWidth(1000),
                      height: ScreenUtil().setWidth(1000),
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(21))),
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                GestureDetector(
                  onTap: (){
                    Get.to(() =>  const WebViewPage("https://baike.baidu.com/item/水稻稻瘟病","水稻稻瘟病"));
                  },
                  child: MyListTile(
                    left: 0,
                    leading: Column(
                      children: [
                        ExtendedImage.asset("assets/img/example1.jpg",
                            width: ScreenUtil().setWidth(400),
                            height: ScreenUtil().setWidth(400),
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.black12, width: 1),
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(21))),
                        SizedBox(height: ScreenUtil().setWidth(20)),
                        Text(
                          "可信度30%",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: ScreenUtil().setSp(35)),
                        ),
                      ],
                    ),
                    center: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil().setHeight(35),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              '水稻',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: ScreenUtil().setSp(45)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              '叶片、茎秆、穗部',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: ScreenUtil().setSp(45)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '水稻稻瘟病',
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(64)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(400),
                            child: Text(
                              'PyriculariaoryaeCav',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: ScreenUtil().setSp(50),
                                  fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
