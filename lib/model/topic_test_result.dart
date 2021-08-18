
class TopicTestResult{
  int sno;
  String answerMap;
  String correctQuestion;
  String enteredBy;
  String enteredDate;
  String resultNumber;
  String testPercent;
  String totalQuestion;
  String wrongQuestion;
  String regSno;
  String topicSno;
  String totalTestTime;
  String course;
  String subject;
  String unit;
  String chapter;


  TopicTestResult(
      {this.sno,
        this.answerMap,
        this.correctQuestion,
        this.enteredBy,
        this.enteredDate,
        this.resultNumber,
        this.testPercent,
        this.totalQuestion,
        this.wrongQuestion,
        this.regSno,
        this.topicSno,
        this.totalTestTime,
        this.course,
        this.subject,
        this.unit,
        this.chapter
        });

  TopicTestResult.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    answerMap = json['answerMap'];
    correctQuestion = json['correctQuestion'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    resultNumber = json['resultNumber'];
    testPercent = json['testPercent'];
    totalQuestion = json['totalQuestion'];
    wrongQuestion = json['wrongQuestion'];
    regSno = json['regSno'];
    topicSno = json['topicSno'];
    course = json['course'];
    subject = json['subject'];
    unit = json['unit'];
    chapter = json['chapter'];
    totalTestTime = json['totalTestTime'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['answerMap'] = this.answerMap;
    data['correctQuestion'] = this.correctQuestion;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['resultNumber'] = this.resultNumber;
    data['testPercent'] = this.testPercent;
    data['totalQuestion'] = this.totalQuestion;
    data['wrongQuestion'] = this.wrongQuestion;
    data['regSno'] = this.regSno;
    data['topicSno'] = this.topicSno;
    data['course'] = this.course;
    data['subject'] = this.subject;
    data['unit'] = this.unit;
    data['chapter'] = this.chapter;
    data['totalTestTime'] = this.totalTestTime;
    return data;
  }

}