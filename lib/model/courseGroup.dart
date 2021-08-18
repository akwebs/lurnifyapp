class CourseGroup {
  int sno;
  String groupName;
  String year;
  String type;
  String startDate;
  String endDate;

  CourseGroup(
      {this.sno,
        this.groupName,
        this.year,
        this.type,
        this.startDate,
        this.endDate});

  CourseGroup.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    groupName = json['groupName'];
    year = json['year'];
    type = json['type'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['groupName'] = this.groupName;
    data['year'] = this.year;
    data['type'] = this.type;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'sno': sno,
      'groupName': groupName,
      'year': year,
      'type': type,
      'startDate': startDate,
      'endDate':endDate,
    };
  }
}