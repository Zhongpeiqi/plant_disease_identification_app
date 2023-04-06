import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/net/NetRequester.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/page/feed/articlePage.dart';
import 'package:plant_disease_identification_app/ui/page/settingPage.dart';
import 'package:plant_disease_identification_app/ui/page/themeChangePage.dart';
import 'package:plant_disease_identification_app/ui/page/updateUserDetailPage.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';
import 'package:plant_disease_identification_app/widgets/showDialog.dart';
import 'package:provider/provider.dart';

import '../../model/disease.dart';
import '../../model/history.dart';
import '../../net/Api.dart';
import '../../net/BaseBean.dart';
import '../../state/global.dart';
import 'identifyDetailPage.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key, int? userId, String? username});

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  late bool _offLittleAvatar;
  late ScrollController _scrollController;

  //刷新列表
  Future refreshHistory() async {
    Global.profile.historyList!.clear();
    Global.saveProfile();
    var res = await NetRequester.dio
        .post(Api.queryHistoryByUserId(Global.profile.user!.id!));
    var data = res.data['data'];
    for (var item in data) {
      var history = History.fromJson(item);
      Global.profile.historyList?.add(history);
    }
    Global.saveProfile();
    setState(() {});
  }

  @override
  void initState() {
    refreshHistory();
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
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Offstage(
          offstage: _offLittleAvatar,
          child: SizedBox(
            width: ScreenUtil().setWidth(90),
            height: ScreenUtil().setWidth(90),
            child: CircleAvatar(
              backgroundImage: NetworkImage(Global.profile.user!.avatarUrl!),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            child: IconButton(
              splashRadius: 25.0,
              icon: const Icon(
                MyIcons.setting,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(() => const SettingPage());
              },
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          _buildShowUserInfo(),
          _buildFunGrid(),
          _buildHistory(),
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
            InkWell(
              onTap: () {
                Get.to(() => const UpdateUserDetailPage());
              },
              child: Container(
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
                            backgroundImage: Global.profile.user!.avatarUrl ==
                                    null
                                ? const AssetImage("assets/img/author.png")
                                : NetworkImage(Global.profile.user!.avatarUrl!)
                                    as ImageProvider,
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
                              model.user.username ?? "张三",
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
                    //箭头跳转到信息修改界面
                    Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(70),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(44),
                          ),
                          child: IconButton(
                            icon: Icon(
                              MyIcons.right,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            ),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                    _buildShowNum(
                        Global.profile.user!.postNum.toString(), '记录', 1),
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
                    _buildShowNum(
                        Global.profile.user!.likedNum.toString(), '点赞', 3),
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
  Widget _buildShowNum(String num, String label, int type) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case 1:
            Get.to(() => ArticlePage(
                  userId: Global.profile.user!.id,
                  type: 5,
                ));
            break;
          case 2:
            // Get.to(() => const ArticlePage(type: 5,));
            break;
          case 3:
            Get.to(() => ArticlePage(
                  userId: Global.profile.user!.id,
                  type: 4,
                ));
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

  Widget _buildFunGrid() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(24), vertical: 10),
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildGridItem(
                    const Icon(
                      MyIcons.like,
                      color: Colors.redAccent,
                    ),
                    '我的点赞', () {
                  Get.to(() => const ArticlePage(
                        type: 4,
                      ));
                }),
                _buildGridItem(
                    const Icon(
                      MyIcons.skin,
                      color: Colors.pinkAccent,
                    ),
                    '主题风格', () {
                  Get.to(() => const ThemeChangePage());
                }),
                Consumer<ThemeModel>(builder: (context, themeModel, _) {
                  return _buildGridItem(
                      Icon(themeModel.isDark ? Icons.sunny : MyIcons.moon,
                          color: Colors.purpleAccent),
                      themeModel.isDark ? '日间模式' : '夜间模式', () {
                    themeModel.isDark = !themeModel.isDark;
                  });
                }),
                _buildGridItem(
                    const Icon(
                      MyIcons.and_more,
                      color: Colors.orangeAccent,
                    ),
                    '更多',
                    () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(Icon icon, String label, Function() function) {
    return SizedBox(
      width: ScreenUtil().setWidth(255),
      child: TextButton(
        onPressed: function,
        child: Column(
          children: <Widget>[
            icon,
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text(label)
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        double globalPositionX = details.globalPosition.dx;
        double globalPositionY = details.globalPosition.dy + 10;
        onLongPress(context, globalPositionX, globalPositionY, 1);
      },
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(24), vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyListTile(
                  left: 40,
                  leading: Text(
                    '识别历史',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil().setSp(54)),
                  ),
                  trailing: SizedBox(
                    height: ScreenUtil().setHeight(70),
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 25.0,
                          onPressed: () async{
                            refreshHistory();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.green,
                            size: 27,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          splashRadius: 25.0,
                          onPressed: () {
                            _showDialog(context);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: ScreenUtil().setHeight(800),
                child: ListView.builder(
                    itemCount: Global.profile.historyList?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => _buildHistoryItem(
                        Global.profile.historyList![index].date!,
                        Global.profile.historyList![index].imageUrl!,
                        Global.profile.historyList![index].name!,
                        (Global.profile.historyList![index].accuracy!/100),
                        Global.profile.historyList![index].tag!
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String date, String imgUrl, String name,double accuracy,int tag) {
    return MyListTile(
      left: 40,
      onTap: () async{
        var response = await NetRequester.dio
            .post(Api.getDiseaseById(tag));
        var data = BaseBean.fromJson(response.data);
        if (data.status == 200 && data.data != null) {
          var disease = Disease.fromJson(data.data);
          disease.accuracy = (accuracy*100).toInt();
          disease.imgUrl = imgUrl;
          disease.date = date;
          Get.to(() => IdentifyDetailPage(disease: disease));
        }
      },
      leading: Column(
        children: [
          Text(
            date,
            style: TextStyle(
                color: Colors.black54,
                fontSize: ScreenUtil().setSp(30),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(6),
          ),
          ExtendedImage.network(imgUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))),
        ],
      ),
      center: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            Container(
              width: ScreenUtil().setWidth(500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(500),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: ScreenUtil().setSp(64)),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(15),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(500),
              child: Text(
                '置信度${accuracy.toStringAsFixed(2)}%',
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
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => MyDialog(
              text: "是否清空所有记录",
              onPress: () async {
                var res = await NetRequester.dio
                    .post(Api.deleteAll(Global.profile.user!.id!));
                if (res.data['status'] == 200) {
                  Global.profile.historyList?.clear();
                  Global.saveProfile();
                  setState(() {});
                  Toast.popToast("清空成功");
                } else {
                  Toast.popToast("清空失败");
                }
                Navigator.of(context).pop();
              },
            ));
  }

  //长按触发弹出菜单
  void onLongPress(BuildContext context, double x, double y, int index) {
    //当添加图片当图片被点击时候
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTRB(x, y, x + 50, y - 50),
      Offset.zero & overlay.size,
    );
    PopupMenuItem deleteItem = PopupMenuItem(
      value: "delete",
      child: Row(
        children: const [
          Icon(
            Icons.delete,
            color: Colors.red,
          ),
          SizedBox(width: 10),
          Text(
            "删除记录",
          )
        ],
      ),
    );
    List<PopupMenuEntry<dynamic>> list = [deleteItem]; //菜单栏需要显示的菜单项集合
    showMenu(context: context, position: position, items: list).then((value) {
      if (value == "delete") {
        showDialog(
            context: context,
            builder: (context) => MyDialog(
                  text: "是否删除该识别记录",
                  onPress: () async {
                    var res = await NetRequester.dio.post(
                        Api.delete(Global.profile.historyList![index].id!));
                    if (res.data['status'] == 200) {
                      Toast.popToast("删除成功");
                      Global.profile.historyList?.removeAt(index);
                      Global.saveProfile();
                      setState(() {});
                    } else {
                      Toast.popToast("删除失败");
                    }
                    Navigator.of(context).pop();
                  },
                ));
      }
    });
    // PopupMenuButton
  }

  @override
  bool get wantKeepAlive => true;
}
