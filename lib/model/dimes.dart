class Dimes{
  int sno;
  int credit;
  int debit;
  String message;
  String registerSno;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;

  Dimes(
      {this.sno,
        this.credit,
        this.debit,
        this.message,
        this.registerSno,
        this.enteredBy,
        this.enteredDate,
        this.updatedBy,
        this.updatedDate});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['credit'] = this.credit;
    data['debit'] = this.debit;
    data['message'] = this.message;
    data['registerSno'] = this.registerSno;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}