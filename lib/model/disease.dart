class Disease {
  int? accuracy;
  String? name;
  String? nameEng;
  String? type;
  String? cause;
  String? symptom;
  String? suggestion;
  String? result;
  int? id;
  String? date;
  String? imgUrl;

  Disease(
      {
        this.id,
        this.accuracy,
        this.name,
        this.nameEng,
        this.type,
        this.cause,
        this.symptom,
        this.suggestion,
        this.result,
        this.date,
        this.imgUrl
      });

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // accuracy = json['accuracy'];
    name = json['name'];
    nameEng = json['nameEng'];
    type = json['type'];
    cause = json['cause'];
    symptom = json['symptom'];
    suggestion = json['suggestion'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameEng'] = nameEng;
    data['name'] = name;
    data['type'] = type;
    data['accuracy'] = accuracy;
    data['cause'] = cause;
    data['symptom'] = symptom;
    data['suggestion'] = suggestion;
    data['result'] = result;
    return data;
  }

  @override
  String toString() {
    return 'Disease{id: $id, nameEng: $nameEng, name: $name, type: $type, accuracy: $accuracy,cause: $cause,symptom: $symptom,suggestion: $suggestion,result:$result}';
  }

}