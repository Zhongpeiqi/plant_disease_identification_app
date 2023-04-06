import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';
import 'dioProvider.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';


class UpLoad {
  static final Dio _dio = MyDio.createDio();
  //上传图片
  static Future<Response> upLoad(
      List<int> fileData, String filename) async {
    late Response response;
    FormData formData = FormData.fromMap(
        {"image": MultipartFile.fromBytes(fileData, filename: filename,contentType: MediaType("image","png"))}
    );
    response = await _dio.post("upload/image", data: formData,
        onSendProgress: (send, total) {
          print('${send / total * 100}% total ${total / 1024}k');
        });
    return response;
  }

  //上传图片
  static Future<Response> upLoadByFilePath(String field,String url,String path) async {
    late Response response;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = FormData.fromMap(
        {field: MultipartFile.fromFile(path,filename: name,contentType: MediaType("image","png")),});
    var dio = Dio();
    response = await dio.post(url, data: formData,
        onSendProgress: (send, total) {
          print('${send / total * 100}% total ${total / 1024}k');
        });
    return response;
  }

  //上传图片
  static Future<Response> upLoadByFile(String field,File file,String url) async {
    late Response response;
    String path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = FormData.fromMap(
        {field: MultipartFile.fromBytes(file.readAsBytesSync(),filename: name,contentType: MediaType("image","png")),});
    var dio = Dio();
    response = await dio.post(url, data: formData,
        onSendProgress: (send, total) {
          print('${send / total * 100}% total ${total / 1024}k');
        });
    return response;
  }
}
