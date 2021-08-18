import 'package:lurnify/model/subject.dart';

class CourseDto{
  int sno;
  String courseName;
  List<Subject> subjectDtos;

  CourseDto({this.sno, this.courseName, this.subjectDtos});

  CourseDto.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    courseName = json['courseName'];
    if (json['subjectDtos'] != null) {
      subjectDtos = [];
      json['unitDtos'].forEach((v) {
        subjectDtos.add(new Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['courseName'] = this.courseName;
    if (this.subjectDtos != null) {
      data['unitDtos'] = this.subjectDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}