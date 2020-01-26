import 'package:flutter/material.dart';

abstract class ThoughtStyle{
  Widget firstThoughtLayout(String _head, String _body, String _time, String _date, String _penName);

  Widget secondThoughtLayout(String _head, String _body, String _time, String _date, String _penName);
}

class ThoughtFormts implements ThoughtStyle{
  BuildContext get context => null;


    Widget firstThoughtLayout(String _head, String _body, String _time, String _date, String _penName){
    return Container(
        //Marign ContainerBasic = 20;
        margin: EdgeInsets.only(top: 20,right: 50, left: 30, bottom: 50),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Container( 
                    margin: EdgeInsets.only(bottom: 0),
                    child: Text('$_head \n',
                      style: TextStyle(fontFamily: 'Sanskar', 
                      color: Theme.of(context).accentColor, fontSize: 23,),),
                  ),
                  Expanded(
                    child: Row(
                    //Row in left containing time, penName and centerd column(the has body).
                      children: <Widget>[
                        Expanded(
                          flex: -1,
                          child: Container(
                            padding: EdgeInsets.only(right: 10, top: 10),
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )
                              )
                            ),
                            child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: -1,
                                child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(_time, 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 16)),
                                  ),
                              ),
                              Expanded(
                                flex: 1,
                                child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text('-- $_penName', 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 16),),
                                  ),
                              ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                          //Column in the middle containing BODY of the thought.
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: -1,
                                child: Text(_body,
                                  style: TextStyle(fontFamily:'SourceCode', color: Theme.of(context).accentColor, fontSize: 16),),
                              ),
                            ],
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),);
  }

  Widget secondThoughtLayout(String _head, String _body, String _time, String _date, String _penName){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 8, right: 30, bottom: 10, top: 10),
            alignment: Alignment.topLeft,
            child: Text('$_head',
              style: TextStyle(fontFamily: 'Sanskrit', 
              color: Theme.of(context).accentColor, fontSize: 20),),
          ),
          Container(
            margin: EdgeInsets.only(right: 35, bottom: 30),
            padding: EdgeInsets.only(top: 15, right: 10, left: 10,),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 2,
                  color: Colors.white
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(_time, 
                          style: TextStyle(fontFamily: 'SourceCode', fontSize: 16,)),
                ),
                Expanded(
                  flex: -1,
                  child: Text('-- $_penName', 
                          style: TextStyle(fontFamily: 'SourceCode', fontSize: 16, fontWeight: FontWeight.bold),),
                )
              ],
            ),
          ),
          
          Container(
              margin: EdgeInsets.only(left: 40, right: 20,),
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white)
              ),
              height: 290,
              child: SingleChildScrollView(
                child: Text(_body,
                      style: TextStyle(fontFamily:'Gloria', color: Theme.of(context).accentColor, fontSize: 16),),
              ),
          ),
          Expanded(
            child: ConstrainedBox(
            child: Image.asset('assets/images/zig_zag.png', color: Theme.of(context).accentColor,), 
            constraints: BoxConstraints(),
            ),
          ),
          
          
        ],
      ),
    );
  }

}