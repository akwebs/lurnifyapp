class RecentStudy {
  int sno;
  String duration;
  String enteredBy;
  String enteredDate;
  String registrationSno;
  String studyType;
  String updatedBy;
  String updatedDate;
  String chapter;
  String course;
  String subject;
  String topic;
  String unit;
  String status;

  RecentStudy();

  RecentStudy.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    duration = json['duration'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    registrationSno = json['registrationSno'];
    studyType = json['studyType'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    chapter = json['chapter'];
    course = json['course'];
    subject = json['subject'];
    topic = json['topic'];
    unit = json['unit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['duration'] = duration;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['registrationSno'] = registrationSno;
    data['studyType'] = studyType;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['chapter'] = chapter;
    data['course'] = course;
    data['subject'] = subject;
    data['topic'] = topic;
    data['unit'] = unit;
    data['status'] = status;
    return data;
  }
}
