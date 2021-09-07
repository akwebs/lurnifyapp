import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/constant/routes.dart';
import 'package:lurnify/ui/screen/myProgress/subject-unit.dart';
import 'package:lurnify/ui/screen/socialGroup/social-group.dart';
import 'package:lurnify/ui/screen/userProfile/update-profile.dart';
import 'package:lurnify/widgets/componants/componants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/cupertino.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "Aman Sharma",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'Joined June 2021',
                    style: TextStyle(color: firstColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 4 / 2,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: _ProgressBar(
                        progressValue: 40,
                        task: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/anshul.png'),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/award.png')),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SocialGroup(),
                  ));
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: MediaQuery.of(context).size.width * 4 / 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _group(
                        alignment: 0.0,
                      ),
                      _group(
                        alignment: 0.15,
                      ),
                      _group(
                        alignment: 0.30,
                      ),
                      _group(
                        alignment: 0.45,
                      ),
                      Align(
                          alignment: Alignment.lerp(Alignment.centerLeft,
                              Alignment.centerRight, 0.60),
                          child: Container(
                            child: CircleAvatar(
                              foregroundColor: whiteColor,
                              backgroundColor: firstColor,
                              radius: 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '20',
                                    style: TextStyle(fontSize: 12),
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
                      Align(
                        alignment: Alignment.lerp(
                            Alignment.centerLeft, Alignment.centerRight, 1.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: new Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    height: 10,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Progress Summary',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProgress(),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '8',
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Unit Completed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '21',
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Chapter Completed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '42',
                                  style: TextStyle(
                                      color: Colors.deepPurple[300],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Topic Completed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '2 Days',
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Streak',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 10 / 100,
                                // center: Icon(
                                //   Icons.check,
                                //   size: 12,
                                // ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 20 / 100,
                                // center: Icon(
                                //   Icons.check,
                                //   size: 12,
                                // ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 30 / 100,
                                // center: Icon(
                                //   Icons.check,
                                //   size: 12,
                                // ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 40 / 100,
                                // center: Icon(
                                //   Icons.check,
                                //   size: 12,
                                // ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 50 / 100,
                                // center: Icon(
                                //   Icons.check,
                                //   size: 12,
                                // ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 100 / 100,
                                center: Icon(
                                  Icons.check,
                                  size: 12,
                                ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 30,
                                lineWidth: 3.0,
                                animation: true,
                                percent: 100 / 100,
                                center: Icon(
                                  Icons.check,
                                  size: 12,
                                ),
                                backgroundColor:
                                    Color.fromARGB(30, 128, 112, 254),
                                circularStrokeCap: CircularStrokeCap.round,
                                linearGradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple
                                  ],
                                  stops: <double>[0.25, 0.75],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (builder) {
                            return UserProfileEdit();
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Edit Profile'),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomButton(
        buttonText: 'Update Study Pace',
        brdRds: 0,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(select_pace);
        },
      ),
    );
  }
}

class _group extends StatelessWidget {
  final double alignment;
  const _group({Key key, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.lerp(
          Alignment.centerLeft, Alignment.centerRight, alignment),
      child: Container(
        child: CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('assets/images/anshul.png')),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.deepPurple,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(
      {Key key, @required this.progressValue, @required this.task})
      : super(key: key);

  final double progressValue;
  final Widget task;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  task,
                ],
              ))
        ],
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        axisLineStyle: AxisLineStyle(
          thickness: 0.1,
          cornerStyle: CornerStyle.bothCurve,
          color: Color.fromARGB(30, 128, 112, 254),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue.isNaN ? 0 : progressValue,
              width: 0.1,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
              gradient: const SweepGradient(
                  colors: <Color>[Colors.lightGreen, Colors.green],
                  stops: <double>[0.25, 0.75])),
          MarkerPointer(
            markerHeight: 9,
            markerWidth: 9,
            value: progressValue.isNaN ? 0 : progressValue,
            markerType: MarkerType.circle,
            color: Colors.green,
          )
        ],
      )
    ]);
  }
}
