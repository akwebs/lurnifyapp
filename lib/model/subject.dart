import 'package:lurnify/model/units.dart';

class Subject {
  int sno;
  String subjectName;
  List<UnitDtos> unitDtos;

  Subject({this.sno, this.subjectName, this.unitDtos});

  Subject.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    subjectName = json['subjectName'];
    if (json['unitDtos'] != null) {
      unitDtos = new List<UnitDtos>();
      json['unitDtos'].forEach((v) {
        unitDtos.add(new UnitDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['subjectName'] = this.subjectName;
    if (this.unitDtos != null) {
      data['unitDtos'] = this.unitDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
