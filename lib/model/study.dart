class Study{
  int sno;
  String chapterSno;
  String courseSno;
  String date;
  String duration;
  String effectivenessOfStudy;
  String endDate;
  String enteredDate;
  String numericalPercent;
  String revision;
  String startDate;
  String subjectSno;
  String theoryPercent;
  String timePunchedFrom;
  String topicCompletionStatus;
  String topicSno;
  String totalSecond;
  String totalTime;
  String unitSno;
  String updatedDate;
  String register;

  Study({
    this.sno,
    this.chapterSno,
    this.courseSno,
    this.date,
    this.duration,
    this.effectivenessOfStudy,
    this.endDate,
    this.enteredDate,
    this.numericalPercent,
    this.revision,
    this.startDate,
    this.subjectSno,
    this.theoryPercent,
    this.timePunchedFrom,
    this.topicCompletionStatus,
    this.topicSno,
    this.totalSecond,
    this.totalTime,
    this.unitSno,
    this.updatedDate,
    this.register,

  });

  Study.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    chapterSno = json['chapterSno'];
    courseSno = json['courseSno'];
    date = json['date'];
    duration = json['duration'];
    effectivenessOfStudy = json['effectivenessOfStudy'];
    endDate = json['endDate'];
    enteredDate = json['enteredDate'];
    numericalPercent = json['numericalPercent'];
    revision = json['revision'];
    startDate = json['startDate'];
    subjectSno = json['subjectSno'];
    theoryPercent = json['theoryPercent'];
    timePunchedFrom = json['timePunchedFrom'];
    topicCompletionStatus = json['topicCompletionStatus'];
    topicSno = json['topicSno'];
    totalSecond = json['totalSecond'];
    totalTime = json['totalTime'];
    unitSno = json['unitSno'];
    updatedDate = json['updatedDate'];
    register = json['register'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['chapterSno'] = this.chapterSno;
    data['courseSno'] = this.courseSno;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['effectivenessOfStudy'] = this.effectivenessOfStudy;
    data['endDate'] = this.endDate;
    data['enteredDate'] = this.enteredDate;
    data['numericalPercent'] = this.numericalPercent;
    data['revision'] = this.revision;
    data['startDate'] = this.startDate;
    data['subjectSno'] = this.subjectSno;
    data['theoryPercent'] = this.theoryPercent;
    data['timePunchedFrom'] = this.timePunchedFrom;
    data['topicCompletionStatus'] = this.topicCompletionStatus;
    data['topicSno'] = this.topicSno;
    data['totalSecond'] = this.totalSecond;
    data['totalTime'] = this.totalTime;
    data['unitSno'] = this.unitSno;
    data['updatedDate'] = this.updatedDate;
    data['register'] = this.register;
    return data;
  }
}