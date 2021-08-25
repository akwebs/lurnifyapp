class DueTopicTest{
  int sno;
  String enteredDate;
  String status;
  String registerSno;
  String topicSno;
  String course;
  String subject;
  String unit;
  String chapter;
  String onlineStatus;

  DueTopicTest();

  DueTopicTest.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    enteredDate = json['enteredDate'];
    status = json['status'];
    registerSno = json['registerSno'];
    topicSno = json['topicSno'];

    course = json['course'];
    subject = json['subject'];
    unit = json['unit'];
    chapter = json['chapter'];
    onlineStatus = json['onlineStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['enteredDate'] = this.enteredDate;
    data['status'] = this.status;
    data['registerSno'] = this.registerSno;
    data['topicSno'] = this.topicSno;
    data['course'] = this.course;
    data['subject'] = this.subject;
    data['unit'] = this.unit;
    data['chapter'] = this.chapter;
    data['onlineStatus'] = this.onlineStatus;
    return data;
  }
}