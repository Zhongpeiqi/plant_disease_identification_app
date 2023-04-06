import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/data/tabData.dart';
import 'package:plant_disease_identification_app/ui/page/feed/articlePage.dart';
import 'package:plant_disease_identification_app/ui/page/identifyPage.dart';
import 'package:plant_disease_identification_app/ui/page/notePage.dart';
import 'package:plant_disease_identification_app/ui/page/minePage.dart';
import 'package:plant_disease_identification_app/ui/page/searchPage.dart';

import '../utils/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> screens = const[
    ArticlePage(type: 1,),
    SearchPage(),
    NotePage(),
    MinePage(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const ArticlePage(); // Our first view in viewport
  final _pageController = PageController(
    //初始索引
    initialPage: 0,
    keepPage: false
  );

  //记录每次选择的图片
  late File _image;
  final picker = ImagePicker();
  Future getImage(bool isTakePhoto) async {
    Navigator.pop(context);
    try {
      var image = await ImagePicker().pickImage(
          source:isTakePhoto ? ImageSource.camera :ImageSource.gallery
      );
      if (image == null) {
        return;
      } else {
        Toast.popToast("拍照成功");
        setState(() {
          // _image = image;
          _image = File(image.path);
        });
      }
    } catch (e) {
      print("模拟器不支持相机！");
    }
  }

  @override
  void dispose() {
    super.dispose();
    /// 销毁 PageView 控制器
    _pageController.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        //页面滑动
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        //设置组件数组
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(() => const IdentifyPage());
        },
        backgroundColor: Colors.green,
        child: const Icon(
          MyIcons.scan,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.green,
      onTap: (value){
        //控制pageView跳转到指定页面
        onTap(value);
        setState(() {
          //更新索引值
          _currentIndex = value;
        });
      },

      items: datas.map((data){
        return BottomNavigationBarItem(
          /// 默认状态下的图标, 灰色
            icon: Icon(
              data.icon,
              color: Colors.grey,
            ),
            /// 选中状态下的图标
            activeIcon: Icon(
              data.icon,
              color: Colors.green,
            ),
            /// 根据当前页面是否选中 , 确定
            label: data.title
        );
      }).toList(),
    );
  }

  void onTap(int value) {
    _pageController.jumpToPage(value);
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
    showModalBottomSheet(context: context, builder: (context) => SizedBox(
      height: 130,
      child: Column(
        children: <Widget>[
          _takePhotoItem('拍照',true),
          _takePhotoItem('从相册选择',false),
        ],
      ),
    ));
  }

  /// 封装图片面板
  _generateImages() {
    return Stack(
      children: <Widget>[
        ClipRRect(
          //圆角效果
          borderRadius: BorderRadius.circular(10),
          child: Image.file(_image,width: 120,height: 90,fit:BoxFit.cover),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: ClipOval(
              //圆角删除按钮
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.black54),
                child: const Icon(Icons.close,size: 20,color: Colors.white,),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
