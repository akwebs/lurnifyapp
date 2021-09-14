import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/model/remark.dart';
import 'package:sqflite/sqflite.dart';

class RemarkRepo {
  DBHelper dbHelper = DBHelper();
  insertIntoRemark(Remark remark) async {
    try {
      Database db = await dbHelper.database;
      db.insert('remark', remark.toJson());
    } catch (e) {
      //print('insertCourseGroupBatch : ' + e.toString());
    }
  }
}
