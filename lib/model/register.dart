class Register {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['block'] = block;
    data['mobileno'] = mobileno;
    data['accounttypeId'] = accounttypeId;
    data['courseId'] = courseId;
    data['firstMonday'] = firstMonday;
    data['joiningDate'] = joiningDate;
    data['enteredDate'] = enteredDate;
    return data;
  }
}
