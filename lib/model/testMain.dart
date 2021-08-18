import 'package:lurnify/model/instruction.dart';
import 'package:lurnify/model/test.dart';

class TestMain {
  int sno;
  String testName;
  List<Test> test;
  String topicType;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;
  int topicSet;
  Instruction instruction;
  String instructionD;
  int courseSno;
  int subjectSno;
  int unitSno;
  int chapterSno;
  int topicSno;
  int topicTestTime;

  TestMain(
      {this.sno,
        this.testName,
        this.test,
        this.topicType,
        this.enteredBy,
        this.enteredDate,
        this.updatedBy,
        this.updatedDate,
        this.topicSet,
        this.instruction,
      this.courseSno,
      this.subjectSno,
      this.unitSno,
      this.chapterSno,
      this.topicSno,
      this.topicTestTime});

  TestMain.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    testName = json['testName'];
    if (json['test'] != null) {
      test = new List<Test>();
      json['test'].forEach((v) {
        test.add(new Test.fromJson(v));
      });
    }
    topicType = json['topicType'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    topicSet = json['topicSet'];
    courseSno = json['courseSno'];
    subjectSno = json['subjectSno'];
    unitSno = json['unitSno'];
    chapterSno = json['chapterSno'];
    topicSno = json['topicSno'];
    topicTestTime = json['topicTestTime'];
    instruction = json['instruction'] != null
        ? new Instruction.fromJson(json['instruction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['testName'] = this.testName;
    if (this.test != null) {
      data['test'] = this.test.map((v) => v.toJson()).toList();
    }
    data['topicType'] = this.topicType;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['topicSet'] = this.topicSet;

    data['courseSno'] = this.courseSno;
    data['subjectSno'] = this.subjectSno;
    data['unitSno'] = this.unitSno;
    data['chapterSno'] = this.chapterSno;
    data['topicSno'] = this.topicSno;
    data['topicTestTime'] = this.topicTestTime;
    if (this.instruction != null) {
      data['instruction'] = this.instruction.toJson();
    }
    return data;
  }
}