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
      test = <Test>[];
      json['test'].forEach((v) {
        test.add(Test.fromJson(v));
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
    instruction = json['instruction'] != null ? Instruction.fromJson(json['instruction']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['testName'] = testName;
    if (test != null) {
      data['test'] = test.map((v) => v.toJson()).toList();
    }
    data['topicType'] = topicType;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['topicSet'] = topicSet;

    data['courseSno'] = courseSno;
    data['subjectSno'] = subjectSno;
    data['unitSno'] = unitSno;
    data['chapterSno'] = chapterSno;
    data['topicSno'] = topicSno;
    data['topicTestTime'] = topicTestTime;
    if (instruction != null) {
      data['instruction'] = instruction.toJson();
    }
    return data;
  }
}
