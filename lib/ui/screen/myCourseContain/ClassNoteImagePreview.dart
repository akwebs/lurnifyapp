import 'package:flutter/material.dart';
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:photo_view/photo_view.dart';

class ClassNoteImagePreview extends StatefulWidget {
  final List _classNotes;
  final int _sno;
  ClassNoteImagePreview(this._classNotes, this._sno);
  @override
  _ClassNoteImagePreviewState createState() =>
      _ClassNoteImagePreviewState(_classNotes, _sno);
}

class _ClassNoteImagePreviewState extends State<ClassNoteImagePreview> {
  final List _classNotes;
  final int _sno;
  _ClassNoteImagePreviewState(this._classNotes, this._sno);
  PageController _controller;

  @override
  void initState() {
    _controller =
        PageController(viewportFraction: 1, keepPage: true, initialPage: _sno);
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
          itemBuilder: (context, i) {
            return Container(
                child: PhotoView(
                    imageProvider: NetworkImage(
                      imageUrl +
                  _classNotes[i]['directory'] +
                  "/" +
                  _classNotes[i]['fileName'],
            )));
          },
        ),
      ),
    );
  }
}
