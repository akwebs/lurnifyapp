import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/constant/constant.dart';
import 'package:lurnify/ui/screen/myCourseContain/NewCourseContent.dart';
import 'package:lurnify/ui/screen/selfstudy/selfstudy.dart';

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
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
