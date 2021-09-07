import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/study.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class StudyRepo{
  DBHelper dbHelper = new DBHelper();
  insertIntoStudy(Study study)async{
    try{
      Database db=await dbHelper.database;
      db.insert('study', study.toJson());
    }catch(e){
      print('insertIntoStudy : '+e.toString());
    }
  }
  Future<List<Map<String,dynamic>>> checkEndDateForManualEntry()async{
    Database db = await dbHelper.database;
    String sql = "select * from study order by sno desc limit 1";
    print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String,dynamic>>> getDailyStudy(String register,txn){
    Future<List<Map<String,dynamic>>> list;
    try{
      String sql="select (sum(totalSecond)/3600) as totalHour,date from study where register=$register and date>="
          + "(select date('now', 'weekday 0', '-1 days')) group by date";
      list=txn.rawQuery(sql);
    }catch(e){
      print('getDailyStudy'+ e.toString());
    }
    return list;
  }

  Future<List<Map<String,dynamic>>> getNewStudy()async{
    Database db=await dbHelper.database;
    String sql="select * from study where status='new'";
    var result=db.rawQuery(sql);
    return result;
  }


  Future<List<Map<String,dynamic>>> markStudyComplete(String chapter, String unit, String subject)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String register=sp.getString('studentSno');
    String enteredDate=DateTime.now().toString();
    Database db=await dbHelper.database;
    db.transaction((txn)async {
      String sql="select count(sno)-(select count(sno) from topic "
          "where chapterSno='$chapter') as leftTopics from study "
          "where chapterSno='$chapter' "
          "and topicCompletionStatus='Complete' "
          "and revision='0' "
          "group by topicSno";
      List<Map<String,dynamic>> list = await txn.rawQuery(sql);
      for(var a in list){
        if(a['leftTopics']==0){
          String sql2="insert into completed_chapters(chapter,register,enteredDate,unit,subject) "
              "values('$chapter','$register','$enteredDate','$unit','$subject')";
          await db.rawQuery(sql2);

          String sql3="select count(sno)-(select count(sno) "
              "from chapter where unitSno='$unit') as leftChapters"
              "from completed_chapters "
              "where unit='$unit'";

          List<Map<String,dynamic>> list2 = await txn.rawQuery(sql3);
          for(var b in list2){
            if(b['leftChapters']==0){
              String sql4="insert into completed_units(chapter,register,enteredDate,unit,subject) "
                  "values('$chapter','$register','$enteredDate','$unit','$subject')";
              await db.rawQuery(sql4);

              String sql5="select count(sno)-(select count(sno) "
                  "from unit where subjectSno='$subject') as leftUnits"
                  "from completed_units "
                  "where subject='$subject'";

              List<Map<String,dynamic>> list3 = await txn.rawQuery(sql5);
              for(var c in list3){
                if(c['leftUnits']==0){
                  String sql6="insert into completed_subjects(chapter,register,enteredDate,unit,subject) "
                      "values('$chapter','$register','$enteredDate','$unit','$subject')";
                  await db.rawQuery(sql6);
                }
              }
            }
          }
        }
      }

      return null;
    });
  }
}