import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:plant_disease_identification_app/ui/page/identifyDetailPage.dart';
import 'package:plant_disease_identification_app/ui/page/settingPage.dart';
import 'package:plant_disease_identification_app/ui/page/themeChangePage.dart';
import 'package:plant_disease_identification_app/ui/page/updateUserDetailPage.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';
import 'package:plant_disease_identification_app/widgets/showDialog.dart';
import 'package:provider/provider.dart';

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
              backgroundImage: Global.profile.user?.avatarUrl == null
                  ? const AssetImage("assets/img/author.png")
                  : NetworkImage(
                          '${NetConfig.ip}/images/${Global.profile.user!.avatarUrl}')
                      as ImageProvider,
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
                Get.to(() =>  const SettingPage());
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

  //????????????????????????????????????????????????
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
                    //???????????????
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: CircleAvatar(
                            backgroundImage: Global.profile.user?.avatarUrl ==
                                    null
                                ? const AssetImage("assets/img/author.png")
                                : NetworkImage(
                                        '${NetConfig.ip}/images/${Global.profile.user!.avatarUrl}')
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
                              "??????",
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
                    //?????????????????????????????????
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
                    _buildShowNum('0', '??????', const HomePage()),
                    Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[300]!, width: 0.5))),
                    _buildShowNum('0', '??????', const HomePage()),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 0.5)),
                    ),
                    _buildShowNum('0', '??????', const HomePage()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //?????????????????????????????????
  Widget _buildShowNum(String num, String label, Widget page) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
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
                    '????????????', () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HomePage()));
                }),
                _buildGridItem(
                    const Icon(
                      MyIcons.skin,
                      color: Colors.pinkAccent,
                    ),
                    '????????????', () {
                  Get.to(() => const ThemeChangePage());
                }),
                Consumer<ThemeModel>(builder: (context, themeModel, _) {
                  return _buildGridItem(
                      Icon(themeModel.isDark ? Icons.sunny : MyIcons.moon,
                          color: Colors.purpleAccent),
                      themeModel.isDark ? '????????????' : '????????????', () {
                    themeModel.isDark = !themeModel.isDark;
                  });
                }),
                _buildGridItem(
                    const Icon(
                      MyIcons.and_more,
                      color: Colors.orangeAccent,
                    ),
                    '??????',
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
      onTap: (){
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const IdentifyDetailPage()));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(24), vertical: 10),
        child: Column(
          children: <Widget>[
            MyListTile(
                left: 40,
                leading: Text(
                  '????????????',
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
                        onPressed: () {
                          _showDialog(context);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 27,
                        ),
                      )
                    ],
                  ),
                )),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
            _buildHistoryItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem() {
    return MyListTile(
      left: 40,
      leading: Column(
        children: [
          Text(
            '2023/01/18',
            style: TextStyle(
                color: Colors.black54, fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ScreenUtil().setHeight(6),),
          ExtendedImage.asset(
            "assets/img/example1.jpg",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black12,width: 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
          ),
        ],
      ),
      center: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(35),),
            SizedBox(
              width: ScreenUtil().setWidth(600),
              child: Text(
                '??????',
                style: TextStyle(
                    color: Colors.blueGrey, fontSize: ScreenUtil().setSp(45)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(15),),
            SizedBox(
              width: ScreenUtil().setWidth(600),
              child: Text(
                '????????????????????????',
                style: TextStyle(
                    color: Colors.blueGrey, fontSize: ScreenUtil().setSp(45)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '???????????????',
                  style: TextStyle(fontSize: ScreenUtil().setSp(64)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(15),),
            SizedBox(
              width: ScreenUtil().setWidth(600),
              child: Text(
                'PyriculariaoryaeCav',
                style: TextStyle(
                    color: Colors.blueGrey, fontSize: ScreenUtil().setSp(50),fontStyle: FontStyle.italic),
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
              text: "????????????????????????",
              onPress: () {
                Toast.popToast("????????????");
                Navigator.of(context).pop();
              },
            ));
  }

  //????????????????????????
  void onLongPress(BuildContext context, double x, double y, int index) {
    //???????????????????????????????????????
    final RenderBox overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
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
            "????????????",
          )
        ],
      ),
    );
    List<PopupMenuEntry<dynamic>> list = [
      deleteItem
    ]; //???????????????????????????????????????
    showMenu(context: context, position: position, items: list).then((value) {
      if (value == "delete") {
        showDialog(
            context: context,
            builder: (context) => MyDialog(
              text: "???????????????????????????",
              onPress: () {
                Toast.popToast("????????????");
                Navigator.of(context).pop();
              },
            ));
      } else if (value == "update") {

      }
    });
    // PopupMenuButton
  }

  @override
  bool get wantKeepAlive => true;
}
