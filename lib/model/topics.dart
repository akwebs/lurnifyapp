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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['topicName'] = this.topicName;
    data['subtopic'] = this.subtopic;
    data['duration'] = this.duration;
    data['chapterSno'] = this.chapterSno;
    data['topicImp'] = this.topicImp;
    data['topicLabel'] = this.topicLabel;
    return data;
  }
}
