import 'package:lurnify/helper/db_helper.dart';

class ChallengeAcceptRepo {
  DBHelper dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> findByRegisterOrderBySnoAsc(String register, txn) {
    Future<List<Map<String, dynamic>>> list;
    try {
      list = txn.rawQuery('select * from challenge_accept where registerSno=$register order by sno desc');
    } catch (e) {
      //print(e.toString());
    }
    return list;
  }
}
