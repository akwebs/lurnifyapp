import 'package:flutter/material.dart';
import '../../../config/data.dart';
import '../../../helper/due_topic_test_repo.dart';
import '../../constant/constant.dart';
import 'create_your_own_test.dart';
import '../../../widgets/componants/custom_button.dart';
import '../test/instruction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RankBoosterHome extends StatefulWidget {
  const RankBoosterHome({Key key, this.sno}) : super(key: key);
  final int sno;
  @override
  _RankBoosterHomeState createState() => _RankBoosterHomeState();
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

class _RankBoosterHomeState extends State<RankBoosterHome> {
  var _data;
  List<Map<String, dynamic>> _dueTests = [];
  final ScrollController _scrollController = ScrollController();

  Future _search() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      // var url = baseUrl +"getDueTests?regSno="+sp.getString("studentSno");
      // print(url);
      // http.Response response = await http.post(
      //   Uri.encodeFull(url),
      // );
      // var responseData = jsonDecode(response.body);
      // print(responseData);
      // setState(() {
      //   _dueTests = responseData;
      // });
      DueTopicTestRepo dueTopicTestRepo = DueTopicTestRepo();
      _dueTests = await dueTopicTestRepo.getDueTopicTestByStatusAndRegister('INCOMPLETE', sp.getString("studentSno"), '0');
      double idx = 0;
      if (_dueTests.isNotEmpty) {
        for (var element in _dueTests) {
          if (element['dueTopicTestSno'] == widget.sno) {
            _scrollController.jumpTo(idx);
          } else {
            idx++;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _data = _search();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'List of due tests',
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Material(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple[200].withOpacity(0.2), Colors.lightBlue[200].withOpacity(0.1)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.deepPurple,
                              padding: const EdgeInsets.all(4.0),
                            ),
                            _dueTests.isEmpty
                                ? const Center(
                                    child: Text('There are no any Due Test(s).'),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: _dueTests.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: _cards(i, _dueTests),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
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
        },
      ),
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: 'Create Your Own Test',
        verpad: const EdgeInsets.symmetric(vertical: 5),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateYourOwnTest(),
            )),
      ),
    );
  }

  Widget _cards(int i, List dueTests) {
    int days = DateTime.now().difference(DateTime.parse(dueTests[i]['lastStudied'])).inDays;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => InstructionPage(
              dueTests[i]['course'].toString(), dueTests[i]['subject'].toString(), dueTests[i]['unit'].toString(), dueTests[i]['chapter'].toString(), dueTests[i]['topicSno'].toString()),
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(width: 1, color: dueTests[i]['dueTopicTestSno'] == widget.sno ? firstColor : Colors.transparent)),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SmoothStarRating(
                          rating: double.parse(dueTests[i]['topicImp'] ?? "0") ?? 0,
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
                          dueTests[i]['topicName'],
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.add_circle_outline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(color: _randomColor(i), border: Border(bottom: BorderSide(width: 0.5, color: firstColor))),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Info :',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${dueTests[i]['subjectName']} > ${dueTests[i]['unitName']} > ${dueTests[i]['chapterName']} ',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
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
                      dueTests[i]['subtopic'],
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(i, 'Studied', dueTests[i]['isUserStudied'] == 1 ? "Yes" : "No"),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(
                        i,
                        'Test Score',
                        dueTests[i]['lastTestScore'] == null ? '-' : dueTests[i]['lastTestScore'].toString() + "%",
                      ),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: _topicInfo(i, 'Revision', dueTests[i]['revision'].toString()),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 0.5, color: Colors.grey[500])),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(child: _topicInfo(i, 'Last Studied', days.toString() + ' days ago')),
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
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        detail,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

// ignore: unused_element
Column _chapterInfo(String heading, String detail) {
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
