import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/study.dart';
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

}