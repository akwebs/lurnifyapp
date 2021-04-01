// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lurnify/config/data.dart';
// import 'package:lurnify/model/chapters.dart';
// import 'package:lurnify/model/subject.dart';
// import 'package:lurnify/model/topics.dart';
// import 'package:lurnify/model/units.dart';
// import 'package:lurnify/ui/constant/ApiConstant.dart';
// import 'package:lurnify/ui/constant/constant.dart';
// import 'package:lurnify/ui/screen/selfstudy/starttimer.dart';
// import 'package:lurnify/ui/screen/selfstudy/syncyourtime.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math' as math;

// class ContentSelection extends StatefulWidget {
//   final String pageKey;

//   ContentSelection(this.pageKey);
//   @override
//   _ContentSelectionState createState() => _ContentSelectionState(pageKey);
// }

// class _ContentSelectionState extends State<ContentSelection> {
//   String pageKey;
//   get cardPed => Responsive.getPercent(5, ResponsiveSize.WIDTH, context);
//   _ContentSelectionState(this.pageKey);

//   // List _subjects = [];
//   // List _section = [];
//   // List _chapter = [];
//   // List _topic = [];
//   List<Subject> _subjects=[];
//   String course = "",
//       subject = "",
//       unit = "",
//       chapter = "",
//       topic = "",
//       subTopic = "",
//       duration;
//   var data;
//   static double _selectedIndex = 0;
//   int selectEdTopicIndex;
//   _onSelected(double index) {
//     setState(() => _selectedIndex = index);
//   }

//   ScrollController scrollController = ScrollController(
//     initialScrollOffset: _selectedIndex, // or whatever offset you wish
//     keepScrollOffset: true,
//   );

//   Future _getSubjects() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     course = sp.getString("courseSno");
//     var url =
//         baseUrl + "getSubjectsByCourse?courseSno=" + sp.getString("courseSno");
//     http.Response response = await http.get(
//       Uri.encodeFull(url),
//     );

//     _subjects = (jsonDecode(response.body) as List)
//         .map((e) => Subject.fromJson(e))
//         .toList();

//     // for (var Subject in list) {
//     //   _subjects.add(Subject);
      
//     // }
//   }

// //   Future _getUnit(int sno) async {
// //     subject = sno.toString();
// //     _section = [];
// //     _chapter = [];
// //     // var url = baseUrl + "getUnitsBySubject?subjectSno=" + subject + "";
// //     // http.Response response = await http.get(
// //     //   Uri.encodeFull(url),
// //     // );
// //     List<UnitDtos> list = (jsonDecode(response.body) as List)
// //         .map((e) => UnitDtos.fromJson(e))
// //         .toList();

// //     for (var UnitDtos in list) {
// //       print(UnitDtos.unitName);
// //       _section.add(UnitDtos);
// //     }
// // }

//   // Future _getChapters(int sno) async {
//   //   unit = sno.toString();
//   //   var url = baseUrl + "getChaptersByUnit?unitSno=" + sno.toString() + "";
//   //   http.Response response = await http.get(
//   //     Uri.encodeFull(url),
//   //   );
//   //   List<ChapterDtos> list = (jsonDecode(response.body) as List)
//   //       .map((e) => ChapterDtos.fromJson(e))
//   //       .toList();

//   //   for (var ChapterDtos in list) {
//   //     print(ChapterDtos.chapterName);
//   //     _chapter.add(ChapterDtos);
//   //   }
//   // }

//   // Future _getTopic(int sno) async {
//   //   chapter = sno.toString();
//   //   var url = baseUrl + "getTopicsByChapter?chapterSno=" + sno.toString() + "";
//   //   http.Response response = await http.get(
//   //     Uri.encodeFull(url),
//   //   );
//   //   List<TopicDtos> list = (jsonDecode(response.body) as List)
//   //       .map((e) => TopicDtos.fromJson(e))
//   //       .toList();

//   //   for (var TopicDtos in list) {
//   //     print(TopicDtos.topicName);
//   //     _topic.add(TopicDtos);
//   //   }
//   // }

//   @override
//   void initState() {
//     data = _getSubjects();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: data,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Material(
//               child: CustomScrollView(
//                 slivers: <Widget>[
//                   SliverAppBar(
//                     title: Text('Content Selection'),
//                     elevation: 3,
//                     floating: true,
//                     expandedHeight: 70,
//                     centerTitle: true,
//                   ),
//                   ontopFixed(
//                     _subjectSelect(),
//                   ),

//                   SliverPadding(
//                     padding: const EdgeInsets.all(20),
//                     sliver: _unitGrids(),
//                   ),
//                   // _subUnits()
//                   // subUnits(),
//                   // thirdRow(),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         foregroundColor: Colors.white,
//         onPressed: () => _pageNavigation(),
//         icon: const Icon(Icons.arrow_forward_ios_rounded),
//         label: const Text('Start Now'),
//       ),
//     );
//   }

//   SliverPersistentHeader ontopFixed(Widget child) {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _SliverAppBarDelegate(
//         minHeight: 90.0,
//         maxHeight: 100.0,
//         child: Card(
//           elevation: 3,
//           margin: EdgeInsets.zero,
//           child: Container(
//             margin: EdgeInsets.only(top: 25, bottom: 10),
//             child: Center(child: child),
//           ),
//         ),
//       ),
//     );
//   }

//   Color _randomColor(int i) {
//     if (i % 3 == 0) {
//       return AppColors.tileColors[3];
//     } else if (i % 3 == 1) {
//       return AppColors.tileColors[2];
//     } else if (i % 3 == 2) {
//       return AppColors.tileColors[1];
//     }
//     return AppColors.tileColors[0];
//   }

//   Widget _subjectSelect() {
//     return _subjects == null
//         ? Container(
//             child: Text('No Course Select'),
//           )
//         : Container(
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//               shrinkWrap: true,
//               primary: false,
//               scrollDirection: Axis.horizontal,
//               itemCount: _subjects.length,
//               itemBuilder: (_, i) {
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   clipBehavior: Clip.antiAlias,
//                   borderOnForeground: false,
//                   child: SizedBox(
//                     width: Responsive.getPercent(
//                         60, ResponsiveSize.WIDTH, context),
//                     child: Container(
//                       color: _randomColor(i),
//                       child: InkWell(
//                         onTap: () {
//                           _getUnit(_subjects[i].sno);
//                         },
//                         child: Material(
//                           color: Colors.transparent,
//                           child: Center(
//                             child: Text(
//                               _subjects[i].subjectName,
//                               style: TextStyle(
//                                   color: whiteColor,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//   }

//   Widget _unitGrids() {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: _section == null ? 1 : 2,
//         crossAxisSpacing: 5,
//         mainAxisSpacing: 5,
//         childAspectRatio: 2 / 2.1,
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext ctx, i) {
//           return _section == null ? Container() : _unitSelect(i);
//         },
//         childCount: _section.length,
//       ),
//     );
//   }

//   Widget _unitSelect(i) {
//     return _section == null
//         ? Container()
//         : Container(
//             child: Card(
//               margin: EdgeInsets.all(5),
//               elevation: 10,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               clipBehavior: Clip.antiAlias,
//               child: InkWell(
//                 onTap: () {
//                   _getChapters(_section[i].sno);
//                   showModalBottomSheet<void>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Container(
//                         padding: EdgeInsets.symmetric(vertical: 32),
//                         child: _chapterGrids(),
//                       );
//                     },
//                   );
//                 },
//                 child: Material(
//                   color: Colors.transparent,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: Container(
//                           child: CircleAvatar(
//                             radius: 35,
//                             backgroundColor: whiteColor,
//                             child: ImageIcon(
//                               AssetImage(AppTile.tileIcons[3]),
//                               size: 35,
//                               color: firstColor,
//                             ),
//                           ),
//                           decoration: new BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 offset: const Offset(
//                                   0.0,
//                                   5.0,
//                                 ),
//                                 blurRadius: 8.0,
//                               )
//                             ],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Expanded(
//                         flex: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: Text(
//                             _section[i].unitName,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.all(5),
//                           child: LinearPercentIndicator(
//                             padding: EdgeInsets.all(3),
//                             lineHeight: 5,
//                             percent: 0.5,
//                             backgroundColor: Colors.grey,
//                             progressColor: _randomColor(i),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }

//   Widget _chapterGrids() {
//     return SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: _chapter == null ? 1 : 1,
//         crossAxisSpacing: 5,
//         mainAxisSpacing: 5,
//         childAspectRatio: 5 / 1,
//       ),
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext ctx, i) {
//           return _chapter == null ? Container() : _chapterSelect(i);
//         },
//         childCount: _chapter == null ? 1 : _chapter.length,
//       ),
//     );
//   }

//   Widget _chapterSelect(i) {
//     return _chapter == null
//         ? Container()
//         : Container(
//             height: 300,
//             child: InkWell(
//               onTap: () {
//                 //_getTopic(_chapter[i]['sno']);
//                 _onSelected(i.toDouble());
//               },
//               child: Material(
//                 color: Colors.transparent,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Center(
//                       child: Text(
//                         _chapter[i]["chapterName"],
//                         style: TextStyle(
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }

//   Widget _topicList() {
//     return _chapter == null
//         ? Container()
//         : Container(
//             height: 300,
//             color: Colors.white,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 280,
//                   child: ListView.builder(
//                     key: ObjectKey(_selectedIndex.toString()),
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     primary: false,
//                     itemCount: _chapter.length,
//                     itemBuilder: (_, i) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 15, top: 10, right: 15),
//                         child: Column(
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 //_getTopic(_chapter[i]['sno']);
//                                 _onSelected(i.toDouble());
//                               },
//                               child: Card(
//                                 elevation: 5,
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 10),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(0)),
//                                   width: double.infinity,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "Chapter",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       SizedBox(
//                                         height: 6,
//                                       ),
//                                       Text(
//                                         _chapter[i]["chapterName"],
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             _selectedIndex != i
//                                 ? Container()
//                                 : Container(
//                                     height: 150,
//                                     width: double.infinity,
//                                     child: ListView(
//                                       shrinkWrap: true,
//                                       primary: false,
//                                       scrollDirection: Axis.horizontal,
//                                       controller: scrollController,
//                                       children: [
//                                         Padding(
//                                             padding: EdgeInsets.only(top: 10),
//                                             child: _topicSelect())
//                                       ],
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }

//   Widget _topicSelect() {
//     return _topic == null
//         ? Container()
//         : Container(
//             height: _topic.length == 0 ? 0 : 50,
// //        width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//               shrinkWrap: true,
//               primary: false,
//               scrollDirection: Axis.horizontal,
//               itemCount: _topic.length,
//               itemBuilder: (_, i) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       topic = _topic[i]['sno'].toString();
//                       subTopic = _topic[i]['subtopic'].toString();
//                       duration = _topic[i]['duration'].toString();
//                       selectEdTopicIndex = i;
//                       print(duration);
//                     });
//                   },
//                   child: ListTile(
//                     title: Text(
//                       _topic[i]["topicName"],
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800),
//                     ),
//                   ),
//                 );
//               },
//             ));
//   }

//   void _pageNavigation() {
//     print("page Key----" + topic);
//     if (course.length < 1) {
//       _toastMethod("Please Select Course");
//     } else if (subject.length < 1) {
//       _toastMethod("Please Select Subject");
//     } else if (unit.length < 1) {
//       _toastMethod("Please Select Unit");
//     } else if (chapter.length < 1) {
//       _toastMethod("Please Select Chapter");
//     } else if (topic.length < 1) {
//       _toastMethod("Please Select Topic");
//     } else {
//       print(course);
//       if (pageKey == "1") {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => StartTimer(course, subject, unit, chapter,
//                     topic, subTopic, duration)));
//       } else if (pageKey == "2") {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => SyncYourTime(
//                     course, subject, unit, chapter, topic, duration)));
//       }
//     }
//   }

//   void _toastMethod(String message) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 12.0);
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     @required this.minHeight,
//     @required this.maxHeight,
//     @required this.child,
//   });
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//   @override
//   double get minExtent => minHeight;
//   @override
//   double get maxExtent => math.max(maxHeight, minHeight);
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return new SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
