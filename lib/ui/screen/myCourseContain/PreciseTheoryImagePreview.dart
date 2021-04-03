import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:photo_view/photo_view.dart';


class PreciseTheoryImagePreview extends StatefulWidget {
  final List _preciseTheory;
  final int _sno;
  PreciseTheoryImagePreview(this._preciseTheory,this._sno);
  @override
  _PreciseTheoryImagePreviewState createState() => _PreciseTheoryImagePreviewState(_preciseTheory,_sno);
}

class _PreciseTheoryImagePreviewState extends State<PreciseTheoryImagePreview> {
  final List _preciseTheory;
  final int _sno;
  PageController _controller;
  _PreciseTheoryImagePreviewState(this._preciseTheory,this._sno);


  @override
  void initState() {
    _controller =
        PageController(viewportFraction: 1, keepPage: true,initialPage: _sno);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Precise Theory"),
      ),
      body: Container(
        child: PageView.builder(
          itemCount: _preciseTheory.length,
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,i){
            return Container(
                child: PhotoView(
                    imageProvider: NetworkImage(
                      imageUrl + _preciseTheory[i]['directory'] + "/" + _preciseTheory[i]['fileName'],
                    )));
          },
        ),
      ),
    );
  }
}
