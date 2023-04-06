import '../generated/json/base/json_convert_content.dart';

///convert和FlutterJsonBeanFactory结合解析
class BaseBean<T> {
  T? data;
  late int status;
  late bool success;
  late String msg;
  late num? total;

  BaseBean({this.data, required this.status, required this.msg,required this.success,this.total});

  BaseBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null&&json['data']!='null') {
      data = JsonConvert.fromJsonAsT<T>(json['data']);
    }
    status = json['status'];
    msg = json['msg'];
    success = json['success'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['status'] = status;
    data['msg'] = msg;
    data['success'] = success;
    data['total'] = total;
    return data;
  }
}