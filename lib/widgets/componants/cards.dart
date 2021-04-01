import 'package:lurnify/ui/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SmallCards extends StatelessWidget {
  final String subject;
  SmallCards(this.subject);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              subject,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectCards extends StatelessWidget {
  final String subject;
  final String course;
  final int percent;
  final Color cardColor;

  SubjectCards(this.subject, this.course, this.percent, this.cardColor);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.getPercent(20, ResponsiveSize.HEIGHT, context),
      child: Card(
        elevation: 1,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    course,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 2.0,
                    percent: percent / 100,
                    center: new Text(
                      percent.toString() + "%",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.5),
                    progressColor: Colors.white,
                    animation: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
