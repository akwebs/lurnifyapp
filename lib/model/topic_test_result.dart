class TopicTestResult {
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
  String status;
  String questionTiming;

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
      this.chapter,
      this.status,
      this.questionTiming});

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
    status = json['status'];
    questionTiming = json['questionTiming'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['answerMap'] = answerMap;
    data['correctQuestion'] = correctQuestion;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['resultNumber'] = resultNumber;
    data['testPercent'] = testPercent;
    data['totalQuestion'] = totalQuestion;
    data['wrongQuestion'] = wrongQuestion;
    data['regSno'] = regSno;
    data['topicSno'] = topicSno;
    data['course'] = course;
    data['subject'] = subject;
    data['unit'] = unit;
    data['chapter'] = chapter;
    data['totalTestTime'] = totalTestTime;
    data['status'] = status;
    data['questionTiming'] = questionTiming;
    return data;
  }
}
