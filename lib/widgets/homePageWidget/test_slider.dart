import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/rankBooster/rank_booster_view.dart';
import 'package:lurnify/ui/screen/test/instruction_page.dart';
import 'package:velocity_x/velocity_x.dart';

class TestSlider extends StatefulWidget {
  const TestSlider(this.dueTopicTest, {Key key}) : super(key: key);
  final List<Map<String, dynamic>> dueTopicTest;
  @override
  _TestSliderState createState() => _TestSliderState();
}

class _TestSliderState extends State<TestSlider> {
  @override
  Widget build(BuildContext context) {
    return [
      (VxTwoRow(
              left: 'Due Tests'.text.medium.align(TextAlign.left).make().expand(),
              right: 'view all'.text.semiBold.align(TextAlign.right).make().onTap(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RankBoosterHome(),
                ));
              }).expand()))
          .box
          .make()
          .py4()
          .px8(),
      VxSwiper.builder(
        viewportFraction: context.isMobile ? 1.0 : 0.4,
        itemCount: widget.dueTopicTest.length,
        aspectRatio: 5 / 2,
        enableInfiniteScroll: widget.dueTopicTest.length >= 2 ? true : false,
        autoPlay: true,
        pauseAutoPlayOnTouch: const Duration(seconds: 3),
        autoPlayInterval: const Duration(seconds: 6),
        itemBuilder: (context, index) {
          return (ZStack([
            VxTwoRow(
              left: (Image.asset(randomImg(index))).box.alignCenter.make().expand(flex: 1),
              right: VxTwoColumn(
                top: '${widget.dueTopicTest[index]['topicName']}'.text.xl.white.semiBold.make().box.alignTopLeft.makeCentered(),
                bottom: '${widget.dueTopicTest[index]['subjectName']}, ${widget.dueTopicTest[index]['chapterName']}'.text.white.make().box.alignTopLeft.makeCentered(),
              ).p16().expand(flex: 3),
            ),
            const Icon(Icons.arrow_forward).box.p12.alignBottomRight.make(),
          ]))
              .box
              .withGradient(randomGradient(index))
              .make()
              .onInkTap(() {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => InstructionPage(
                //       widget.dueTopicTest[index]['course'].toString(), dueTests[i]['subject'].toString(), dueTests[i]['unit'].toString(), dueTests[i]['chapter'].toString(), dueTests[i]['topicSno'].toString()),
                // ));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RankBoosterHome(
                    sno: widget.dueTopicTest[index]['dueTopicTestSno'],
                  ),
                ));
              })
              .card
              .elevation(5)
              .roundedSM
              .make()
              .py8()
              .px4();
        },
      ),
    ].vStack().py4().card.make().py4();
  }
}
