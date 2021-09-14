class Dimes {
  int sno;
  int credit;
  int debit;
  String message;
  String registerSno;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;
  String status;

  Dimes({
    this.sno,
    this.credit,
    this.debit,
    this.message,
    this.registerSno,
    this.enteredBy,
    this.enteredDate,
    this.updatedBy,
    this.updatedDate,
    this.status,
  });

  Dimes.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    credit = json['credit'];
    debit = json['debit'];
    message = json['message'];
    registerSno = json['registerSno'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['credit'] = credit;
    data['debit'] = debit;
    data['message'] = message;
    data['registerSno'] = registerSno;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['status'] = status;
    return data;
  }
}
