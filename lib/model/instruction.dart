import 'package:lurnify/model/instruction_data.dart';

class Instruction {
  int sno;
  String instructionPageName;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;
  List<InstructionData> instructionData;

  Instruction(
      {this.sno,
        this.instructionPageName,
        this.enteredBy,
        this.enteredDate,
        this.updatedBy,
        this.updatedDate,
        this.instructionData});

  Instruction.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    instructionPageName = json['instructionPageName'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    if (json['instructionData'] != null) {
      instructionData = new List<InstructionData>();
      json['instructionData'].forEach((v) {
        instructionData.add(new InstructionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['instructionPageName'] = this.instructionPageName;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    if (this.instructionData != null) {
      data['instructionData'] =
          this.instructionData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}