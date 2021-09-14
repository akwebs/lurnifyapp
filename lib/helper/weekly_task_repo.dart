import 'package:lurnify/helper/db_helper.dart';

class WeeklyTaskRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getDareToDuo(register, date1, date2, txn) {
    Future<List<Map<String, dynamic>>> list;
    try {
      String sql2 = "select minimumStudyDays ,totalNumberOfTest,totalStudyHour as totalStudyHourInWeek,coins," +
          "(select sum(totalSecond)/3600 from study where register=$register and startDate>=$date1 and startDate<=$date2 " +
          " ) as totalStudyHour," +
          "(select count(sno) from topic_test_result where regSno=$register and enteredDate>=$date1 " +
          "and enteredDate<=$date2 and testPercent>=50) as completedTest," +
          "(select count(sno) from study where enteredDate>=$date1 and  enteredDate<=$date2 group by sno having (sum(totalSecond)/3600)>=2) as completedDailyStudy from weekly_task" +
          " inner join challenge_accept  on weekly_task.week=challenge_accept.week" +
          " where registerSno=$register order by weekly_task.sno desc limit 1";

      list = txn.rawQuery(sql2);
    } catch (e) {
      //print(e.toString());
    }
    return list;
  }
}
