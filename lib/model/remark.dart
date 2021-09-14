class Remark {
  int sno;
  String enteredBy;
  String enteredDate;
  String message;
  String studentSno;
  String subject;
  String topicSno;
  String updatedBy;
  String updatedDate;

  Remark();

  Remark.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    message = json['message'];
    studentSno = json['studentSno'];
    subject = json['subject'];
    topicSno = json['topicSno'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['message'] = message;
    data['studentSno'] = studentSno;
    data['subject'] = subject;
    data['topicSno'] = topicSno;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    return data;
  }
}
