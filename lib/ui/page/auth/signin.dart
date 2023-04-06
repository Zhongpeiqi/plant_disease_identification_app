import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:plant_disease_identification_app/ui/page/auth/signup.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user.dart';
import '../../../net/NetRequester.dart';
import '../../../widgets/customFlatButton.dart';
import '../../../widgets/customWidgets.dart';
import '../../theme/theme.dart';

class SignIn extends StatefulWidget {
  final VoidCallback? loginCallback; //!

  const SignIn({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: kToolbarHeight + 20.0,
              ), //顶部填充
              const Image(
                image: AssetImage("assets/img/flutter_logo.png"),
                width: 70.0,
                height: 70.0,
              ),
              const SizedBox(height: 40.0),
              _entryField('请输入邮箱', controller: _emailController),
              _entryField('请输入密码',
                  controller: _passwordController, isPassword: true),
              _emailLoginButton(context),
              const SizedBox(height: 20),
              _labelButton('注册账号', onPressed: () {
                Get.to(() => const Signup());
              }),
              const Divider(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryField(String hint,
      {required TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword ? _isObscure : false,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: isPassword ?IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure
                    ? Colors.grey
                    : Theme.of(context).primaryColor;
              });
            },
          ) : null,
        ),
        validator: (val){
          if(isPassword){
            return val!.trim().length > 5 ? null : "密码不能少于6位";
          }else{
            var emailReg = RegExp(
                r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
            if (!emailReg.hasMatch(val!)) {
              return '请输入正确的邮箱地址';
            }
          }
        },
      ),
    );
  }

  Widget _labelButton(String title, {Function? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Text(
        title,
        style: TextStyle(
            color: TwitterColor.dodgeBlue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: "登录",
        onPressed: _emailLogin,
        borderRadius: 30,
      ),
    );
  }

  void _emailLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if((_formKey.currentState as FormState).validate()){
      Map<String,dynamic> map = {};
      map["password"] = _passwordController.text;
      map["email"] = _emailController.text;
      var result = await NetRequester.request('/user/login',data: map);
      //根据服务器返回结果进行提示
      if (result !=null){
        if(result.data['status']==200){
          prefs.setString("token", result.data['data']);
          Get.to(() => const HomePage());
          var userRes = await NetRequester.request("/user/getCurUserInfo");
          var user = User.fromJson(userRes.data["data"]);
          Global.profile.user = user;
          UserModel().notifyListeners();
        }
        Toast.popToast(result.data['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText('登录',
            context: context, style: const TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}
