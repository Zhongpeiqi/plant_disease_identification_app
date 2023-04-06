import 'package:plant_disease_identification_app/generated/json/base/json_convert_content.dart';
import 'package:plant_disease_identification_app/net/disease_entity.dart';

DiseaseEntity $DiseaseEntityFromJson(Map<String, dynamic> json) {
	final DiseaseEntity diseaseEntity = DiseaseEntity();
	final double? accuracy = jsonConvert.convert<double>(json['accuracy']);
	if (accuracy != null) {
		diseaseEntity.accuracy = accuracy;
	}
	final String? disease = jsonConvert.convert<String>(json['disease']);
	if (disease != null) {
		diseaseEntity.disease = disease;
	}
	final double? tag = jsonConvert.convert<double>(json['tag']);
	if (tag != null) {
		diseaseEntity.tag = tag;
	}
	return diseaseEntity;
}

Map<String, dynamic> $DiseaseEntityToJson(DiseaseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['accuracy'] = entity.accuracy;
	data['disease'] = entity.disease;
	data['tag'] = entity.tag;
	return data;
}