import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/recentStudy.dart';
import 'package:sqflite/sqflite.dart';

class RecentStudyRepo{
  DBHelper dbHelper = new DBHelper();

  Future<List<Map<String,dynamic>>> getRecentStudy()async{
    Database db=await dbHelper.database;
    String sql="select *,subtopic,recent_study.duration,topic.sno as topicSno, subject.sno as subjectSno, "
        "unit.sno as unitSno, chapter.sno as chapterSno from recent_study "
        "inner join subject on recent_study.subject=subject.sno "
        "inner join unit on unit.sno=recent_study.unit inner join chapter on chapter.sno=recent_study.chapter "
        "inner join topic on topic.sno= recent_study.topic group by recent_study.topic";
    print(sql);
    var result=db.rawQuery(sql);
    return result;
  }

  insertIntoRecentStudy(RecentStudy study)async{
    try{
      Database db=await dbHelper.database;
      db.insert('recent_study', study.toJson());
    }catch(e){
      print('insertIntoRecent_study : '+e.toString());
    }
  }
}