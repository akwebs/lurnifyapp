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
      topicDtos = <TopicDtos>[];
      json['topicDtos'].forEach((v) {
        topicDtos.add(TopicDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['chapterName'] = chapterName;
    data['unitSno'] = unitSno;
    if (topicDtos != null) {
      data['topicDtos'] = topicDtos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
