import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/model/disease.dart';
import 'package:plant_disease_identification_app/ui/page/webViewPage.dart';
import '../../widgets/customFlatButton.dart';
import 'feedBackPage.dart';

class IdentifyDetailPage extends StatefulWidget {
  final Disease disease;

  const IdentifyDetailPage({Key? key, required this.disease}) : super(key: key);

  @override
  State<IdentifyDetailPage> createState() => _IdentifyDetailPageState();
}

class _IdentifyDetailPageState extends State<IdentifyDetailPage> {
  @override
  Widget build(BuildContext context) {
    var res = widget.disease.accuracy! / 100;
    var accuracy = res.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: const Text("识别记录详情"),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            child: IconButton(
              icon: const Icon(
                MyIcons.comment,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(() => const FeedBackPage(
                    "https://support.qq.com/product/536336", "反馈中心"));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ExtendedImage.network(widget.disease.imgUrl!,
                    fit: BoxFit.cover,
                    height: ScreenUtil().setHeight(500),
                    width: ScreenUtil().screenWidth,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(21))),
              ),
              Container(
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().screenWidth,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          Text(
                            widget.disease.date!,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(45),
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().screenWidth,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          Text(
                            widget.disease.name!,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(55),
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().screenWidth,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          Text(
                            widget.disease.nameEng!,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(55),
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().screenWidth,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          Text(
                            "置信度$accuracy%",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: ScreenUtil().setSp(55)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Container(
                      height: ScreenUtil().setHeight(100),
                      width: ScreenUtil().screenWidth,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          Text(
                            "疾病种类: ",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: ScreenUtil().setSp(55)),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(40)),
                          buildLabel(context, widget.disease.type!)
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                width: ScreenUtil().screenWidth,
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "致病原因",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.black),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                      widget.disease.cause!,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(45),
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                width: ScreenUtil().screenWidth,
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "感染后果",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.black),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                      widget.disease.result!,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(45),
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                width: ScreenUtil().screenWidth,
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "疾病症状",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.black),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                      widget.disease.symptom!,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(45),
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                width: ScreenUtil().screenWidth,
                decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "防治建议",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.black),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Text(
                      widget.disease.suggestion!,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(45),
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Center(
                child: GestureDetector(
                  onTap: () {
                    var name = widget.disease.name!;
                    Get.to(() => WebViewPage(
                        "https://baike.baidu.com/item/$name", name));
                  },
                  child: Text("点击跳转百度百科 >",style: TextStyle(
                      fontSize: ScreenUtil().setSp(55),
                    color: Colors.blue),),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
            ],
          ),
        ),
      ),
    );
  }

  TextButton buildLabel(BuildContext context, String label) {
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(60)))),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor.withOpacity(0.8))),
        onPressed: () {},
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(55), color: Colors.white),
          ),
        ));
  }
}
