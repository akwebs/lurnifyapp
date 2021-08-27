class RecentStudy{
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['duration'] = this.duration;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['registrationSno'] = this.registrationSno;
    data['studyType'] = this.studyType;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['chapter'] = this.chapter;
    data['course'] = this.course;
    data['subject'] = this.subject;
    data['topic'] = this.topic;
    data['unit'] = this.unit;
    data['status'] = this.status;
    return data;
  }
}