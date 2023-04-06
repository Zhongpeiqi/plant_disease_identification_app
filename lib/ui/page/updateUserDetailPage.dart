import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:plant_disease_identification_app/ui/page/changeAvatarPage.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';
import 'package:provider/provider.dart';
import '../../net/NetRequester.dart';
import '../../state/global.dart';

class UpdateUserDetailPage extends StatefulWidget {
  const UpdateUserDetailPage({Key? key}) : super(key: key);

  @override
  State<UpdateUserDetailPage> createState() => _UpdateUserDetailPageState();
}

class _UpdateUserDetailPageState extends State<UpdateUserDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Get.to(() => const HomePage());
          },
        ),
        title: const Text('编辑资料'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-8),
          child: Container(),
        ),
      ),
      body: Consumer<UserModel>(
        builder: (BuildContext context, model, _) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              MyListTile(
                left: 40,
                onTap: () {
                  Get.to(() => const ChangeAvatarPage(type: 1,));
                },
                leading: Text('头像',
                    style: TextStyle(fontSize: ScreenUtil().setSp(44))),
                trailing: SizedBox(
                  height: 150.w,
                  width: 150.w,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(Global.profile.user!.avatarUrl!),
                  ),
                ),
              ),
              Divider(indent: ScreenUtil().setWidth(40),endIndent: ScreenUtil().setWidth(40),height: 1,),
              MyListTile(
                left: 40,
                leading: const Text('用户名'),
                trailing: SizedBox(
                    height: 150.w, width: 150.w, child: Center(child: Text(model.user.username ?? "张三",))),
                onTap: () {
                  showEditUsername(context,model);
                },
              ),
              Divider(indent: ScreenUtil().setWidth(40),endIndent: ScreenUtil().setWidth(40),height: 1,),
            ],
          );
        },
      ),
    );
  }

  //用户名
  showEditUsername(BuildContext context,UserModel model) {
    TextEditingController controller = TextEditingController();
    controller.text = Global.profile.user!.username!;
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.black26,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setHeight(1920),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: ScreenUtil().setHeight(410)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(48),
                          vertical: ScreenUtil().setHeight(30)),
                      color: Colors.white,
                      child: TextField(
                        controller: controller,
                        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                        maxLength: 15,
                        autofocus: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          helperText: '若提示用户名已存在，请换一个尝试',
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: '修改用户名',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  ScreenUtil().setWidth(21)), //边角为30
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(20),
                              horizontal: ScreenUtil().setWidth(20)),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('取消',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('确定',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                            onPressed: () async {
                              if (controller.text.length > 15) {
                                Toast.popToast('长度超出上限');
                              } else if(controller.text.isEmpty){
                                Toast.popToast('请输入正确的名字');
                              }else {
                                Map<String, dynamic> map = {};
                                map["id"] = Global.profile.user!.id;
                                map["username"] = controller.text;
                                map["avatarUrl"] = Global.profile.user!.avatarUrl;
                                var result = await NetRequester.request(
                                    '/user/updateUserDetail',
                                    data: map);
                                Toast.popToast(result.data['msg']);
                                if(result.data['status'] == 200){
                                  setState(() {});
                                  var username = controller.text;
                                  model.user.username = username;
                                  model.notifyListeners();
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
