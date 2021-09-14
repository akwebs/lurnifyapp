class Study {
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
  String status;

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
    this.status,
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
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['chapterSno'] = chapterSno;
    data['courseSno'] = courseSno;
    data['date'] = date;
    data['duration'] = duration;
    data['effectivenessOfStudy'] = effectivenessOfStudy;
    data['endDate'] = endDate;
    data['enteredDate'] = enteredDate;
    data['numericalPercent'] = numericalPercent;
    data['revision'] = revision;
    data['startDate'] = startDate;
    data['subjectSno'] = subjectSno;
    data['theoryPercent'] = theoryPercent;
    data['timePunchedFrom'] = timePunchedFrom;
    data['topicCompletionStatus'] = topicCompletionStatus;
    data['topicSno'] = topicSno;
    data['totalSecond'] = totalSecond;
    data['totalTime'] = totalTime;
    data['unitSno'] = unitSno;
    data['updatedDate'] = updatedDate;
    data['register'] = register;
    data['status'] = status;
    return data;
  }
}
