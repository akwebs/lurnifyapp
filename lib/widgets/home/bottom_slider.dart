import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';

class BottomSlider extends StatelessWidget {
  final List pagekey;
  BottomSlider(this.pagekey);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.getPercent(22, ResponsiveSize.HEIGHT, context),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: AppSlider.cardtext.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              padding: EdgeInsets.only(left: 5),
              width: Responsive.getPercent(45, ResponsiveSize.WIDTH, context),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: AppColors.cardHeader[index], width: 1),
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        pagekey[index], (route) => true);
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: AppColors.cardHeader[index],
                            child: Center(
                                child: Image.asset(AppSlider.cardimage[index])),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              AppSlider.cardtext[index],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
