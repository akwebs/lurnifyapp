import 'package:lurnify/model/topics.dart';

class ChapterDtos {
  int sno;
  String chapterName;
  List<TopicDtos> topicDtos;
  String unitSno;

  ChapterDtos({this.sno, this.chapterName, this.topicDtos});

  ChapterDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    chapterName = json['chapterName'];
    unitSno = json['unitSno'];
    if (json['topicDtos'] != null) {
      topicDtos = new List<TopicDtos>();
      json['topicDtos'].forEach((v) {
        topicDtos.add(new TopicDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['chapterName'] = this.chapterName;
    data['unitSno'] = this.unitSno;
    if (this.topicDtos != null) {
      data['topicDtos'] = this.topicDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
