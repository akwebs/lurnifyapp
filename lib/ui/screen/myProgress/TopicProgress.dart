import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class TopicProgress extends StatefulWidget {
  final chapterSno;
  final String cname;
  TopicProgress(this.chapterSno, this.cname);
  @override
  _TopicProgressState createState() => _TopicProgressState(chapterSno, cname);
}

class _TopicProgressState extends State<TopicProgress> {
  final chapterSno;
  final String cname;
  _TopicProgressState(this.chapterSno, this.cname);
  List _topicList = [];

  Future _getTopicsByChapter() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var url = baseUrl +
        "getTopicProgressByChapter?chapterSno=" +
        chapterSno.toString() +
        "&regSno=" +
        sp.getString("studentSno").toString();
    print(url);
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    _topicList = resbody;
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
                  itemCount: _topicList.length,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, i) {
                    return cards(i);
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

  // Widget topicCard(int i) {
  //   return Container(
  //     child: ExpansionTile(
  //       title: Text(_topicList[i]['topicName']),
  //       leading: SmoothStarRating(
  //         rating: _topicList[i]['topicRating'],
  //         size: 20,
  //         starCount: 5,
  //         allowHalfRating: true,
  //         color: Colors.amber,
  //         isReadOnly: true,
  //         // defaultIconData: Icons.blur_off,
  //         borderColor: Colors.amber,
  //       ),
  //       children: [
  //         Align(),
  //       ],
  //     ),
  //   );
  // }

// _topicList[i]['topicName']
//  _topicList[i]['subTopic']
// _topicList[i]['isStudied']
// _topicList[i]['testScore'] + "%"
// _topicList[i]['revision']
// _topicList[i]['lastStudied'].round().toString()

  Widget cards(int i) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_topicList[i]['topicName']),
                        SmoothStarRating(
                          rating: _topicList[i]['topicRating'],
                          size: 16,
                          starCount: 5,
                          allowHalfRating: true,
                          color: Colors.amber,
                          isReadOnly: true,
                          // defaultIconData: Icons.blur_off,
                          borderColor: Colors.amber,
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Icon(Icons.fact_check_outlined)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Studied'),
                                      SizedBox(height: 10),
                                      Text(
                                        _topicList[i]['isStudied'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1, child: Icon(Icons.score_outlined)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Test Scrore'),
                                      SizedBox(height: 10),
                                      Text(
                                        _topicList[i]['testScore'] + "%",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Icon(Icons.restore)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Revision'),
                                      SizedBox(height: 10),
                                      Text(
                                        _topicList[i]['revision'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Icon(Icons.more_time_outlined)),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Last Studied'),
                                      SizedBox(height: 10),
                                      Text(
                                        _topicList[i]['lastStudied']
                                            .round()
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Start Study'),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
