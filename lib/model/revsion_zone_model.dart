class RevisionZoneModel{
   String topicSno;
   String topicName;
   String subTopic;
   int isUserStudied;
   double lastTestScore;
   String revision;
   String lastStudied;
   String subjectSno;
   String subjectName;
   double topicImp;
   int totalSubject;
   String unitName;
   String chapterName;

   RevisionZoneModel();

   RevisionZoneModel.fromJson(Map<String, dynamic> json) {
      topicSno = json['topicSno'];
      topicName = json['topicName'];
      subTopic = json['subTopic'];
      isUserStudied = json['isUserStudied'];
      lastTestScore = json['lastTestScore'];
      revision = json['revision'];
      lastStudied = json['lastStudied'];
      subjectSno = json['subjectSno'];
      subjectName = json['subjectName'];
      topicImp = json['topicImp'];
      totalSubject = json['totalSubject'];
      unitName = json['unitName'];
      chapterName = json['chapterName'];
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['topicSno'] = this.topicSno;
      data['topicName'] = this.topicName;
      data['subTopic'] = this.subTopic;
      data['isUserStudied'] = this.isUserStudied;
      data['lastTestScore'] = this.lastTestScore;
      data['revision'] = this.revision;
      data['lastStudied'] = this.lastStudied;
      data['subjectSno'] = this.subjectSno;
      data['subjectName'] = this.subjectName;
      data['topicImp'] = this.topicImp;
      data['totalSubject'] = this.totalSubject;
      data['unitName'] = this.unitName;
      data['chapterName'] = this.chapterName;
      return data;
   }
}