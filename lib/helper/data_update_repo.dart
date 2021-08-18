import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/DataUpdate.dart';
import 'package:sqflite/sqflite.dart';

class DataUpdateRepo{

  DBHelper dbHelper = new DBHelper();

  insertIntoDataUpdate(DataUpdate dataUpdate)async{
    try{
      Database database = await dbHelper.database;
      database.insert('data_update', dataUpdate.toJson());
    }catch(e){
      print(e.toString());
    }
  }

  findBySno()async{
    Future<List<Map<String,dynamic>>> list;
    try{
      String sql="select * from data_update order by sno desc limit 1";
      Database database = await dbHelper.database;
      list=database.rawQuery(sql);
    }catch(e){
      print(e.toString());
    }
    return list;
  }
}