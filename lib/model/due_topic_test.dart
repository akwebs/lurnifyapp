class DueTopicTest {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['enteredDate'] = enteredDate;
    data['status'] = status;
    data['registerSno'] = registerSno;
    data['topicSno'] = topicSno;
    data['course'] = course;
    data['subject'] = subject;
    data['unit'] = unit;
    data['chapter'] = chapter;
    data['onlineStatus'] = onlineStatus;
    return data;
  }
}
