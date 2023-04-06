import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/ui/page/auth/signin.dart';
import '../../../net/Api.dart';
import '../../../net/NetRequester.dart';
import '../../../utils/toast.dart';
import '../../../widgets/customWidgets.dart';
import '../../theme/theme.dart';
import '../../../widgets/customFlatButton.dart';

class Signup extends StatefulWidget {
  final VoidCallback? loginCallback;

  const Signup({Key? key, this.loginCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;
  late TextEditingController _codeController;
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  final _formKey = GlobalKey<FormState>();
  late Timer _timer;
  late int _countdownTime;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _codeController = TextEditingController();
    _countdownTime = 60;
    startCountdownTimer;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("assets/img/flutter_logo.png"),
              width: 70.0,
              height: 70.0,
            ),
            _entryField('请输入名字', controller: _nameController),
            _entryField('请输入邮箱', controller: _emailController, isEmail: true),
            _entryField('请输入密码',
                controller: _passwordController, isPassword: true),
            _entryField('再次确认密码',
                controller: _confirmController, isPassword: true),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _codeController,
              decoration: InputDecoration(
                  labelText: "验证码",
                  hintText: "点击右侧获取",
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  icon: const Icon(Icons.security),
                  suffix: GestureDetector(
                    onTap: () async {
                      if ((_formKey.currentState as FormState).validate()) {
                        startCountdownTimer(); //点击后开始倒计时
                        Toast.popToast("验证码发送中，请稍等");
                        //请求发送验证码
                        String email = _emailController.text;
                        var result = await NetRequester.dio.post(Api.sendEmail(email));
                        if (result.data["status"] == 200) {
                          Toast.popToast("验证码已发送请注意查收");
                        } else {
                          Toast.popToast("请检查网络或反馈错误 ");
                        }
                      }
                    },
                    child: Text(
                      _countdownTime == 60 ? '获取验证码' : '$_countdownTime秒后重新获取',
                      style: TextStyle(
                        color: _countdownTime == 60
                            ?  Theme.of(context).primaryColor
                            : const Color.fromARGB(255, 183, 184, 195),
                      ),
                    ),
                  )),
            ),
            _submitButton(context),
            const SizedBox(height: 20),
            _labelButton('登陆账号', onPressed: () {
              Get.to(() => const SignIn());
            }),
            const Divider(height: 30),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String hint,
      {required TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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
          suffixIcon: isPassword
              ? IconButton(
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
                )
              : null,
        ),
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

  void startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_countdownTime == 0) {
        _timer.cancel();
        if(mounted){
          setState(() {
            _countdownTime = 60;
          });
        }
      }else{
        if(mounted){
          setState(() {
            _countdownTime--;
          });
        }
      }
    });
  } //倒计时实现方法

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: "注册",
        onPressed: () => _submitForm(context),
        borderRadius: 30,
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    var emailReg = RegExp(
        r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
    if(_passwordController.text.isEmpty || _emailController.text.isEmpty || _nameController.text.isEmpty || _confirmController.text.isEmpty){
      Toast.popToast("请输入完整信息");
    }else
    if (!emailReg.hasMatch(_emailController.text)) {
      Toast.popToast("请输入正确的邮箱");
    }else
    if(_passwordController.text.length < 6){
      Toast.popToast("密码长度不能小于6");
    }else
    if(_passwordController.text != _confirmController.text){
      Toast.popToast("两次密码输入不一致");
    }else{
      Map<String,dynamic> map = {};
      map["name"] = _nameController.text;
      map["code"] = _codeController.text;
      map["password"] = _passwordController.text;
      map["email"] = _emailController.text;
      var result = await NetRequester.request('/user/register',data: map);
      //根据服务器返回结果进行提示
      if (result !=null){
        if(result.data['status']==200){
          Get.to(() => const SignIn());
        }
        Toast.popToast(result.data['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText(
          '注册',
          context: context,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
