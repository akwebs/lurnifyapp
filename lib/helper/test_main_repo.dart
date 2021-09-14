import 'package:lurnify/helper/db_helper.dart';
import 'package:lurnify/helper/topic_test_result_repo.dart';
import 'package:lurnify/model/test_main.dart';
import 'package:sqflite/sqflite.dart';

class TestMainRepo {
  DBHelper dbHelper = DBHelper();

  insertIntoTestMain(TestMain testMain, txn) async {
    try {
      txn.rawQuery("delete from test_main where sno=${testMain.sno}");

      txn.rawInsert("insert into test_main values(${testMain.sno},'${testMain.enteredBy}','${testMain.enteredDate}',"
          "'${testMain.testName}','${testMain.topicSet.toString()}','${testMain.updatedBy}','${testMain.updatedDate}',"
          "'${testMain.chapterSno}','${testMain.courseSno}','${testMain.instruction.sno}','${testMain.subjectSno}',"
          "'${testMain.topicSno}','${testMain.unitSno}','${testMain.topicType}','${testMain.topicTestTime}')");
    } catch (e) {
      //print('insertIntoTestMain : ' + e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getTestMainByChapter(String chapter) async {
    Database db = await dbHelper.database;
    String sql = "select * from test_main where chapter=$chapter";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> findByTopic(String topic) async {
    Database db = await dbHelper.database;
    String sql = "select * from test_main where topic=$topic";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> findByTopicSetAndTopic(String topicSet, String topic) async {
    Database db = await dbHelper.database;
    String sql = "select * from test_main where topic=$topic and topicSet=$topicSet";
    //print(sql);
    var result = db.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> findByTopicAndRegister(String topic, String register) async {
    Future<List<Map<String, dynamic>>> test;

    List<Map<String, dynamic>> findByTopicList = await findByTopic(topic);

    TopicTestResultRepo topicTestResultRepo = new TopicTestResultRepo();
    List<Map<String, dynamic>> find = await topicTestResultRepo.findTopByRegisterAndTopicOrderBySnoDesc(register, topic);

    if (find == null || find.isEmpty) {
      //print('1');
      test = findByTopicSetAndTopic('1', topic);
    } else if (double.parse(find[0]['testPercent']) < 50) {
      test = findByTopicSetAndTopic('1', topic);
    } else if (double.parse(find[0]['testPercent']) >= 50 && double.parse(find[0]['testPercent']) < 70) {
      int setNo = 0;
      if (findByTopicList[0]['topicSet'] + 1 > findByTopicList.length) {
        setNo = findByTopicList.length;
      } else {
        setNo = findByTopicList[0]['topicSet'] + 1;
      }
      test = findByTopicSetAndTopic(setNo.toString(), topic);
    } else if (double.parse(find[0]['testPercent']) >= 70 && double.parse(find[0]['testPercent']) < 90) {
      int setNo = 0;
      if (findByTopicList[0]['topicSet'] + 2 > findByTopicList.length) {
        setNo = findByTopicList.length;
      } else {
        setNo = findByTopicList[0]['topicSet'] + 2;
      }
      test = findByTopicSetAndTopic(setNo.toString(), topic);
    } else if (double.parse(find[0]['testPercent']) >= 90 && double.parse(find[0]['testPercent']) <= 100) {
      int setNo = 0;
      if (findByTopicList[0]['topicSet'] + 3 > findByTopicList.length) {
        setNo = findByTopicList.length;
      } else {
        setNo = findByTopicList[0]['topicSet'] + 3;
      }
      test = findByTopicSetAndTopic(setNo.toString(), topic);
    } else {
      test = findByTopicSetAndTopic('1', topic);
    }
    return test;
  }
}
