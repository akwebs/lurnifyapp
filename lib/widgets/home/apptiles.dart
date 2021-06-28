import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/dareToDo/dareToDo.dart';
import 'package:lurnify/ui/screen/myCourseContain/NewCourseContent.dart';
import 'package:lurnify/ui/screen/myProgress/subject-unit.dart';
import 'package:lurnify/ui/screen/myReport/my-report.dart';
import 'package:lurnify/ui/screen/rankBooster/rankboosterHome.dart';
import 'package:lurnify/ui/screen/selfstudy/selfstudy.dart';
import 'package:lurnify/ui/screen/revisionZone/myRevision.dart';
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
            shape: RoundedRectangleBorder(
                // side: BorderSide(
                //     color: AppColors.tileIconColors[index].withOpacity(0.3),
                //     width: 1),
                borderRadius: BorderRadius.circular(5)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SelfStudySection(),
                  ));
                } else if (index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RankBoosterHome(),
                  ));
                } else if (index == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyReportHome(),
                  ));
                } else if (index == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewCourseContent(),
                  ));
                } else if (index == 4) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyProgress(),
                  ));
                } else if (index == 5) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RevisionZone(),
                  ));
                } else if (index == 6) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DareToDo(),
                  ));
                } else if (index == 7) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PurchasedItem(),
                  ));
                } else if (index == 8) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WeekMonth(),
                  ));
                }
              },
              child: Container(
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
                            child: Container(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.tileColors[index],
                                child: ImageIcon(
                                  AssetImage(AppTile.tileIcons[index]),
                                  color: AppColors.tileIconColors[index],
                                  size: 32,
                                ),
                              ),
                              decoration: new BoxDecoration(
                                // boxShadow: NewappColors.neumorpShadow,
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: AppColors.tileIconColors[index]
                                      .withOpacity(0.2),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [
                //       Colors.blue[200].withOpacity(0.1),
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