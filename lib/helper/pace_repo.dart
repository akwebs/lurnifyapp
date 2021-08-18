import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/pace.dart';
import 'package:sqflite/sqflite.dart';

class PaceRepo{


  DBHelper dbHelper = new DBHelper();


  insertIntoPace(Pace pace)async{
    try{
      Database db=await dbHelper.database;
      db.insert('pace', pace.toJson());
    }catch(e){
      print('insertIntoPace : '+e.toString());
    }
  }
}