import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/selfstudy/select_pace.dart';
import 'package:lurnify/widgets/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'recent.dart';

class SelfStudySection extends StatefulWidget {
  const SelfStudySection({Key key}) : super(key: key);

  @override
  _SelfStudySectionState createState() => _SelfStudySectionState();
}

class _SelfStudySectionState extends State<SelfStudySection> {
  String _courseCompletetioDate = "";
  String _daysBehind = "12";
  String _minAdd = "20";
  String _percent = "20";

  Future _getCourseDate() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _courseCompletetioDate = sp.getString("courseCompletionDate");
    _courseCompletetioDate ??= "Not Selected";
  }

  MaterialBanner materialBanner(BuildContext context) {
    return MaterialBanner(content: const Text('Your Course Info'), actions: [
      TextButton(onPressed: () {}, child: "Edit".text.make()),
      TextButton(onPressed: () {}, child: "Ok".text.make()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Study Section"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // _pace(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Recent("2"),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getCourseDate(),
        builder: (BuildContext context, AsyncSnapshot s) {
          if (s.connectionState == ConnectionState.done) {
            return Material(
              child: [
                10.heightBox,
                pace(context).p8().card.elevation(5).px12.make(),
                10.heightBox,
                _motivationCards(context),

                // CustomButton(
                //   brdRds: 10,
                //   icon: Icons.add,
                //   verpad: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                //   onPressed: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => Recent("1"),
                //     ));
                //   },
                // ),
                10.heightBox
              ].vStack(),
            );
          } else {
            return Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset(
                  'assets/lottie/56446-walk.json',
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomButton(
        brdRds: 0,
        buttonText: 'Start Study',
        verpad: const EdgeInsets.symmetric(vertical: 5),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Recent("1"),
          ));
        },
      ),
    );
  }

  Widget _motivationCards(context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/quotes.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pace(context) {
    return [
      "Course Completion on: $_courseCompletetioDate".text.lg.center.semiBold.make(),
      10.heightBox,
      [
        "$_daysBehind days Behind".text.lineHeight(2).make(),
        "Add $_minAdd mins Daily To Complete Timely".text.lineHeight(2).make(),
        "$_percent % Syllabus completed".text.lineHeight(2).make(),
      ].vStack(),
      "Edit Complettion Date"
          .text
          .white
          .center
          .make()
          .py8()
          .card
          .color(Colors.deepPurple)
          .elevation(10)
          .make()
          .onTap(() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SelectThePace(true),
            ));
          })
          .wFull(context)
          .py4(),
    ].vStack().wFull(context);
  }
}
