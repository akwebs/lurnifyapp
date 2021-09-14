import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/revsion_zone_model.dart';
import 'package:sqflite/sqflite.dart';

class RevisionZoneHelper {
  DBHelper dbHelper = DBHelper();
  getRevisionZone(String register, String fDate, String lDate) async {
    Database database = await dbHelper.database;
    List<Map<String, dynamic>> revisionZoneList = [];

    await database.transaction((txn) async {
      String sql1 = "select t.sno as topicSno,t.topicName as topicName, t.subtopic as subTopic,sub.sno as subjectSno,"
              " sub.subjectName as subjectName,t.topicImp as topicImp, u.unitName as unitName, c.chapterName as chapterName, course.sno as courseSno "
              "from topic as t "
              "inner join study as s on s.topicSno=t.sno " +
          "INNER JOIN chapter as c on c.sno=t.chapterSno " +
          "INNER JOIN unit as u on u.sno=c.unitSno " +
          "INNER JOIN subject as sub on sub.sno=u.subjectSno " +
          "inner join course on course.sno=sub.courseSno " +
          "LEFt JOIN topic_test_result on topic_test_result.regSno=s.register " +
          "where s.enteredDate>='$fDate' and s.enteredDate<='$lDate' and s.register='$register' " +
          "group by t.sno";
      List<Map<String, dynamic>> list = await txn.rawQuery(sql1);
      for (var a in list) {
        RevisionZoneModel model = RevisionZoneModel();
        String sql2 = "select count(DISTINCT topic_sno) as isUserStudied from study where register ='$register' "
            "and revision = 0 and topicSno=''${a['topicSno']} and topic_completion_status='Complete'";
        List<Map<String, dynamic>> list1 = await txn.rawQuery(sql2);
        for (var b in list1) {
          model.isUserStudied = b['isUserStudied'];
        }

        String sql3 = "SELECT testPercent as lastTestScore from topic_test_result where regSno='$register' and topicSno='${a['topicSno']}' ORDER BY sno desc limit 1";
        List<Map<String, dynamic>> list2 = await txn.rawQuery(sql3);
        for (var b in list2) {
          model.lastTestScore = b['lastTestScore'];
        }

        String sql4 = "select revision from study where topicSno=topicSno and register='$register' ORDER BY sno desc limit 1";
        List<Map<String, dynamic>> list3 = await txn.rawQuery(sql4);
        for (var b in list3) {
          model.revision = b['revision'] ?? "0";
        }

        String sql5 = "select count(sno) as totalSubject from subject where course='${a['courseSno']}'";
        List<Map<String, dynamic>> list4 = await txn.rawQuery(sql5);
        for (var b in list4) {
          model.totalSubject = b['totalSubject'] ?? 0;
        }

        String sql6 = "select enteredDate from study where topicSno='${a['topicSno']}' and register='$register' order by sno desc limit 1";
        List<Map<String, dynamic>> list5 = await txn.rawQuery(sql6);
        for (var b in list5) {
          model.lastStudied = b['enteredDate'] ?? 0;
        }

        model.topicSno = a['topicSno'];
        model.topicName = a['topicName'];
        model.subTopic = a['subTopic'];
        model.subjectSno = a['subjectSno'];
        model.subjectName = a['subjectName'];
        model.topicImp = a['topicImp'];
        model.unitName = a['unitName'];
        model.chapterName = a['chapterName'];

        revisionZoneList.add(model.toJson());
      }
      return null;
    });
  }
}
