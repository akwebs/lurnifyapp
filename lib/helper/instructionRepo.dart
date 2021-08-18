import 'package:lurnify/helper/DBHelper.dart';
import 'package:lurnify/model/instruction.dart';
import 'package:sqflite/sqflite.dart';

class InstructionRepo{

  insertIntoInstruction(Instruction instruction,txn)async{
    try{

      List<Map<String,dynamic>> list=await txn.rawQuery("select sno from instruction where sno =${instruction.sno}");
      if(list.isEmpty || list==null){
        await txn.rawQuery("insert into instruction values(${instruction.sno},'${instruction.enteredBy}',"
            "'${instruction.enteredDate}','${instruction.instructionPageName}','${instruction.updatedBy}'"
            ",'${instruction.updatedDate}')");
      }else if(list.isNotEmpty){
        await txn.rawQuery("update instruction set instructionPageName='${instruction.instructionPageName}' "
            "where sno=${instruction.sno}");
      }
      // await txn.rawQuery("delete from instruction where sno=${instruction.sno}");
      //
      // await txn.rawQuery("insert into instruction values(${instruction.sno},'${instruction.enteredBy}',"
      //     "'${instruction.enteredDate}','${instruction.instructionPageName}','${instruction.updatedBy}'"
      //     ",'${instruction.updatedDate}')");
    }catch(e){
      print('insertIntoInstruction : '+e.toString());
    }
  }

  Future<List<Map<String,dynamic>>> getInstruction()async{
    try{
      DBHelper dbHelper = new DBHelper();
      Database db=await dbHelper.database;
      String sql="select * from instruction";
      print(sql);
      var result=db.rawQuery(sql);
      return result;
    }catch(e){
      print("getInstructionBySno"+e.toString());
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getInstructionBySno(String sno)async{
    try{
      DBHelper dbHelper = new DBHelper();
      Database db=await dbHelper.database;
      String sql="select * from instruction where sno=$sno";
      print(sql);
      var result=db.rawQuery(sql);
      return result;
    }catch(e){
      print("getInstructionBySno"+e.toString());
      return [];
    }
  }

}