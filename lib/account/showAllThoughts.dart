import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoughts/account/profileView.dart';
import 'package:thoughts/authentication.dart';

class ShowAllThoughts extends StatefulWidget{
  final BaseAuth auth;
  final String userPenName;
  final String userIdCall;
  ShowAllThoughts({Key key, this.auth, this.userPenName, this.userIdCall}) : super(key : key);
  
   @override
  _ShowAllThoughts createState() => _ShowAllThoughts();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }

class _ShowAllThoughts extends State<ShowAllThoughts> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  PageController _thoughtsDiaryState = PageController();
  //String _head = '';
  //String _body = '';
  String _time = '';
  String _date = 'My Thoughts';
  String _userId = '';
  String _pageName = '0';
  String urlImage = '';
  var url;
  
  //Date Format Call for current date.
  static var now = new DateTime.now();
  static var formater = new DateFormat("dd-MM-yyyy");
  final String date = formater.format(now);

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        
        elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:Text(_date,
          style: TextStyle(fontSize: 18),),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('singleDayThoughts/${widget.userIdCall}/added').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            return _startPageLayout(snapshot.data.documents);
        },
      ),
    );
  }

  _startPageLayout(List<DocumentSnapshot> snapshot){
    
    return PageView.builder(
          //controller: _thoughtsDiaryState,
          
          itemCount: snapshot.length,
          itemBuilder: (context, index){
            return Container(
              alignment: Alignment.center,
                //color: colorsList[index],
                child: _selectPagetoShow(snapshot[index]),
            );
          },
          onPageChanged: (pageLength){
            setState(() {
              _date = snapshot[pageLength].documentID.toString();
            });
            print(_date);
          },
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
      );
  }
  _selectPagetoShow(DocumentSnapshot snapshot){
    _time = snapshot.data['time'].toString();
    _date = snapshot.documentID.toString();
    _pageName = snapshot.data['pageName'];
    if(snapshot.data['url'] == null){
      urlImage = '';
    }else{
      urlImage = snapshot.data['url'];
    }
    switch (_pageName){
      case 'Classic Layo':
      return _firstThoughtLayout();
      case 'Box Reality':
      return _secondThoughtLayout();
      case 'Screen':
      return _thirdThoughtLayout();
      default:
      return _firstThoughtLayout();
    }
  }

    Widget _firstThoughtLayout(){
    return Container(
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
                                    style: TextStyle(fontFamily: 'SourceCode', 
                                    fontSize: 14)),
                                  ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => ProfileData(
                                      auth: widget.auth,
                                      openerID: _userId,
                                      originalID: _userId,
                                    )));
                                  },
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text('-- ${widget.userPenName}', 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 14,
                                    fontWeight: FontWeight.bold,),),
                                  ),),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.network(urlImage, color: Theme.of(context).accentColor),
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
      ),
    );
  }

  Widget _secondThoughtLayout(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text('$_head', style: TextStyle(color: Theme.of(context).accentColor, fontFamily: 'Yatra',), maxLines: 6),
          Container(
            margin: EdgeInsets.only(right: 30, bottom: 30, top: 15),
            padding: EdgeInsets.only(top: 15, right: 10, left: 10),
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
                          style: TextStyle(fontFamily: 'SourceCode', fontSize: 14,)),
                ),
                Expanded(
                  flex: -1,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileData(
                        auth: widget.auth,
                        openerID: _userId,
                        originalID: _userId,
                      )));
                    },
                    child: Text('-- ${widget.userPenName}', 
                          style: TextStyle(fontFamily: 'SourceCode', fontSize: 14, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 30, right: 15, bottom: 20,),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              height: 250,
              width: double.infinity,
              child: Image.network(urlImage, color: Theme.of(context).accentColor),
          ),
          //_thoughtDataBottom(document),
        ],
      ),
    );
  }

  Widget _thirdThoughtLayout(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20, bottom: 15),
            height: MediaQuery.of(context).size.height,
            width: 270,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2, 
                color: Colors.white),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Image.network(urlImage, color: Theme.of(context).accentColor),
          ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(_time, 
                        style: TextStyle(fontFamily: 'SourceCode', fontSize: 14,)),
              ),
              Expanded(
              flex: -1,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileData(
                    auth: widget.auth,
                    openerID: _userId,
                    originalID: _userId,
                  )));
                },
                child: Text('-- ${widget.userPenName}', 
                      style: TextStyle(fontFamily: 'SourceCode', 
                      fontSize: 14, fontWeight: FontWeight.bold),),
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}