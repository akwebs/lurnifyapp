import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lurnify/ui/constant/ApiConstant.dart';
import 'package:lurnify/ui/screen/myCourseContain/ClassNoteImagePreview.dart';

class ClassNotes extends StatefulWidget {
  final sno,topicName,subtopic;
  ClassNotes(this.sno,this.topicName,this.subtopic);
  @override
  _ClassNotesState createState() => _ClassNotesState(sno,topicName,subtopic);
}

class _ClassNotesState extends State<ClassNotes> {
  final sno,topicName,subtopic;
  _ClassNotesState(this.sno,this.topicName,this.subtopic);

  List _classNotes;
  Future _getClassNotesByTopic()async{
    var url=baseUrl+"getClassNotesByTopic?topicSno="+sno.toString();
    http.Response response = await http.get(
      Uri.encodeFull(url),
    );
    var resbody = jsonDecode(response.body);
    print(resbody);
    _classNotes=resbody;
  }

  @override
  void initState() {
    _classNotes=[];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Class Notes"),
      ),
      body: FutureBuilder(
        future: _getClassNotesByTopic(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _topicHeadingRow(),
                    SizedBox(height: 10,),
                    _dataHeading()
                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }

  Widget _topicHeadingRow(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
            ),
            child: Center(
              child: Text(topicName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Spacer(),
              Text("Subtopic: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
              Text(subtopic,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
              Spacer(),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 10,),
                    Text("Class Note",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _dataHeading(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.builder(
        itemCount: _classNotes.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context,i){
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClassNoteImagePreview(_classNotes,i),));
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(width: 10,),
                    Expanded(child: Text(_classNotes[i]['classNote'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),)),
                    Icon(Icons.insert_drive_file),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
