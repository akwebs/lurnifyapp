class TopicDtos {
  int sno;
  String topicName;

  TopicDtos({this.sno, this.topicName});

  TopicDtos.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    topicName = json['topicName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['topicName'] = this.topicName;
    return data;
  }
}
