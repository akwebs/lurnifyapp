import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/config/size.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    double fontSize(double size) {
      return size * width / 414;
    }

    return Container(
      height: Responsive.getPercent(22, ResponsiveSize.HEIGHT, context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            width: width / 1.3,
            margin: EdgeInsets.symmetric(
                horizontal:
                    Responsive.getPercent(1, ResponsiveSize.WIDTH, context),
                vertical:
                    Responsive.getPercent(1, ResponsiveSize.HEIGHT, context)),
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                // side: BorderSide(
                //     color: AppColors.tileIconColors[index].withOpacity(0.4),
                //     width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text(
                                  'Notifications',
                                ),
                              ),
                              body: const Center(
                                child: Text(
                                  'This is the Notification Page',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            );
                          },
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.getPercent(
                                2, ResponsiveSize.WIDTH, context),
                            vertical: Responsive.getPercent(
                                1, ResponsiveSize.HEIGHT, context)),
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: width / 3.5,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: AppSlider.gradient[index],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppSlider.number[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize(60)),
                                      ),
                                      Spacer(),
                                      Text(
                                        AppSlider.text[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: LinearPercentIndicator(
                                          padding: EdgeInsets.all(3),
                                          width: width / 4.5,
                                          lineHeight: 5,
                                          percent: 0.5,
                                          backgroundColor: Colors.grey,
                                          progressColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: width / 2.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          AppSlider.name[index],
                                          style: TextStyle(
                                              fontSize: fontSize(26),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        AppTile.tileText[index],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [
                //       Colors.purple[100].withOpacity(0.1),
                //       Colors.deepPurple[100].withOpacity(0.1)
                //     ],
                //     begin: Alignment.topRight,
                //     end: Alignment.bottomLeft,
                //   ),
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
