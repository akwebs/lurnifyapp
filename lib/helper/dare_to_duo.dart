import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/helper/study_repo.dart';
import 'package:lurnify/helper/topic_test_result_repo.dart';
import 'package:lurnify/helper/challenge_accept_repo.dart';
import 'package:lurnify/helper/daily_task_completion_repo.dart';
import 'package:lurnify/helper/weekly_task_repo.dart';
import 'package:sqflite/sqflite.dart';

class DareToDuoRepo {
  DBHelper dbHelper = DBHelper();

  TopicTestResultRepo topicTestResultRepo = TopicTestResultRepo();

  WeeklyTaskRepo weeklyTaskRepo = WeeklyTaskRepo();

  StudyRepo studyRepo = StudyRepo();

  DailyTaskCompletionRepo dailyTaskCompletionRepo = DailyTaskCompletionRepo();

  getDareToDuo(String register) async {
    Map<String, dynamic> map = Map();

    try {
      Database database = await dbHelper.database;
      await database.transaction((txn) async {
        ChallengeAcceptRepo challengeAcceptRepo = ChallengeAcceptRepo();

        List<Map<String, dynamic>> findByRegister = await challengeAcceptRepo.findByRegisterOrderBySnoAsc(register, txn);

        if (findByRegister.length > 2 && findByRegister.length % 4 == 0) {
          // when list size is greater than 2 subtract the top data and getting only last
          // few weeks list
          findByRegister.removeRange(0, findByRegister.length - 4);
        }

        //print("findByRegister : $findByRegister");

        int count = 0;
        for (var a in findByRegister) {
          if (a['status'] == 'completed') {
            count++;
          }
        }

        //print('count $count');
        if (findByRegister.isNotEmpty) {
          map.putIfAbsent('monthData', () async => await topicTestResultRepo.getTotalMonthWork(findByRegister[0]['week'] * 7, register, txn));
        } else {
          map.putIfAbsent("monthData", () => {});
        }
        //print('monthData added');
        map.putIfAbsent("completedWeeks", () => count);

        // week
        List<Map<String, dynamic>> list2 =
            await weeklyTaskRepo.getDareToDuo(register, DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).toString().split(" ")[0], DateTime.now().toString().split(" ")[0], txn);
        map.putIfAbsent("week", () => list2);

        //print('week added');
        List<Map<String, dynamic>> list3 = await studyRepo.getDailyStudy(register, txn);
        map.putIfAbsent("weekDailyData", () => list3);

        //print('weekDailyData added');

        //daily
        List<Map<String, dynamic>> list4 = await dailyTaskCompletionRepo.getDailyTaskForDareToDuo(register, txn);

        map.putIfAbsent("daily", () => list4);

        //print('daily added');

        //print(map);
      });
    } catch (e) {
      //print("getDareToDuo " + e.toString());
    }

    return map;
  }
}
