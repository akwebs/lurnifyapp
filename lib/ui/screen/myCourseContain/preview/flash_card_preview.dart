import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:photo_view/photo_view.dart';


class FlashCardImagePreview extends StatefulWidget {
  final List _classNotes;
  final int _sno;
  FlashCardImagePreview(this._classNotes,this._sno);
  @override
  _FlashCardImagePreviewState createState() => _FlashCardImagePreviewState(_classNotes,_sno);
}

class _FlashCardImagePreviewState extends State<FlashCardImagePreview> {
  final List _classNotes;
  final int _sno;
  _FlashCardImagePreviewState(this._classNotes,this._sno);
  PageController _controller;

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
        title: Text("Class Notes"),
      ),
      body: Container(
        child: PageView.builder(
          itemCount: _classNotes.length,
          controller: _controller,
          itemBuilder: (context,i){
            return Container(
                child: PhotoView(
                    imageProvider: NetworkImage(
                      imageUrl + _classNotes[i]['directory'] + "/" + _classNotes[i]['fileName'],
                    )));
          },
        ),
      ),
    );
  }
}
