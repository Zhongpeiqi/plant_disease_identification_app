import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oktoast/oktoast.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/state/profileChangeNotifier.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init();
  //设置状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //锁定竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserModel()),
          ChangeNotifierProvider.value(value: ThemeModel()),
        ],
        child: const MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return OKToast(
          dismissOtherOnShow: true,
          child: Consumer<ThemeModel>(
            builder: (context,ThemeModel themeModel,_){
              return GetMaterialApp(
                title: 'Leaf disease detection',
                debugShowCheckedModeBanner: false,
                home: const HomePage(),
                theme: themeModel.isDark
                    ? ThemeData(brightness: Brightness.dark)
                    : ThemeData(primarySwatch: createMaterialColor(themeModel.theme),
                    scaffoldBackgroundColor: const Color(0xfff2f2f6)
                ),
              );
            },
          ),
        );
      },
    );

  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red,
      g = color.green,
      b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
