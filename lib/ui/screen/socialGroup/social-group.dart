import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

class SocialGroup extends StatefulWidget {
  const SocialGroup({Key key}) : super(key: key);

  @override
  _SocialGroupState createState() => _SocialGroupState();
}

class _SocialGroupState extends State<SocialGroup> {
  static List buttonText = [
    'Study Hours',
    'Coins Earned',
    'Test Score',
  ];
  List<bool> _isSelected = List.generate(3, (i) => false);
  String _selectedDateRange = "90 Days";
  int _selectedSubjectIndex = 0;

  @override
  Widget build(BuildContext context) {
    double shapeSize = MediaQuery.of(context).size.width * 4 / 10;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Colors.deepPurple[200].withOpacity(0.2),
          //       Colors.lightBlue[200].withOpacity(0.1)
          //     ],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                Text(
                  'Social Group',
                ),
                Text(
                  "Yesterday's Leader board",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          child: Row(
            children: [
              Container(
                color: Colors.blue.withOpacity(0.2),
                width: width * 5 / 10,
                height: height,
              ),
              Container(
                color: Colors.green.withOpacity(0.2),
                width: width * 5 / 10,
                height: height,
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                width: shapeSize,
                                height: shapeSize,
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.20),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.40),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.60),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.80),
                                          child: Container(
                                            child: CircleAvatar(
                                              foregroundColor: whiteColor,
                                              backgroundColor: firstColor,
                                              radius: 15,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '20',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Icon(
                                                    Icons.add,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 4, color: Colors.blue[400]),
                                ),
                              ),
                              Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios_rounded,
                                            size: 18,
                                            color: whiteColor,
                                          ),
                                          Text(
                                            'Follower Group',
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                width: shapeSize,
                                height: shapeSize,
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.20),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.40),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.60),
                                          child: Container(
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundImage: AssetImage(
                                                    'assets/images/anshul.png')),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.lerp(
                                              Alignment.centerLeft,
                                              Alignment.centerRight,
                                              0.80),
                                          child: Container(
                                            child: CircleAvatar(
                                              foregroundColor: whiteColor,
                                              backgroundColor: firstColor,
                                              radius: 15,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '20',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Icon(
                                                    Icons.add,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: new Border.all(
                                                color: Colors.deepPurple,
                                                width: 2.0,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 4, color: Colors.green[400]),
                                ),
                              ),
                              Container(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Leader Group',
                                            style: TextStyle(
                                                color: whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: whiteColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.blue.withOpacity(0.6))),
                              child: Column(
                                children: [
                                  Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Study Hours'),
                                              Icon(
                                                Icons
                                                    .swap_vertical_circle_sharp,
                                                color: Colors.blue,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: 10,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 5, 5, 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: i == 0
                                                  ? Border.all(
                                                      width: 1,
                                                      color: Colors.blue[400])
                                                  : Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.transparent),
                                            ),
                                            child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              margin: EdgeInsets.all(0),
                                              child: Container(
                                                color: Colors.blue
                                                    .withOpacity(0.2),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Row(
                                                      children: [
                                                        Stack(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          children: [
                                                            Container(
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/anshul.png'),
                                                              ),
                                                              decoration:
                                                                  new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    new Border
                                                                        .all(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                            ),
                                                            i == 0
                                                                ? Align(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/awesome-crown.png'),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                '#' +
                                                                    (i + 1)
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                i <= 4
                                                                    ? (8 - i)
                                                                            .toString() +
                                                                        '.00 hours'
                                                                    : (4).toString() +
                                                                        '.00 hours',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.green.withOpacity(0.6))),
                              child: Column(
                                children: [
                                  Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Study Hours'),
                                              Icon(
                                                Icons
                                                    .swap_vertical_circle_sharp,
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: 10,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 5, 5, 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: i == 0
                                                  ? Border.all(
                                                      width: 1,
                                                      color: Colors.green[400])
                                                  : Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.transparent),
                                            ),
                                            child: Card(
                                              clipBehavior: Clip.hardEdge,
                                              margin: EdgeInsets.all(0),
                                              child: Container(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '#' +
                                                                    (i + 1)
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                i <= 4
                                                                    ? (8 - i)
                                                                            .toString() +
                                                                        '.00 hours'
                                                                    : (4).toString() +
                                                                        '.00 hours',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Stack(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          children: [
                                                            Container(
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/anshul.png'),
                                                              ),
                                                              decoration:
                                                                  new BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    new Border
                                                                        .all(
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                            ),
                                                            i == 0
                                                                ? Align(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child: Image
                                                                          .asset(
                                                                              'assets/awesome-crown.png'),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
