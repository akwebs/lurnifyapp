class TopicDtos {
  int sno;
  String topicName;
  String subtopic;
  String duration;
  String chapterSno;
  String topicImp;
  String topicLabel;

  TopicDtos({this.sno, this.topicName, this.subtopic, this.duration});

  TopicDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    topicName = json['topicName'];
    subtopic = json['subtopic'];
    duration = json['duration'];
    chapterSno = json['chapterSno'];
    topicImp = json['topicImp'];
    topicLabel = json['topicLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['topicName'] = topicName;
    data['subtopic'] = subtopic;
    data['duration'] = duration;
    data['chapterSno'] = chapterSno;
    data['topicImp'] = topicImp;
    data['topicLabel'] = topicLabel;
    return data;
  }
}
