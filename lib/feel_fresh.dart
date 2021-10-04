import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class FeelFresh extends StatefulWidget {
  const FeelFresh({Key key}) : super(key: key);

  @override
  _FeelFreshState createState() => _FeelFreshState();
}

class _FeelFreshState extends State<FeelFresh> {
  List<String> quatesList = [
    "A bad attitude is like a flat tire, you won’t get nowhere til you change it.",
    "Act as if what you do makes a difference. It does.",
    "After a storm comes a calm.",
    "Always desire to learn something useful.",
    "Always do your best. What you plant now, you will harvest later.",
    "Anxiety’s like a rocking chair. It gives you something to do, but it doesn’t get you very far.",
    "Be gentle to all and stern with yourself.",
    "Be kind whenever possible. It is always possible."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: ZStack(
        [
          VxBox().bgImage(const DecorationImage(image: AssetImage('assets/bg-2.jpg'))).make().whFull(context),
          VxSwiper.builder(
            aspectRatio: 6 / 8,
            itemCount: 5,
            enlargeCenterPage: true,
            itemBuilder: (context, index) {
              return VxCard(
                VxTwoColumn(
                  top: Image.asset("assets/images/onboarding/img2.png").box.alignCenter.makeCentered().p12(),
                  bottom: VStack([Text(quatesList[index]).text.center.makeCentered()]).p12(),
                ),
              ).roundedSM.color(Vx.purple200).elevation(10).make().p16();
            },
          ).centered(),
        ],
      ),
    );
  }
}


// Activity Inputs 