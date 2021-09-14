import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myCourseContain/preview/flash_card_preview.dart';

class FlashCard extends StatefulWidget {
  final sno, topicName, subtopic;

  FlashCard(this.sno, this.topicName, this.subtopic);

  @override
  _FlashCardState createState() => _FlashCardState(sno, topicName, subtopic);
}

class _FlashCardState extends State<FlashCard> {
  final sno, topicName, subtopic;

  _FlashCardState(this.sno, this.topicName, this.subtopic);

  List _flashCards = [];

  Future _getFlashCards(String flashCardType) async {
    _flashCards = [];
    var url = baseUrl + "getFlashCardByTopic?topicSno=" + sno.toString() + "&flashCardCategory=" + flashCardType;
    print(url);
    http.Response response = await http.get(Uri.encodeFull(url));
    var responseBody = jsonDecode(response.body);
    setState(() {
      _flashCards = responseBody;
    });
    print(_flashCards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Cards"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _topicHeadingRow(),
              SizedBox(
                height: 10,
              ),
              _bigFlashCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget _topicHeadingRow() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
            child: Center(
              child: Text(
                topicName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(),
              Text(
                "Subtopic: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Text(
                subtopic,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _smallFlashCard("Formula"),
                _smallFlashCard("Concept"),
                _smallFlashCard("Question"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallFlashCard(String flashCardName) {
    return GestureDetector(
      onTap: () {
        if (flashCardName == "Formula") {
          _getFlashCards("formula");
        } else if (flashCardName == "Concept") {
          _getFlashCards("concept");
        } else if (flashCardName == "Question") {
          _getFlashCards("question");
        }
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black), color: Colors.greenAccent),
        child: Column(
          children: [
            Text(
              flashCardName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Icon(
              Icons.map,
              size: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Flash Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            )
          ],
        ),
      ),
    );
  }

  Widget _bigFlashCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 4 / 10,
      child: ListView.builder(
        itemCount: _flashCards.length,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FlashCardImagePreview(_flashCards, i),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 8 / 10,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                          child: Text(
                        _flashCards[i]['flashCardName'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      )),
                      FadeInImage(
                        image: NetworkImage(imageUrl + _flashCards[i]['directory'] + "/" + _flashCards[i]['fileName']),
                        placeholder: AssetImage("assets/placeholder.jpg"),
                        height: MediaQuery.of(context).size.height * 3.6 / 10,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
