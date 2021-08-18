import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/register.dart';
import 'package:sqflite/sqflite.dart';

class RegisterRepo{

  DBHelper dbHelper = new DBHelper();
  insertIntoRegister(Register register)async{
    try{
      Database db=await dbHelper.database;
      db.insert('register', register.toJson());
    }catch(e){
      print('insertIntoRegister : '+e.toString());
    }
  }
}