import 'package:plant_disease_identification_app/generated/json/base/json_field.dart';
import 'package:plant_disease_identification_app/generated/json/base_bean_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BaseBeanEntity {

	late bool success;
	late String msg;
	late int data;
	late int status;
  
  BaseBeanEntity();

  factory BaseBeanEntity.fromJson(Map<String, dynamic> json) => $BaseBeanEntityFromJson(json);

  Map<String, dynamic> toJson() => $BaseBeanEntityToJson(this);

  BaseBeanEntity copyWith({bool? success, String? msg, int? data, int? status}) {
      return BaseBeanEntity()..success= success ?? this.success
			..msg= msg ?? this.msg
			..data= data ?? this.data
			..status= status ?? this.status;
  }
    
  @override
  String toString() {
    return jsonEncode(this);
  }
}