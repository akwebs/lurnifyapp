class Test {
  int sno;
  String fileName;
  String directory;
  String filePath;
  String answer;
  String solutionFileName;
  String solutionDirectory;
  String solutionFilePath;
  String difficulty;
  String questionType;
  String noOfOptions;
  String uuid;
  String encodedImage;
  String enteredBy;
  String enteredDate;
  String updatedBy;
  String updatedDate;
  String testMain;
  String encodedSolution;

  Test(
      {this.sno,
      this.fileName,
      this.directory,
      this.filePath,
      this.answer,
      this.solutionFileName,
      this.solutionDirectory,
      this.solutionFilePath,
      this.difficulty,
      this.questionType,
      this.noOfOptions,
      this.uuid,
      this.encodedImage,
      this.enteredBy,
      this.enteredDate,
      this.updatedBy,
      this.updatedDate,
      this.encodedSolution,
      this.testMain});

  Test.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    fileName = json['fileName'];
    directory = json['directory'];
    filePath = json['filePath'];
    answer = json['answer'];
    solutionFileName = json['solutionFileName'];
    solutionDirectory = json['solutionDirectory'];
    solutionFilePath = json['solutionFilePath'];
    difficulty = json['difficulty'];
    questionType = json['questionType'];
    noOfOptions = json['noOfOptions'];
    uuid = json['uuid'];
    encodedImage = json['encodedImage'];
    enteredBy = json['enteredBy'];
    enteredDate = json['enteredDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    testMain = json['testMain'];
    encodedSolution = json['encodedSolution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sno'] = sno;
    data['fileName'] = fileName;
    data['directory'] = directory;
    data['filePath'] = filePath;
    data['answer'] = answer;
    data['solutionFileName'] = solutionFileName;
    data['solutionDirectory'] = solutionDirectory;
    data['solutionFilePath'] = solutionFilePath;
    data['difficulty'] = difficulty;
    data['questionType'] = questionType;
    data['noOfOptions'] = noOfOptions;
    data['uuid'] = uuid;
    data['encodedImage'] = encodedImage;
    data['enteredBy'] = enteredBy;
    data['enteredDate'] = enteredDate;
    data['updatedBy'] = updatedBy;
    data['updatedDate'] = updatedDate;
    data['testMain'] = testMain;
    data['encodedSolution'] = encodedSolution;
    return data;
  }
}
