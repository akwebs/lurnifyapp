import 'package:flutter/material.dart';
import 'package:lurnify/config/data.dart';
import 'package:velocity_x/velocity_x.dart';

class AppTiles extends StatelessWidget {
  final List pageKey;
  static Color overColor = Colors.black12;
  const AppTiles(this.pageKey, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2 / 2.3,
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppTile.tileIcons.length,
      itemBuilder: (BuildContext ctx, index) {
        return VxCard(
          VxTwoColumn(
            top: (CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.tileColors[index],
              child: ImageIcon(AssetImage(AppTile.tileIcons[index]), color: AppColors.tileIconColors[index], size: 32),
            ).box.roundedFull.border(color: AppColors.tileIconColors[index].withOpacity(0.2), width: 1).makeCentered())
                .expand(flex: 2),
            bottom: (Text(
              AppTile.tileText[index],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: Vx.dp14),
            ).box.alignTopCenter.make())
                .expand(),
          ),
        ).elevation(5).make().onInkTap(() {
          Navigator.of(context).pushNamedAndRemoveUntil(pageKey[index], (route) => true);
        });
      },
    );
  }
}
