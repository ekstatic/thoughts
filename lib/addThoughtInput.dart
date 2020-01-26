import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thoughts/addThought.dart';
import 'package:thoughts/transactionStyle/enterExitRoute.dart';

class AddThoughtInput extends StatefulWidget{
  final offsetData;
  final image;
  final String userId;
  AddThoughtInput({this.offsetData, this.image, this.userId}) :super();

  _AddThoughtInput createState() => _AddThoughtInput();
}

class _AddThoughtInput extends State<AddThoughtInput>{
  final _thought = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, EnterExitRoute(exitPage: AddThoughtInput(), enterPage: AddThoughtFormat(
                head: _thought.text,
                image: widget.image,
                userId: widget.userId,
              )));
            },
            child: Container(
              margin: EdgeInsets.only(top: 16, right: 25,),
              child: Text('SELECT LAYOUT >', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
      body: _textInput(),
    );
  }

  Widget _textInput(){
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              padding: EdgeInsets.only(left: 10, right: 10),
        child: TextField(
        //controller: _head,
        maxLines: 6,
        maxLength: 200,
        keyboardType: TextInputType.multiline,
        controller: _thought,
      style: TextStyle(color: Theme.of(context).accentColor,),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'What\'s in your mind?',
        //errorText: _validate ? 'Value Can\'t Be Empty' : null,
        hintStyle: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
      ),
      ),
    );
  }

}