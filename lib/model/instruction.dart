import 'package:lurnify/model/instruction_data.dart';

class Instruction {
  int sno;
  String instructionPageName;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;
  List<InstructionData> instructionData;

  Instruction({this.sno, this.instructionPageName, this.enteredBy, this.enteredDate, this.updatedBy, this.updatedDate, this.instructionData});

  Instruction.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    instructionPageName = json['instructionPageName'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    if (json['instructionData'] != null) {
      instructionData = <InstructionData>[];
      json['instructionData'].forEach((v) {
        instructionData.add(InstructionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['instructionPageName'] = instructionPageName;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    if (instructionData != null) {
      data['instructionData'] = instructionData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
