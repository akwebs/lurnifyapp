import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/due_topic_test.dart';
import 'package:sqflite/sqflite.dart';

class DueTopicTestRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getDueTopicTestByStatusAndTopicAndRegister(String status, String topic, String register) async {
    Database db = await dbHelper.database;
    String sql = "select * from due_topic_tests where status='$status' and topicSno='$topic' and registerSno='$register'";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> getDueTopicTestByStatusAndRegister(String status, String register, String revision) async {
    Database db = await dbHelper.database;
    String sql = "select dtt.sno as dueTopicTestSno,topic.sno as topicSno ,topic.topicName as topicName,topic.subTopic as subtopic,"
            "dtt.course,dtt.subject,dtt.unit,dtt.chapter, " +
        "sub.sno as subjectSno, sub.subjectName as subjectName,topicImp, u.unitName as unitName, c.chapterName as chapterName," +
        "(select count(DISTINCT topicSno) from study where register ='$register' and revision = $revision and topicSno=topic.sno and topicCompletionStatus='$status') as isUserStudied," +
        "(SELECT testPercent from topic_test_result where regSno=:Register and topicSno=topic.sno ORDER BY sno desc limit 1) as lastTestScore," +
        "(select revision from study where topicSno=topic.sno and register='$register' ORDER BY sno desc limit 1) as revision," +
        "(select enteredDate from study where topicSno=topic.sno and register=$register order by sno desc limit 1) as lastStudied " +
        "from due_topic_tests as dtt " +
        "INNER JOIN topic on dtt.topicSno=topic.sno " +
        "INNER JOIN chapter as c on c.sno=topic.chapterSno " +
        "INNER JOIN unit as u on u.sno=c.unitSno " +
        "INNER JOIN subject as sub on sub.sno=u.subjectSno " +
        "where registerSno='$register' and `status`='$status'";
    // String sql="select * from due_topic_tests where status='$status' and registerSno='$register'";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  insertIntoDueTopicTest(DueTopicTest study) async {
    try {
      Database db = await dbHelper.database;
      db.insert('due_topic_tests', study.toJson());
    } catch (e) {
      //print('insertIntoDue_topic_tests : ' + e.toString());
    }
  }

  updateDueTopicTest(String topicSno) async {
    DBHelper dbHelper = new DBHelper();
    try {
      Database database = await dbHelper.database;
      String sql = "update due_topic_tests set status='Complete' where topicSno=$topicSno";
      //print(sql);
      database.rawQuery(sql);
    } catch (e) {
      //print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getNewDueTopicTest() async {
    Database db = await dbHelper.database;
    String sql = "select * from due_topic_tests where onlineStatus='new'";
    var result = db.rawQuery(sql);
    return result;
  }

  getHomePageDueTest(txn) async {
    String sql = "select topicName,subjectName,topic.sno,chapterName from due_topic_tests "
        "inner join topic on topicSno=topic.sno "
        "inner join chapter on chapter.sno=due_topic_tests.chapter "
        "inner join subject on due_topic_tests.subject=subject.sno";
    var result = txn.rawQuery(sql);
    return result;
  }
}
