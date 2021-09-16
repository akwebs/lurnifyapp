import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/selfstudy/recent.dart';
import 'package:velocity_x/velocity_x.dart';

class SecondSlider extends StatefulWidget {
  final List pagekey;
  final List<Map<String, dynamic>> recentData;
  const SecondSlider(
    this.pagekey,
    this.recentData, {
    Key key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SecondSlider> createState() => _SecondSliderState(pagekey, recentData);
}

class _SecondSliderState extends State<SecondSlider> {
  final List pagekey;
  final List<Map<String, dynamic>> recentData;

  @override
  _SecondSliderState(this.pagekey, this.recentData);

  @override
  Widget build(BuildContext context) {
    return [
      (VxTwoRow(
              left: 'Continue Studying'.text.medium.align(TextAlign.left).make().expand(),
              right: 'view all'.text.semiBold.align(TextAlign.right).make().onTap(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Recent('1'),
                ));
              }).expand()))
          .box
          .make()
          .py4()
          .px8(),
      VxSwiper.builder(
        viewportFraction: context.isMobile ? 0.55 : 0.4,
        itemCount: 6,
        aspectRatio: 7 / 3,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        itemBuilder: (context, index) {
          return VxTwoColumn(
            top: (Image.asset(randomImg(index))).box.alignCenter.color(randomColor(index)).make().expand(flex: 2),
            bottom: ('I was studying... $index'.text.make().centered()).box.alignCenter.makeCentered().expand(flex: 1),
          ).card.shape(Border.all(color: randomColor(index))).elevation(5).roundedSM.p0.make().p8().onInkTap(() {
            Navigator.of(context).pushNamedAndRemoveUntil(pagekey[index], (route) => true);
          });
        },
      )
    ].vStack().py4();
  }
}
