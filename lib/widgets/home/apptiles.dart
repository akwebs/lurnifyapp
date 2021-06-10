import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/dareToDo/dareToDo.dart';
import 'package:lurnify/ui/screen/marketPlace/marketPlace.dart';
import 'package:lurnify/ui/screen/myCourseContain/NewCourseContent.dart';
import 'package:lurnify/ui/screen/selfstudy/selfstudy.dart';
import 'package:lurnify/ui/screen/myProgress/CourseProress.dart';
import 'package:lurnify/ui/screen/revisionZone/RevisionZoneHome.dart';
import 'package:lurnify/ui/screen/marketPlace/week-month.dart';

import '../../ui/screen/marketPlace/purchased-item.dart';

class AppTiles extends StatelessWidget {
  final List pageKey;
  static Color overColor = Colors.black12;
  AppTiles(this.pageKey);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 2.3,
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: AppTile.tileIcons.length,
        itemBuilder: (BuildContext ctx, index) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.tileIconColors[index].withOpacity(0.3),
                    width: 1),
                borderRadius: BorderRadius.circular(5)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SelfStudySection(),
                  ));
                } else if (index == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewCourseContent(),
                  ));
                } else if (index == 4) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CourseProgress(),
                  ));
                } else if (index == 5) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RevisionZone(),
                  ));
                } else if (index == 6) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DareToDo(),
                  ));
                } else if(index==7){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PurchasedItem(),
                  ));
                }else if (index == 8) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WeekMonth(),
                  ));
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.tileColors[index],
                            child: ImageIcon(
                              AssetImage(AppTile.tileIcons[index]),
                              color: AppColors.tileIconColors[index],
                              size: 32,
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              AppTile.tileText[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
