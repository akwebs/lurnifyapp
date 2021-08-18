
class InstructionData {
  int sno;
  String instructions;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;

  InstructionData(
      {this.sno,
        this.instructions,
        this.enteredBy,
        this.enteredDate,
        this.updatedBy,
        this.updatedDate});

  InstructionData.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    instructions = json['instructions'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['instructions'] = this.instructions;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}