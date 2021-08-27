class Pace {
  int sno;
  String expectedRank;

  String syllabusCompletionDate;

  String perDayStudyHour;

  String studentSno;

  String courseSno;

  String enteredDate;

  String updatedDate;
  String percentDifference;

  String register;

  Pace();

  Pace.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    expectedRank = json['expectedRank'];
    syllabusCompletionDate = json['syllabusCompletionDate'];
    perDayStudyHour = json['perDayStudyHour'];
    studentSno = json['studentSno'];
    courseSno = json['courseSno'];
    enteredDate = json['enteredDate'];
    updatedDate = json['updatedDate'];
    percentDifference = json['percentDifference'];
    register = json['register'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['expectedRank'] = this.expectedRank;
    data['syllabusCompletionDate'] = this.syllabusCompletionDate;
    data['perDayStudyHour'] = this.perDayStudyHour;
    data['studentSno'] = this.studentSno;
    data['courseSno'] = this.courseSno;
    data['enteredDate'] = this.enteredDate;
    data['updatedDate'] = this.updatedDate;
    data['percentDifference'] = this.percentDifference;
    data['register'] = this.register;
    return data;
  }
}
