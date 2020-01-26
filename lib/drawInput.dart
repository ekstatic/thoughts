import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoughts/drawingCanvas.dart';
import 'package:thoughts/transactionStyle/enterExitRoute.dart';

import 'addThought.dart';

class DrawInput extends StatefulWidget{
  final String userId;
  DrawInput({this.userId}): super();

  _DrawInput createState() => _DrawInput();

}

class _DrawInput extends State<DrawInput>{
  final _offsetPoints = <Offset>[];
  ByteData pngImg;
  double sliderValue = 3.0;

  _convertCanvas() async {
    var recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    DrawingCanvas redrawnCanvas = DrawingCanvas(_offsetPoints, Theme.of(context).accentColor, sliderValue);
    var size = MediaQuery.of(context).size;
    redrawnCanvas.paint(canvas, size);

    var image = recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    var pngImgFormed;
    await image.then((img){
      setState(() {
        pngImgFormed = img.toByteData(format: ImageByteFormat.png);
      });
    });
    return pngImgFormed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        elevation: 0,
        //title: Text('Draw it out!',),
      ),
      body: _drawInput(),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).primaryColorDark,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 2,
                color: Colors.white,
                style: BorderStyle.solid
              )
            )
          ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          GestureDetector(
          child: Container(
            child: Text('clear', style: TextStyle(color: Colors.white, fontSize: 17,),),
              ),
              onTap: (){
              setState(() {
                _offsetPoints.clear();
              });
            },
          ),
          GestureDetector(
          child: Container(
            child: Text('next >', style: TextStyle(color: Colors.white, fontSize: 17,),),
              ),
            onTap: ()async{
              pngImg = await _convertCanvas();
              //final pngBytes = await img.toByteData();
              Navigator.push(context, EnterExitRoute(exitPage: DrawInput(),
              enterPage: AddThoughtFormat(                
                head: '',
                image: pngImg,
                userId: widget.userId,
              )));
            },
          ),
          ],
        ),),
        ),
    );
  }
  Widget _drawInput(){
    return Stack(
      children: <Widget>[
        Container(
          child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _offsetPoints.add(details.localPosition);
              print(details.localPosition);
            });
          },
          onPanStart: (details) {
            setState(() {
              _offsetPoints.add(details.localPosition);
              print(details.localPosition);
            });
          },
          onPanEnd: (details) {
            setState(() {
              _offsetPoints.add(null);
            });
          },
            child: CustomPaint(
                //size: (300, 300),
                painter: DrawingCanvas(_offsetPoints, Theme.of(context).accentColor, sliderValue),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
        ),),
      ],
    );
  }
}