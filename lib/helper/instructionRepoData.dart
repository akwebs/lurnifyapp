import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/instruction_data.dart';
import 'package:sqflite/sqflite.dart';

class InstructionDataRepo{

  insertIntoInstructionData(InstructionData instructionData,String instructionSno,txn)async{
    try{

      List<Map<String,dynamic>> list=await txn.rawQuery("select sno from instruction_data where sno =${instructionData.sno}");
      if(list.isEmpty || list ==null){
        await txn.rawInsert("insert into instruction_data values(${instructionData.sno},'${instructionData.enteredBy}',"
            "'${instructionData.enteredDate}','${instructionData.instructions}','${instructionData.updatedBy}','${instructionData.updatedDate}',"
            "'$instructionSno')");
      }else if(list.isNotEmpty){
        await txn.rawQuery("update instruction_data set instructions='${instructionData.instructions}' , instructionSno='$instructionSno'"
            " where sno=${instructionData.sno}");
      }
      // await txn.rawQuery("delete from instruction_data where sno=${instructionData.sno}");
      //
      // await txn.rawInsert("insert into instruction_data values(${instructionData.sno},'${instructionData.enteredBy}',"
      //     "'${instructionData.enteredDate}','${instructionData.instructions}','${instructionData.updatedBy}','${instructionData.updatedDate}',"
      //     "'$instructionSno')");
    }catch(e){
      print('insertIntoDue_topic_tests : '+e.toString());
    }
  }
  Future<List<Map<String,dynamic>>> getInstructionData()async{
    try{
      DBHelper dbHelper = new DBHelper();
      Database db=await dbHelper.database;
      String sql="select * from instruction_data";
      print(sql);
      var result=db.rawQuery(sql);
      return result;
    }catch(e){
      print("getInstructionBySno"+e.toString());
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getInstructionDataByInstruction(String sno)async{
    try{
      DBHelper dbHelper = new DBHelper();
      Database db=await dbHelper.database;
      String sql="select * from instruction_data where instructionSno=$sno";
      print(sql);
      var result=db.rawQuery(sql);
      return result;
    }catch(e){
      print("getInstructionBySno"+e.toString());
      return [];
    }
  }

}