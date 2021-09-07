import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';

class TestSlider extends StatefulWidget {
  TestSlider(this.dueTopicTest);
  final List<Map<String,dynamic>> dueTopicTest;
  @override
  _TestSliderState createState() => _TestSliderState();
}

class _TestSliderState extends State<TestSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: Container(
        height: Responsive.getPercent(20, ResponsiveSize.HEIGHT, context),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                clipBehavior: Clip.antiAlias,
                width: Responsive.getPercent(85, ResponsiveSize.WIDTH, context),
                decoration: BoxDecoration(
                  gradient: AppSlider.sliderGradient[index],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AppSlider.cardimage[index],
                          fit: BoxFit.contain,
                          height: 70,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppSlider.subName[index],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: Responsive.getPercent(
                                    55, ResponsiveSize.WIDTH, context),
                                child: Text(
                                  AppSlider.testDetail[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
