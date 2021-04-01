import 'package:lurnify/model/chapters.dart';

class UnitDtos {
  int sno;
  String unitName;
  List<ChapterDtos> chapterDtos;

  UnitDtos({this.sno, this.unitName, this.chapterDtos});

  UnitDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    unitName = json['unitName'];
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
    if (this.chapterDtos != null) {
      data['chapterDtos'] = this.chapterDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
