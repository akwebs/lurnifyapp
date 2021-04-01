class TopicDtos {
  int sno;
  String topicName;
  String subTopic;
  String duration;

  TopicDtos({this.sno, this.topicName, this.subTopic, this.duration});

  TopicDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    topicName = json['topicName'];
    subTopic = json['subTopic'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['topicName'] = this.topicName;
    data['subTopic'] = this.subTopic;
    data['duration'] = this.duration;
    return data;
  }
}
