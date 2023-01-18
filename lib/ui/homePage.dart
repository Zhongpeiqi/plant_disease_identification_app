import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/data/tabData.dart';
import 'package:plant_disease_identification_app/ui/page/articlePage.dart';
import 'package:plant_disease_identification_app/ui/page/identifyPage.dart';
import 'package:plant_disease_identification_app/ui/page/notePage.dart';
import 'package:plant_disease_identification_app/ui/page/profilePage.dart';
import 'package:plant_disease_identification_app/ui/page/searchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> screens = const[
    ArticlePage(),
    SearchPage(),
    IdentifyPage(),
    NotePage(),
    ProfilePage(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const ArticlePage(); // Our first view in viewport
  final _pageController = PageController(
    //初始索引
    initialPage: 0,
  );

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
        onPressed: () => onTap(2),
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
        // setState(() {
        //   //更新索引值
        //   _currentIndex = value;
        // });
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


}
