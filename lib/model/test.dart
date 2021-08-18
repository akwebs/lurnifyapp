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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sno'] = this.sno;
    data['fileName'] = this.fileName;
    data['directory'] = this.directory;
    data['filePath'] = this.filePath;
    data['answer'] = this.answer;
    data['solutionFileName'] = this.solutionFileName;
    data['solutionDirectory'] = this.solutionDirectory;
    data['solutionFilePath'] = this.solutionFilePath;
    data['difficulty'] = this.difficulty;
    data['questionType'] = this.questionType;
    data['noOfOptions'] = this.noOfOptions;
    data['uuid'] = this.uuid;
    data['encodedImage'] = this.encodedImage;
    data['enteredBy'] = this.enteredBy;
    data['enteredDate'] = this.enteredDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['testMain'] = this.testMain;
    data['encodedSolution'] = this.encodedSolution;
    return data;
  }
}