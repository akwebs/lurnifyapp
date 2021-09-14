import 'package:lurnify/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class MyReportRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getMyReport(String regSno) async {
    Future<List<Map<String, dynamic>>> list;
    try {
      Database database = await dbHelper.database;
      String sql18 = "select `subject`.sno as subjectSno,`subject`.subjectName as subjectName, sum(topic.duration) as totalTopicDurationInMinute,\r\n" +
          "(select sum(totalSecond) from study where register=$regSno and subjectSno=`subject`.sno) as totalSubjectStudyInSeconds," +
          "(select count(topic_test_result.sno) from topic_test_result  where regSno=$regSno and topic_test_result.subject=`subject`.sno and testPercent<50) as failedTest, \r\n" +
          "(select count(topic_test_result.sno) from topic_test_result  where regSno=$regSno and topic_test_result.subject=`subject`.sno and testPercent>=50 and testPercent<70) as avgTest,\r\n" +
          "(select count(topic_test_result.sno) from topic_test_result  where regSno=$regSno and topic_test_result.subject=`subject`.sno and testPercent>=70 and testPercent<90) as goodTest,\r\n" +
          "(select count(topic_test_result.sno) from topic_test_result  where regSno=$regSno and topic_test_result.subject=`subject`.sno and testPercent>90 ) as excelentTest, \r\n" +
          "(select sum(correctQuestion)/sum(totalQuestion) from topic_test_result  WHERE topic_test_result.subject=`subject`.sno and topic_test_result.regSno=$regSno) as testPercent, \r\n" +
          "(select sum(DISTINCT(topic.duration)) from study INNER JOIN topic on topic.sno=study.topicSno where study.subjectSno=subjectSno and study.register=$regSno and topicCompletionStatus='Complete') as totalCompletedTopicMinutes,\r\n" +
          "(julianday('now') - julianday(register.firstMonday)) as totalCompletedDays,\r\n" +
          "(julianday(pace.syllabusCompletionDate) - julianday(register.firstMonday)) as totalCourseDays \r\n" +
          "from `subject` \r\n" +
          "INNER JOIN course on course.sno=`subject`.courseSno \r\n" +
          "INNER JOIN register on register.courseId=course.sno\r\n" +
          "INNER JOIN pace on pace.studentSno=register.sno  \r\n" +
          "left JOIN unit on unit.subjectSno=`subject`.sno\r\n" +
          "left JOIN chapter on chapter.unitSno=unit.sno\r\n" +
          "left JOIN topic on chapter.sno=topic.chapterSno\r\n" +
          "where register.sno=$regSno GROUP BY `subject`.sno";

      list = database.rawQuery(sql18);
    } catch (e) {
      //print("My Report error : " + e.toString());
    }

    return list;
  }

  getData() async {
    try {
      String sql = "select * from register";
      String sql2 = "select * from pace";
      Database database = await dbHelper.database;

      var a = await database.rawQuery(sql);
      var b = await database.rawQuery(sql2);

      //print(a);
      //print(b);
    } catch (e) {
      //print(e.toString());
    }
  }
}
