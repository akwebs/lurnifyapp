class Remark{
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['message'] = this.message;
    data['studentSno'] = this.studentSno;
    data['subject'] = this.subject;
    data['topicSno'] = this.topicSno;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }


}