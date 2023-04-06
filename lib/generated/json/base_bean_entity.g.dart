import 'package:plant_disease_identification_app/generated/json/base/json_convert_content.dart';
import 'package:plant_disease_identification_app/net/base_bean_entity.dart';

BaseBeanEntity $BaseBeanEntityFromJson(Map<String, dynamic> json) {
	final BaseBeanEntity baseBeanEntity = BaseBeanEntity();
	final bool? success = jsonConvert.convert<bool>(json['success']);
	if (success != null) {
		baseBeanEntity.success = success;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		baseBeanEntity.msg = msg;
	}
	final int? data = jsonConvert.convert<int>(json['data']);
	if (data != null) {
		baseBeanEntity.data = data;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		baseBeanEntity.status = status;
	}
	return baseBeanEntity;
}

Map<String, dynamic> $BaseBeanEntityToJson(BaseBeanEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['success'] = entity.success;
	data['msg'] = entity.msg;
	data['data'] = entity.data;
	data['status'] = entity.status;
	return data;
}