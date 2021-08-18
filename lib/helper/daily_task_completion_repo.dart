import 'package:lurnify/helper/DBHelper.dart';

class DailyTaskCompletionRepo {
  DBHelper dbHelper = new DBHelper();

  Future<List<Map<String, dynamic>>> getDailyTaskForDareToDuo(
      String regSno, txn) {
    Future<List<Map<String, dynamic>>> list;
    String todayDate=DateTime.now().toString().split(" ")[0]+" 00:00:00";
    try {
      String sql = "select daily_task.taskName as taskName,daily_task_data.taskType as taskType,daily_task_data.taskUnit as taskUnit," +
          "cash,certificate,coins,noOfReferralCoupons as noOfRefferalCoupons,spinDate ," +
          "(select sum(totalSecond)/60 from study where register=$regSno and date=DATE()) as totalStudy," +
          "(select count(sno) from topic_test_result where regSno=$regSno and enteredDate>'$todayDate' and testPercent>=50) as totalTest " +
          "from daily_task_completion " +
          "inner join daily_task on daily_task.sno=daily_task_completion.dailyTaskSno " +
          "inner join daily_task_data on daily_task_data.dailyTaskSno=daily_task.sno where registerSno=$regSno and  spinDate=Date()";

      list = txn.rawQuery(sql);
    } catch (e) {
      print('getDailyTaskForDareToDuo ' + e.toString());
    }
    return list;
  }
}
