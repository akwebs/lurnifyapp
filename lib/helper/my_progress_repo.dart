

import 'package:lurnify/helper/DBHelper.dart';
import 'package:sqflite/sqflite.dart';

class MyProgressRepo{

  DBHelper dbHelper = new DBHelper();

   getMyProgress(String status, String revision, String register)async{

    Database database= await dbHelper.database;
    List<Map<String,dynamic>> progressData=[];
    await database.transaction((txn)async {

      String sql="select `subject`.sno as subjectSno,subjectName,unit.sno as unitSno,unitName from subject "
          "inner join unit on unit.subjectSno=subject.sno group by unit.sno";
      List<Map<String,dynamic>> list = await txn.rawQuery(sql);
      for(var a in list){
        int totalSubjectTopic=0,totalUnitTopic=0,completedTopicByUser=0,completedUnitTopicByUser;

        String sql2="select COUNT(topic.sno) as totalSubjectTopic from subject "
            + "inner join course on course.sno=`subject`.courseSno "
            + "inner join unit on unit.`subjectSno` = `subject`.sno "
            + "INNER JOIN chapter on chapter.unitSno=unit.sno "
            + "INNER JOIN topic on topic.chapterSno=chapter.sno "
            + "where `subject`.sno=${a['subjectSno']}";
        List<Map<String,dynamic>> list=await txn.rawQuery(sql2);
        list.forEach((element) {
          totalSubjectTopic=element['totalSubjectTopic'];
        });

        String sql3="select COUNT(topic.sno) as totalUnitTopic "
            + "from `subject` "
            + "inner join course on course.sno=`subject`.courseSno "
            + "inner join unit on unit.subjectSno = `subject`.sno "
            + "INNER JOIN chapter on chapter.unitSno=unit.sno "
            + "INNER JOIN topic on topic.chapterSno=chapter.sno "
            + "where `unit`.sno=${a['unitSno']}";
        List<Map<String,dynamic>> list2=await txn.rawQuery(sql3);
        list2.forEach((element) {
          totalUnitTopic=element['totalUnitTopic'];
        });

        String sql4="SELECT COUNT(DISTINCT topicSno) from study "
            + "where register=$register and revision='$revision' "
            + "and subjectSno=${a['subjectSno']} and topicCompletionStatus='$status'";
        List<Map<String,dynamic>> list3=await txn.rawQuery(sql4);
        list3.forEach((element) {
          completedTopicByUser=element['completedTopicByUser'];
        });

        String sql5="SELECT COUNT(DISTINCT topicSno) from study "
            + "where register=$register and revision='$revision' "
            + "and unitSno=${a['unitSno']} and topicCompletionStatus='$status'";
        List<Map<String,dynamic>> list4=await txn.rawQuery(sql5);
        list4.forEach((element) {
          completedUnitTopicByUser=element['completedUnitTopicByUser'];
        });

        Map<String,dynamic> map=new Map();
        map.putIfAbsent('completedUnitTopicByUser', () => completedUnitTopicByUser ?? 0);
        map.putIfAbsent('completedTopicByUser', () => completedTopicByUser ?? 0);
        map.putIfAbsent('totalUnitTopic', () => totalUnitTopic ?? 0);
        map.putIfAbsent('totalSubjectTopic', () => totalSubjectTopic ?? 0);

        map.putIfAbsent('subjectSno', () => a['subjectSno'].toString() ?? 0);
        map.putIfAbsent('subjectName', () => a['subjectName'] ?? 0);
        map.putIfAbsent('unitSno', () => a['unitSno'].toString() ?? 0);
        map.putIfAbsent('unitName', () => a['unitName'] ?? 0);

        progressData.add(map);
      }
    });

   return progressData;
  }

  getChapterTopicByUnit(String unit, String register, String revision, String status)async{
    List<Map<String,dynamic>> chapterData=[];

       Database database =await dbHelper.database;


       await database.transaction((txn) async{
         String sql="select `chapter`.sno as chapterSno,chapterName,topic.sno as topicSno,topicName,"
             "topicImp, subtopic as sub,duration,course.sno as courseSno, subject.sno as subjectSno, unit.sno as unitSno "
             "from `subject` "
             "inner join course on course.sno=`subject`.courseSno "
             "inner join unit on unit.subjectSno = subject.sno "
             "inner JOIN chapter on chapter.unitSno=unit.sno "
             "inner JOIN topic on topic.chapterSno=chapter.sno "
             "where unit.sno=$unit";
         List<Map<String,dynamic>> list=await txn.rawQuery(sql);
         for(var a in list){
           int isUserStudied=0,totalChapterTopic=0,completedTopicByUser=0;
           String lastStudied="0",duration="",lastTestScore="0";

           String sql2="select COUNT(topic.sno) as totalChapterTopic from `subject` inner join course on course.sno=`subject`.courseSno "
               + "inner join unit on unit.subjectSno = `subject`.sno "
               + "INNER JOIN chapter on chapter.unitSno=unit.sno "
               + "INNER JOIN topic on topic.chapterSno=chapter.sno where `chapter`.sno='${a['chapterSno']}'";

           List<Map<String,dynamic>> list2=await txn.rawQuery(sql2);
           list2.forEach((element) {
             totalChapterTopic=element['totalChapterTopic'];
           });

           String sql3="SELECT COUNT(DISTINCT topicSno) from study "
               "where register=$register and revision=$revision "
               "and chapterSno=${a['chapterSno']} "
               "and topicCompletionStatus='$status'";

           List<Map<String,dynamic>> list3=await txn.rawQuery(sql3);
           list3.forEach((element) {
             completedTopicByUser=element['completedTopicByUser'];
           });

           String sql4="select count(DISTINCT topicSno) as isUserStudied from study "
               "where register =$register "
               "and revision =$revision "
               "and topicSno=${a['topicSno']} "
               "and topicCompletionStatus='$status'";

           List<Map<String,dynamic>> list4=await txn.rawQuery(sql4);
           list4.forEach((element) {
             isUserStudied=element['isUserStudied'];
           });

           String sql5="SELECT testPercent as lastTestScore from topic_test_result where regSno=$register and topicSno=${a['topicSno']} "
               "ORDER BY sno desc limit 1";

           List<Map<String,dynamic>> list5=await txn.rawQuery(sql5);
           list5.forEach((element) {
             lastTestScore=element['lastTestScore'];
           });

           String sql6="select revision from study where topicSno=${a['topicSno']} and register=$register "
               "ORDER BY sno desc limit 1";

           List<Map<String,dynamic>> list6=await txn.rawQuery(sql6);
           list6.forEach((element) {
             revision=element['revision'];
           });

           String sql7="select enteredDate from study where topicSno=${a['topicSno']} and register=$register "
               "order by sno desc limit 1";

           List<Map<String,dynamic>> list7=await txn.rawQuery(sql7);
           list7.forEach((element) {
             lastStudied=element['lastStudied'];
           });

           Map<String,dynamic> map=new Map();
           map.putIfAbsent('chapterName', () => a['chapterName'] ?? "");
           map.putIfAbsent('topicName', () => a['topicName'] ?? "");
           map.putIfAbsent('subtopic', () => a['sub'] ?? "");
           map.putIfAbsent('topicImp', () => double.tryParse(a['topicImp']) ?? 0);
           map.putIfAbsent('topicSno', () => a['topicSno'].toString() ?? "");
           map.putIfAbsent('courseSno', () => a['courseSno'].toString() ?? "");
           map.putIfAbsent('subjectSno', () => a['subjectSno'].toString() ?? "");
           map.putIfAbsent('unitSno', () => a['unitSno'].toString() ?? "");
           map.putIfAbsent('chapterSno', () => a['chapterSno'].toString() ?? "");

           map.putIfAbsent('revision', () =>revision ?? 0);
           map.putIfAbsent('isUserStudied', () =>isUserStudied ?? 0);
           map.putIfAbsent('lastTestScore', () =>lastTestScore ?? "0");
           map.putIfAbsent('lastStudied', () =>lastStudied ?? "0");
           map.putIfAbsent('totalChapterTopic', () =>totalChapterTopic ?? 0);
           map.putIfAbsent('completedTopicByUser', () =>completedTopicByUser ?? 0);
           map.putIfAbsent('duration', () =>duration ?? "0");


           map.putIfAbsent('totalChapterTopic', () => totalChapterTopic);

           chapterData.add(map);
         }
       });

     return chapterData;
  }
}