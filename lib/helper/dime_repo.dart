import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/dimes.dart';
import 'package:sqflite/sqflite.dart';

class DimeRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getReward() async {
    Database db = await dbHelper.database;
    String sql = "select * from dime limit 1";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  insertIntoDimes(Dimes dimes) async {
    try {
      Database db = await dbHelper.database;
      db.insert('dimes', dimes.toJson());
    } catch (e) {
      //print('insertCourseGroupBatch : ' + e.toString());
    }
  }

  getTotalDimesByRegister(register, txn) async {
    String sql = "select (sum(credit)-sum(debit)) as totalDimes from dimes where registerSno=$register";
    return txn.rawQuery(sql);
  }

  Future<List<Map<String, dynamic>>> getNewDimes() async {
    Database db = await dbHelper.database;
    String sql = "select * from dimes where status='new'";
    var result = db.rawQuery(sql);
    return result;
  }
}
