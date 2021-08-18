class Register{
  int sno;
  String block;
  String mobileno;
  String accounttypeId;
  String courseId;
  String firstMonday;
  String joiningDate;
  String enteredDate;

  Register();

  Register.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    block = json['block'];
    mobileno = json['mobileno'];
    accounttypeId = json['accounttypeId'];
    courseId = json['courseId'];
    firstMonday = json['firstMonday'];
    joiningDate = json['joiningDate'];
    enteredDate = json['enteredDate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['block'] = this.block;
    data['mobileno'] = this.mobileno;
    data['accounttypeId'] = this.accounttypeId;
    data['courseId'] = this.courseId;
    data['firstMonday'] = this.firstMonday;
    data['joiningDate'] = this.joiningDate;
    data['enteredDate'] = this.enteredDate;
    return data;
  }
}