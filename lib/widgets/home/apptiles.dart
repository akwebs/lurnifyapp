import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:lurnify/ui/screen/myCourseContain/CourseContent.dart';
import 'package:lurnify/ui/screen/myCourseContain/MyCourseContain.dart';
import 'package:lurnify/ui/screen/selfstudy/selfstudy.dart';

class AppTiles extends StatelessWidget {
  final List pageKey;
  static Color overColor = Colors.black12;
  AppTiles(this.pageKey);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
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
            elevation: 10,
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
                    builder: (context) => CourseContent(),
                  ));
                }
              },
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.tileColors[index],
                        child: Image.asset(
                          AppTile.tileIcons[index],
                          fit: BoxFit.contain,
                          height: 32,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppTile.tileText[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
