import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/model/disease.dart';
import 'package:plant_disease_identification_app/model/history.dart';
import 'package:plant_disease_identification_app/net/UploadUtils.dart';
import 'package:plant_disease_identification_app/net/disease_entity.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/page/identifyDetailPage.dart';
import 'package:plant_disease_identification_app/ui/page/minePage.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';

import '../../config/net_config.dart';
import '../../net/Api.dart';
import '../../net/BaseBean.dart';
import '../../net/NetRequester.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IdentifyPageState();
  }
}

class _IdentifyPageState extends State<IdentifyPage> {
  //记录每次选择的图片
  final List<File> _images = [];
  final picker = ImagePicker();
  bool isChoose = false;

  Future getImage(bool isTakePhoto) async {
    Navigator.pop(context);
    try {
      var image = await ImagePicker().pickImage(
          source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
      if (image == null) {
        // Toast.popToast("图片数量有误");
        return;
      } else {
        setState(() {
          print(image.path);
          _images.add(File(image.path));
          isChoose = !isChoose;
        });
      }
    } catch (e) {
      print("模拟器不支持相机！");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('识别叶片疾病'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.transparent,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: _generateImages(),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 60,
        child: FloatingActionButton.extended(
          onPressed: !isChoose ? _pickImage : _identify,
          tooltip: !isChoose ? '选择图片' : '识别叶片疾病',
          label: !isChoose
              ? const Icon(
                  Icons.add_a_photo,
                  size: 30,
                )
              : const Icon(
                  Icons.check_sharp,
                  size: 30,
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _takePhotoItem(String title, bool isTakePhoto) {
    return GestureDetector(
      child: ListTile(
        leading: Icon(
          isTakePhoto ? Icons.camera_alt : Icons.photo_library,
        ),
        title: Text(title),
        onTap: () => getImage(isTakePhoto),
      ),
    );
  }

  ///底部弹框
  _pickImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: 130,
              child: Column(
                children: <Widget>[
                  _takePhotoItem('拍照', true),
                  _takePhotoItem('从相册选择', false),
                ],
              ),
            ));
  }

  /// 封装图片面板
  _generateImages() {
    return _images.map((file) {
      return Stack(
        children: <Widget>[
          ClipRRect(
            //圆角效果
            borderRadius: BorderRadius.circular(10),
            child: Image.file(file, width: 300, height: 300, fit: BoxFit.cover),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _images.remove(file);
                  isChoose = !isChoose;
                });
              },
              child: ClipOval(
                //圆角删除按钮
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  //识别疾病
  Future<void> _identify() async {
    try {
      Toast.popLoading('识别中...', 30);
      var res = await UpLoad.upLoadByFile("pics", _images[0], NetConfig.aiIp);
      var upRes = await UpLoad.upLoadByFile(
          "image", _images[0], "${NetConfig.ip}upload/image");
      if (res.statusCode != 200 || res.statusCode != 200) {
        Toast.popToast('上传失败请重试');
      } else {
        var diseaseEntity = DiseaseEntity.fromJson(res.data[0]);
        var response = await NetRequester.dio
            .post(Api.getDiseaseById(diseaseEntity.tag.toInt()));
        var data = BaseBean.fromJson(response.data);

        if (data.status == 200 && data.data != null) {
          var disease = Disease.fromJson(data.data);
          disease.accuracy = (diseaseEntity.accuracy * 10000).toInt();
          disease.imgUrl = upRes.data['data'];
          disease.date = DateTime.now().toString().substring(0, 19);
          var history = History(
              userId: Global.profile.user!.id!,
              name: disease.name,
              type: disease.type,
              accuracy: disease.accuracy,
              imageUrl: disease.imgUrl,
              tag: disease.id,
              date: disease.date);
          var res = await NetRequester.dio.post("/history/add",data: history.toJson());
          if(res.data['status']==200){
            Global.profile.historyList!.insert(Global.profile.historyList!.isEmpty? 0 : Global.profile.historyList!.length-1, history);
            Global.saveProfile();
          }
          Get.to(() => IdentifyDetailPage(disease: disease));
          Toast.popToast("识别成功!");
        }
      }
    } catch (e) {
      print(e.toString());
    }
    // Toast.popToast("识别叶片疾病");
  }
}
