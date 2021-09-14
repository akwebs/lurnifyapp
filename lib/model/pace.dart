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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['expectedRank'] = expectedRank;
    data['syllabusCompletionDate'] = syllabusCompletionDate;
    data['perDayStudyHour'] = perDayStudyHour;
    data['studentSno'] = studentSno;
    data['courseSno'] = courseSno;
    data['enteredDate'] = enteredDate;
    data['updatedDate'] = updatedDate;
    data['percentDifference'] = percentDifference;
    data['register'] = register;
    return data;
  }
}
