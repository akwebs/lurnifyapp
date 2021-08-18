import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/selfstudy/starttimer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class TopicProgress extends StatefulWidget {
  final chapterSno;
  final String cname;
  final List topics;
  TopicProgress(this.chapterSno, this.cname, this.topics);
  @override
  _TopicProgressState createState() =>
      _TopicProgressState(chapterSno, cname, topics);
}

class _TopicProgressState extends State<TopicProgress> {
  final chapterSno;
  final String cname;
  final List topics;
  _TopicProgressState(this.chapterSno, this.cname, this.topics);
  // List topics = [];

  Future _getTopicsByChapter() async {
    print(topics);
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // var url = baseUrl +
    //     "getTopicProgressByChapter?chapterSno=" +
    //     chapterSno.toString() +
    //     "&regSno=" +
    //     sp.getString("studentSno").toString();
    // print(url);
    // http.Response response = await http.get(
    //   Uri.encodeFull(url),
    // );
    // var resbody = jsonDecode(response.body);
    // topics = resbody;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTopicsByChapter(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: Container(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(cname + ' Progress'),
                  centerTitle: true,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.yellow],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: ListView.builder(
                  itemCount: topics.length,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return _cards(i);
                  },
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[200].withOpacity(0.2),
                    Colors.lightBlue[200].withOpacity(0.1)
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _cards(int i) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 1, color: firstColor)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SmoothStarRating(
                          rating: topics[i]['topicImp'],
                          size: 16,
                          starCount: 5,
                          allowHalfRating: true,
                          color: Colors.amber,
                          isReadOnly: true,
                          // defaultIconData: Icons.blur_off,
                          borderColor: Colors.amber,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          topics[i]['topicName'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.add_circle_outline_rounded),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StartTimer(
                                          topics[i]['courseSno'],
                                          topics[i]['subjectSno'],
                                          topics[i]['unitSno'],
                                          topics[i]['chapterSno'],
                                          topics[i]['topicSno'],
                                          topics[i]['subtopic'],
                                          topics[i]['duration'])));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: _randomColor(i),
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: firstColor))),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Sub Topics :',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      topics[i]['subtopic'],
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 5,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(
                        i,
                        'Studied',
                        topics[i]['isUserStudied'] == 0 ? "No" : "Yes",
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(
                        i,
                        'Test Score',
                        topics[i]['lastTestScore'] == null
                            ? "0"
                            : topics[i]['lastTestScore'].toString() == "Nan"
                                ? "0"
                                : topics[i]['lastTestScore'].toString() + "%",
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(
                        i,
                        'Revision',
                        topics[i]['revision'] == null
                            ? "0"
                            : topics[i]['revision'].toString(),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        child: _topicInfo(
                            i,
                            'Last Studied',
                            topics[i]['lastStudied'] == null
                                ? "Not studied yet"
                                : topics[i]['lastStudied'].toString() +
                                    ' days ago')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Column _topicInfo(int i, String heading, String detail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        heading,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      SizedBox(height: 10),
      Text(
        detail,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Color _randomColor(int i) {
  if (i % 3 == 0) {
    return AppColors.tileColors[3];
  } else if (i % 3 == 1) {
    return AppColors.tileColors[2];
  } else if (i % 3 == 2) {
    return AppColors.tileColors[1];
  }
  return AppColors.tileColors[0];
}
