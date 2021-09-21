import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/dareToDo/dare_to_do.dart';
import 'package:lurnify/ui/screen/rankBooster/rank_booster_view.dart';
import 'package:lurnify/ui/screen/selfstudy/recent.dart';
import 'package:lurnify/ui/screen/userProfile/user_profile.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class FirstSlider extends StatefulWidget {
  final double selfStudyPercent;
  final double testPercent;
  const FirstSlider(
    this.selfStudyPercent,
    this.testPercent, {
    Key key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<FirstSlider> createState() => _FirstSliderState(selfStudyPercent, testPercent);
}

class _FirstSliderState extends State<FirstSlider> {
  double selfStudyPercent;
  double testPercent;

  @override
  _FirstSliderState(this.selfStudyPercent, this.testPercent);

  @override
  Widget build(BuildContext context) {
    return VxSwiper.builder(
      itemCount: 4,
      aspectRatio: 16 / 7,
      enlargeCenterPage: true,
      viewportFraction: context.isMobile ? 0.9 : 0.45,
      autoPlay: true,
      enableInfiniteScroll: false,
      itemBuilder: (context, index) {
        return VxTwoRow(
          left: (VxTwoColumn(
                  top: VxTwoRow(left: '0'.text.medium.white.xl6.makeCentered(), right: (index + 1).text.medium.white.xl6.makeCentered()).p8().expand(flex: 4),
                  bottom: (VxTwoColumn(
                    top: (selfStudyPercent == 1.0)
                        ? 'Complete'.text.white.make()
                        : (selfStudyPercent == 0.0)
                            ? 'Start'.text.white.make()
                            : 'Progress'.text.white.make(),
                    bottom: LinearPercentIndicator(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      percent: (index == 0)
                          ? selfStudyPercent > 1
                              ? selfStudyPercent = 1
                              : selfStudyPercent
                          : (index == 1)
                              ? testPercent > 1
                                  ? testPercent = 1
                                  : testPercent
                              : 0.5,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.white,
                    ),
                  ).p8())))
              .box
              .roundedSM
              .withGradient(AppSlider.gradient[index])
              .make()
              .p8()
              .expand(flex: 5),
          right: VxTwoColumn(
            top: ('Self Study'.text.xl2.make()).box.alignBottomLeft.make().expand(),
            bottom: ('You are studying...'.text.make()).box.alignTopLeft.make().expand(),
          ).p8().expand(flex: 6),
        ).card.elevation(5).roundedSM.make().p4().onInkTap(() {
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Recent('1'),
            ));
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RankBoosterHome(),
            ));
          } else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DareToDo(),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const UserProfile(),
            ));
          }
        });
      },
    );
  }
}
