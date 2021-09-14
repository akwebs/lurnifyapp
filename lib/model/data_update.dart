class DataUpdate {
  int sno;
  String reward;
  String weeklyTask;
  String dailyTaskCompletion;
  String dailyTask;
  String dailyTaskData;
  String beatDistraction;
  String dailyAppOpening;
  String timerPage;
  String challengeAccept;
  String dataSynced;

  DataUpdate(
      {this.sno,
      this.reward,
      this.weeklyTask,
      this.dailyTaskCompletion,
      this.dailyTask,
      this.dailyTaskData,
      this.beatDistraction,
      this.dailyAppOpening,
      this.timerPage,
      this.challengeAccept,
      this.dataSynced});

  DataUpdate.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    reward = json['reward'];
    weeklyTask = json['weeklyTask'];
    dailyTaskCompletion = json['dailyTaskCompletion'];
    dailyTask = json['dailyTask'];
    dailyTaskData = json['dailyTaskData'];
    beatDistraction = json['beatDistraction'];
    dailyAppOpening = json['dailyAppOpening'];
    timerPage = json['timerPage'];
    challengeAccept = json['challengeAccept'];
    dataSynced = json['dataSynced'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['reward'] = reward;
    data['weeklyTask'] = weeklyTask;
    data['dailyTaskCompletion'] = dailyTaskCompletion;
    data['dailyTask'] = dailyTask;
    data['dailyTaskData'] = dailyTaskData;
    data['beatDistraction'] = beatDistraction;
    data['dailyAppOpening'] = dailyAppOpening;
    data['timerPage'] = timerPage;
    data['challengeAccept'] = challengeAccept;
    data['dataSynced'] = dataSynced;
    return data;
  }
}
