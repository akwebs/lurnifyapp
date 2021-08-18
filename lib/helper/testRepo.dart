import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/test.dart';
import 'package:sqflite/sqflite.dart';

class TestRepo{
  DBHelper dbHelper = new DBHelper();
  insertIntoTest(Test test,txn)async{
    try{
      print(test.toJson());
      txn.rawQuery("delete from test where sno=${test.sno}");
      txn.insert('test', test.toJson());
    }catch(e){
      print('insertIntoTest : '+e.toString());
    }
  }
  Future<List<Map<String,dynamic>>> getTestByTestMain(String testMainSno)async{
    Database db = await dbHelper.database;
    String sql = "select * from test where testMain=$testMainSno";
    print(sql);
    var result = db.rawQuery(sql);
    return result;
  }
}