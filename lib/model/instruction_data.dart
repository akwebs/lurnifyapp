class InstructionData {
  int sno;
  String instructions;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;

  InstructionData({this.sno, this.instructions, this.enteredBy, this.enteredDate, this.updatedBy, this.updatedDate});

  InstructionData.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    instructions = json['instructions'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['instructions'] = instructions;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    return data;
  }
}
