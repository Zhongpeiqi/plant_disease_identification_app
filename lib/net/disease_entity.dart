import 'package:plant_disease_identification_app/generated/json/base/json_field.dart';
import 'package:plant_disease_identification_app/generated/json/disease_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class DiseaseEntity {

	late double accuracy;
	late String disease;
	late double tag;
  
  DiseaseEntity();

  factory DiseaseEntity.fromJson(Map<String, dynamic> json) => $DiseaseEntityFromJson(json);

  Map<String, dynamic> toJson() => $DiseaseEntityToJson(this);

  DiseaseEntity copyWith({double? accuracy, String? disease, double? tag}) {
      return DiseaseEntity()..accuracy= accuracy ?? this.accuracy
			..disease= disease ?? this.disease
			..tag= tag ?? this.tag;
  }
    
  @override
  String toString() {
    return jsonEncode(this);
  }
}