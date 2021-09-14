import 'package:lurnify/model/units.dart';

class Subject {
  int sno;
  String subjectName;
  List<UnitDtos> unitDtos;
  String courseSno;

  Subject({this.sno, this.subjectName, this.unitDtos, this.courseSno});

  Subject.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    subjectName = json['subjectName'];
    courseSno = json['courseSno'];
    if (json['unitDtos'] != null) {
      unitDtos = [];
      json['unitDtos'].forEach((v) {
        unitDtos.add(UnitDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['subjectName'] = subjectName;
    data['courseSno'] = courseSno;
    if (unitDtos != null) {
      data['unitDtos'] = unitDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
