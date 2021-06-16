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
        aspectRatio: 4 / 2,
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
                        Expanded(
                          child: SmoothStarRating(
                            rating: _topicList[i]['topicRating'],
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
                            _topicList[i]['topicName'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 5,
                      thickness: 1,
                    ),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Studied'),
                          SizedBox(height: 10),
                          Text(
                            _topicList[i]['isStudied'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Test Scrore'),
                          SizedBox(height: 10),
                          Text(
                            _topicList[i]['testScore'] + "%",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Revision'),
                          SizedBox(height: 10),
                          Text(
                            _topicList[i]['revision'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Last Studied'),
                          SizedBox(height: 10),
                          Text(
                            _topicList[i]['lastStudied'].round().toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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
