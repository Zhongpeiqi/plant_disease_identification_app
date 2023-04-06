import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:plant_disease_identification_app/net/BaseBean.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/net_config.dart';
import '../state/global.dart';
import '../utils/logger.dart';
import '../utils/toast.dart';

class NetRequester {
  static var options = BaseOptions(
    baseUrl: Global.profile.ip ?? NetConfig.ip,
    contentType: Headers.formUrlEncodedContentType,
  );

  static Dio dio = Dio(options);
  static Response _response = Response(requestOptions: RequestOptions(responseType: ResponseType.json));
  

  /// 通用的网络请求方法，需传入@param[url]，
  /// @param[data]是可选参数，大部分[ApiAddress]返回的都是带参数的url，不需要[data]，提交审批结果那里是需要data的
  /// @param[file]也是可选参数，是上传图片的时候需要用到的
  static Future request(String url, {FormData? file, Map<String,dynamic>? data}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var newOptions = BaseOptions(
        baseUrl: NetConfig.ip,
        contentType: Headers.jsonContentType,
        headers: {}
    );
    if(!url.contains("login") && !url.contains("code") && !url.contains("register")){
      newOptions.headers.addAll({"Authorization": _prefs.getString("token")});
    }
    dio = Dio(newOptions);
    try {
      if (data != null) {
        _response = await dio.post(url, data: data);
      } else if (file != null) {
        _response = await dio.post(url, data: file);
      } else {
        _response = await dio.get(url);
      }
      //获取验证码的时候需要cookie
      if (url.contains("sendEmail")) {
        //print(_response.headers.toString());
        var sessionId = _response.headers.value("set-cookie")?.substring(0, 43);
        if (dio.options.headers.containsKey('cookie')) {
          dio.options.headers['cookie'] = sessionId;
        } else {
          dio.options.headers.addAll({'cookie': sessionId});
        }
      }
    } on DioError catch (e) {
      print('dioError:::::$e');
      switch (e.type) {
        case DioErrorType.cancel:
          Toast.popToast('请求已取消');
          break;
        case DioErrorType.connectionTimeout:
          Toast.popToast('连接超时', ToastPosition.center);
          break;
        case DioErrorType.receiveTimeout:
          Toast.popToast('接收数据超时', ToastPosition.center);
          break;
        case DioErrorType.sendTimeout:
          Toast.popToast('发送请求超时', ToastPosition.center);
          break;
        case DioErrorType.badResponse:
          Toast.popToast('网络出错', ToastPosition.center);
          break;
        case DioErrorType.badCertificate:
          // TODO: Handle this case.
          break;
        case DioErrorType.connectionError:
          // TODO: Handle this case.
          break;
        case DioErrorType.unknown:
          // TODO: Handle this case.
          break;
      }
      rethrow;
    }
    // Log().i('返回的数据：${BaseBean.fromJson(_response.data)}');
    return _response;
  }

}
