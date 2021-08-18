import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/dimes.dart';
import 'package:sqflite/sqflite.dart';

class DimeRepo {
  DBHelper dbHelper = new DBHelper();

  Future<List<Map<String, dynamic>>> getReward() async {
    Database db = await dbHelper.database;
    String sql = "select * from dime limit 1";
    print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  insertIntoDimes(Dimes dimes) async {
    try {
      Database db = await dbHelper.database;
      db.insert('dimes', dimes.toJson());
    } catch (e) {
      print('insertCourseGroupBatch : ' + e.toString());
    }
  }

  getTotalDimesByRegister(register, txn) async {
    String sql =
        "select (sum(credit)-sum(debit)) as totalDimes from dimes where registerSno=$register";
    return txn.rawQuery(sql);
  }
}
