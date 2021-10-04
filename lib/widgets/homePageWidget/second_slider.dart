import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/selfstudy/recent.dart';
import 'package:lurnify/ui/screen/selfstudy/start_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  State<SecondSlider> createState() => _SecondSliderState();
}

class _SecondSliderState extends State<SecondSlider> {
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
        enableInfiniteScroll: widget.recentData.length <= 2 ? false : true,
        viewportFraction: context.isMobile ? 0.55 : 0.4,
        itemCount: widget.recentData.length,
        aspectRatio: 7 / 3,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        itemBuilder: (context, index) {
          return VxTwoColumn(
            top: Image.asset(randomImg(index)).box.alignCenter.color(randomColor(index)).make().expand(flex: 2),
            bottom: [
              '${widget.recentData[index]['subjectName'] ?? ''} > ${widget.recentData[index]['unitName'] ?? ''} > ${widget.recentData[index]['chapterName'] ?? ''}'
                  .text
                  .sm
                  .center
                  .maxLines(1)
                  .ellipsis
                  .make(),
              5.heightBox,
              '${widget.recentData[index]['studyType'] ?? ''} ${widget.recentData[index]['topicName'] ?? ''}'.text.medium.center.letterSpacing(-0.2).make(),
            ].vStack(axisSize: MainAxisSize.max).box.make().expand(flex: 1),
          )
              .onInkTap(() async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                String course = sp.getString("courseSno");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StartTimer(
                            course,
                            widget.recentData[index]['subjectSno'].toString(),
                            widget.recentData[index]['unitSno'].toString(),
                            widget.recentData[index]['chapterSno'].toString(),
                            widget.recentData[index]['topicSno'].toString(),
                            widget.recentData[index]['subtopic'].toString(),
                            widget.recentData[index]['duration'].toString())));
                print(widget.recentData);
              })
              .card
              .shape(Border.all(width: 1, color: randomColor(index)))
              .elevation(5)
              .roundedSM
              .p0
              .make()
              .p8();
        },
      )
    ].vStack().py4().card.make();
  }
}
