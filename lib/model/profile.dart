import 'package:plant_disease_identification_app/model/history.dart';
import 'package:plant_disease_identification_app/model/user.dart';

class Profile {
  User? user;
  List<String>? searchList;
  List<History>? historyList;
  int? theme;
  bool? isDark;
  String? ip;

  Profile({this.user, this.searchList, this.theme, this.isDark, this.ip});
  Profile.none(this.searchList);
  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    searchList = json['searchList'].cast<String>();
    historyList = [];
    theme = json['theme'];
    isDark = json['isDark'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    data['searchList'] = searchList;
    data['historyList'] = historyList;
    data['theme'] = theme;
    data['isDark'] = isDark;
    data['ip'] = ip;
    return data;
  }
}
