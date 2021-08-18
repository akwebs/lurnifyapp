class Reward {
  int sno;
  int appOpening;
  int studyTime;
  int testAttempt;
  int testScore;
  int testScore1;
  int testScore2;
  int testScore3;
  int refer;
  int weeklyChallengeAccept;
  int dailyTask;
  int monthlyChallenge;
  int feeDeposite;
  int rankboosterTestAttempt;
  int rankboosterTestScore;
  int rankboosterTestScore1;
  int rankboosterTestScore2;
  int rankboosterTestScore3;
  String enteredBy;
  int enteredDate;
  Null updatedBy;
  int updatedDate;

  Reward(
      {this.sno,
        this.appOpening,
        this.studyTime,
        this.testAttempt,
        this.testScore,
        this.testScore1,
        this.testScore2,
        this.testScore3,
        this.refer,
        this.weeklyChallengeAccept,
        this.dailyTask,
        this.monthlyChallenge,
        this.feeDeposite,
        this.rankboosterTestAttempt,
        this.rankboosterTestScore,
        this.rankboosterTestScore1,
        this.rankboosterTestScore2,
        this.rankboosterTestScore3,
        this.enteredBy,
        this.enteredDate,
        this.updatedBy,
        this.updatedDate});

  Reward.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    appOpening = json['appOpening'];
    studyTime = json['studyTime'];
    testAttempt = json['testAttempt'];
    testScore = json['testScore'];
    testScore1 = json['testScore1'];
    testScore2 = json['testScore2'];
    testScore3 = json['testScore3'];
    refer = json['refer'];
    weeklyChallengeAccept = json['weeklyChallengeAccept'];
    dailyTask = json['dailyTask'];
    monthlyChallenge = json['monthlyChallenge'];
    feeDeposite = json['feeDeposite'];
    rankboosterTestAttempt = json['rankboosterTestAttempt'];
    rankboosterTestScore = json['rankboosterTestScore'];
    rankboosterTestScore1 = json['rankboosterTestScore1'];
    rankboosterTestScore2 = json['rankboosterTestScore2'];
    rankboosterTestScore3 = json['rankboosterTestScore3'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['appOpening'] = this.appOpening;
    data['studyTime'] = this.studyTime;
    data['testAttempt'] = this.testAttempt;
    data['testScore'] = this.testScore;
    data['testScore1'] = this.testScore1;
    data['testScore2'] = this.testScore2;
    data['testScore3'] = this.testScore3;
    data['refer'] = this.refer;
    data['weeklyChallengeAccept'] = this.weeklyChallengeAccept;
    data['dailyTask'] = this.dailyTask;
    data['monthlyChallenge'] = this.monthlyChallenge;
    data['feeDeposite'] = this.feeDeposite;
    data['rankboosterTestAttempt'] = this.rankboosterTestAttempt;
    data['rankboosterTestScore'] = this.rankboosterTestScore;
    data['rankboosterTestScore1'] = this.rankboosterTestScore1;
    data['rankboosterTestScore2'] = this.rankboosterTestScore2;
    data['rankboosterTestScore3'] = this.rankboosterTestScore3;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}