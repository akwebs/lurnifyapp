import 'package:lurnify/model/chapters.dart';

class UnitDtos {
  int sno;
  String unitName;
  List<ChapterDtos> chapterDtos;
  String subjectSno;

  UnitDtos({this.sno, this.unitName, this.chapterDtos, this.subjectSno});

  UnitDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    unitName = json['unitName'];
    subjectSno = json['subjectSno'];
    if (json['chapterDtos'] != null) {
      chapterDtos = <ChapterDtos>[];
      json['chapterDtos'].forEach((v) {
        chapterDtos.add(ChapterDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['unitName'] = unitName;
    data['subjectSno'] = subjectSno;
    if (chapterDtos != null) {
      data['chapterDtos'] = chapterDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
