import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/topic_test_result.dart';
import 'package:sqflite/sqflite.dart';

class TopicTestResultRepo {
  DBHelper dbHelper = DBHelper();

  Future<int> insertIntoTopicTestResult(TopicTestResult topicTestResult) async {
    Future<int> result;
    try {
      Database db = await dbHelper.database;
      result = db.insert('topic_test_result', topicTestResult.toJson());
    } catch (e) {
      //print('insertTopic_test_result : ' + e.toString());
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> findTopByRegisterAndTopicOrderBySnoDesc(String regSno, String topic) async {
    Database db = await dbHelper.database;
    String sql = "select * from topic_test_result where topicSno=$topic and regSno=$regSno order by sno desc";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> getData(String regSno, String topic) async {
    Database db = await dbHelper.database;
    String sql = "select * from topic_test_result";
    String sql3 = "select * from due_topic_tests";
    //print(sql);
    //print(sql3);
    var result = db.rawQuery(sql);

    var r = await db.rawQuery(sql3);
    //print(r);
    return result;
  }

  Future<List<Map<String, dynamic>>> getTotalMonthWork(String dayToAdd, String register, txn) {
    Future<List<Map<String, dynamic>>> a;
    try {
      String sql = "select count(sno) as totalTest," +
          "(select sum(totalSecond) from study where register=$register and enteredDate>=(select DATE_ADD(first_monday,INTERVAL $dayToAdd Day) from register where sno=$register)) as totalStudy " +
          "from topic_test_result where regSno=$register and enteredDate>=(select DATE_ADD(firstMonday,INTERVAL $dayToAdd Day) from register where sno=$register)";
      a = txn.rawQuery(sql);
    } catch (e) {
      //print(e);
    }
    return a;
  }

  Future<List<Map<String, dynamic>>> getNewTopicTestResult() async {
    Database db = await dbHelper.database;
    String sql = "select * from topic_test_result where status='new'";
    var result = db.rawQuery(sql);
    return result;
  }
}
