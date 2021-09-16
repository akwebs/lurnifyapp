import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/rankBooster/rank_booster_view.dart';
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
        itemCount: 4,
        aspectRatio: 5 / 2,
        autoPlay: true,
        pauseAutoPlayOnTouch: const Duration(seconds: 3),
        autoPlayInterval: const Duration(seconds: 6),
        itemBuilder: (context, index) {
          return (ZStack([
            VxTwoRow(
              left: (Image.asset(randomImg(index))).box.alignCenter.make().expand(flex: 1),
              right: VxTwoColumn(
                top: 'Subject Name'.text.xl.white.semiBold.make().box.alignTopLeft.makeCentered(),
                bottom: '''You have 40 minutes to answer all 50 questions. '''.text.white.make().box.alignTopLeft.makeCentered(),
              ).p16().expand(flex: 3),
            ),
            const Icon(Icons.arrow_forward).box.p12.alignBottomRight.make(),
          ]))
              .box
              .withGradient(AppSlider.sliderGradient[index])
              .make()
              .onInkTap(() {
                print(index);
              })
              .card
              .elevation(5)
              .roundedSM
              .make()
              .py8()
              .px4();
        },
      ),
    ].vStack().py4();
  }
}
