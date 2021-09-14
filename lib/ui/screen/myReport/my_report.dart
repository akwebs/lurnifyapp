import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/helper/my_report.dart';
import 'package:lurnify/helper/topic_test_result_repo.dart';
import 'package:lurnify/ui/screen/myReport/my_report_overall.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReportHome extends StatefulWidget {
  const MyReportHome({Key key}) : super(key: key);

  @override
  _MyReportHomeState createState() => _MyReportHomeState();
}

class _MyReportHomeState extends State<MyReportHome> {
  List<Map<String, dynamic>> _subjectData = [];
  double totalCompletedTopicMinutes = 0, totalTopicDurationInMinute = 0;
  double _syllabusCompleted = 0;
  int _completedDays = 0;
  int _totalDays = 0;
  double _preparationTimePassed = 0;
  double _overallProgress = 0;
  _getMyReport() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      MyReportRepo myReportRepo = MyReportRepo();
      _subjectData = await myReportRepo.getMyReport(sp.getString("studentSno"));

      TopicTestResultRepo repo = TopicTestResultRepo();
      var a = await repo.getData("", "");
      print(a);
      // var url=baseUrl+"myReport?regSno="+sp.getString("studentSno");
      // print(url);
      // http.Response response = await http.post(Uri.encodeFull(url));
      // _subjectData=jsonDecode(response.body);

      for (var a in _subjectData) {
        totalCompletedTopicMinutes = totalCompletedTopicMinutes + (a['totalCompletedTopicMinutes'] ?? 0);
        totalTopicDurationInMinute = totalTopicDurationInMinute + (a['totalTopicDurationInMinute'] ?? 0);

        _completedDays = a['totalCompletedDays'].round() ?? "0";
        if (_completedDays < 0) {
          _completedDays = 0;
        }
        _totalDays = a['totalCourseDays'].round() ?? "0";
      }

      print(totalTopicDurationInMinute);

      _syllabusCompleted = (totalCompletedTopicMinutes / totalTopicDurationInMinute);
      if (_syllabusCompleted.isNaN || _syllabusCompleted == null) {
        _syllabusCompleted = 0;
      }

      _preparationTimePassed = (_completedDays / _totalDays);
      if (_preparationTimePassed == null || _preparationTimePassed.isNaN) {
        _preparationTimePassed = 0;
      }

      _overallProgress = _syllabusCompleted / _preparationTimePassed;
      if (_overallProgress == null || _overallProgress.isNaN) {
        _overallProgress = 0;
      } else if (_syllabusCompleted > 0 && _preparationTimePassed == 0) {
        _overallProgress = 0;
      } else if (_overallProgress < 0) {
        _overallProgress = 0;
      } else if (_overallProgress > 1) {
        _overallProgress = 1;
      }

      print(_overallProgress);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Something went wrong. Please try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'My Report',
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getMyReport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyReportOverAll(_subjectData, -1),
                            ));
                          },
                          child: AspectRatio(
                            aspectRatio: 3 / 1.4,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Overall',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                      child: Text(
                                        (_overallProgress * 100).toStringAsFixed(2) + ' %',
                                        style: const TextStyle(color: Colors.black, fontSize: 50),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearPercentIndicator(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        lineHeight: 10,
                                        percent: _overallProgress,
                                        backgroundColor: Colors.black.withOpacity(0.2),
                                        progressColor: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.limeAccent[200].withOpacity(0.1), Colors.teal[200].withOpacity(0.1)],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _subjectData.length,
                          itemBuilder: (context, i) {
                            double totalCompletedTopicMinutes = _subjectData[i]['totalCompletedTopicMinutes'].toDouble() ?? 0;
                            double totalTopicDurationInMinute = _subjectData[i]['totalTopicDurationInMinute'].toDouble() ?? 0;
                            double syllabusCompleted = (totalCompletedTopicMinutes / totalTopicDurationInMinute);
                            if (syllabusCompleted == null || syllabusCompleted.isNaN) {
                              syllabusCompleted = 0;
                            } else if (totalCompletedTopicMinutes > 0 && totalTopicDurationInMinute == 0) {
                              syllabusCompleted = 0;
                            } else if (syllabusCompleted < 0) {
                              syllabusCompleted = 0;
                            } else if (syllabusCompleted > 1) {
                              syllabusCompleted = 1;
                            }

                            double subProgress = syllabusCompleted / _preparationTimePassed;
                            if (subProgress.isNaN || subProgress == null) {
                              subProgress = 0;
                            } else if (syllabusCompleted > 0 && _preparationTimePassed == 0) {
                              subProgress = 0;
                            } else if (subProgress < 0) {
                              subProgress = 0;
                            } else if (subProgress > 1) {
                              subProgress = 1;
                            }
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyReportOverAll(_subjectData, i),
                                    ));
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 3 / 1.4,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _subjectData[i]['subjectName'],
                                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                              child: Text(
                                                (subProgress * 100).toStringAsFixed(2) + ' %',
                                                style: const TextStyle(color: Colors.black, fontSize: 50),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: LinearPercentIndicator(
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                                lineHeight: 10,
                                                percent: subProgress,
                                                backgroundColor: Colors.black.withOpacity(0.2),
                                                progressColor: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.limeAccent[200].withOpacity(0.1), Colors.teal[200].withOpacity(0.1)],
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
