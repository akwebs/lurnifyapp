class DataUpdate{
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['reward'] = this.reward;
    data['weeklyTask'] = this.weeklyTask;
    data['dailyTaskCompletion'] = this.dailyTaskCompletion;
    data['dailyTask'] = this.dailyTask;
    data['dailyTaskData'] = this.dailyTaskData;
    data['beatDistraction'] = this.beatDistraction;
    data['dailyAppOpening'] = this.dailyAppOpening;
    data['timerPage'] = this.timerPage;
    data['challengeAccept'] = this.challengeAccept;
    data['dataSynced'] = this.dataSynced;
    return data;
  }
}