import 'package:lurnify/model/chapters.dart';

class UnitDtos {
  int sno;
  String unitName;
  List<ChapterDtos> chapterDtos;
  String subjectSno;

  UnitDtos({this.sno, this.unitName, this.chapterDtos,this.subjectSno});

  UnitDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    unitName = json['unitName'];
    subjectSno = json['subjectSno'];
    if (json['chapterDtos'] != null) {
      chapterDtos = new List<ChapterDtos>();
      json['chapterDtos'].forEach((v) {
        chapterDtos.add(new ChapterDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['unitName'] = this.unitName;
    data['subjectSno'] = this.subjectSno;
    if (this.chapterDtos != null) {
      data['chapterDtos'] = this.chapterDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
