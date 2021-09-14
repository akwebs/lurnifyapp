class RevisionZoneModel {
  String topicSno;
  String topicName;
  String subTopic;
  int isUserStudied;
  double lastTestScore;
  String revision;
  String lastStudied;
  String subjectSno;
  String subjectName;
  double topicImp;
  int totalSubject;
  String unitName;
  String chapterName;

  RevisionZoneModel();

  RevisionZoneModel.fromJson(Map<String, dynamic> json) {
    topicSno = json['topicSno'];
    topicName = json['topicName'];
    subTopic = json['subTopic'];
    isUserStudied = json['isUserStudied'];
    lastTestScore = json['lastTestScore'];
    revision = json['revision'];
    lastStudied = json['lastStudied'];
    subjectSno = json['subjectSno'];
    subjectName = json['subjectName'];
    topicImp = json['topicImp'];
    totalSubject = json['totalSubject'];
    unitName = json['unitName'];
    chapterName = json['chapterName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topicSno'] = topicSno;
    data['topicName'] = topicName;
    data['subTopic'] = subTopic;
    data['isUserStudied'] = isUserStudied;
    data['lastTestScore'] = lastTestScore;
    data['revision'] = revision;
    data['lastStudied'] = lastStudied;
    data['subjectSno'] = subjectSno;
    data['subjectName'] = subjectName;
    data['topicImp'] = topicImp;
    data['totalSubject'] = totalSubject;
    data['unitName'] = unitName;
    data['chapterName'] = chapterName;
    return data;
  }
}
