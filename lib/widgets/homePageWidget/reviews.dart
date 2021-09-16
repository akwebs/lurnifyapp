import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/constant.dart';

class Reviews extends StatelessWidget {
  final Color clr;
  const Reviews({Key key, this.clr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            color: clr,
          ),
          child: AspectRatio(
            aspectRatio: 3 / 1.6,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: firstColor.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'This is an awesome app it helps me to get AIR-15',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    'Aeny',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage(
                                          'assets/images/anshul.png'),
                                    ),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        color: whiteColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-1, -1),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: clr,
                    child: Opacity(
                      opacity: 0.5,
                      child: ImageIcon(
                        AssetImage('assets/icons/399.png'),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(1, 1),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: clr,
                    child: Opacity(
                      opacity: 0.5,
                      child: ImageIcon(
                        AssetImage('assets/icons/400.png'),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
