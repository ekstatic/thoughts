
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thoughts/ShapesAndDesign/customTheme.dart';
import 'package:thoughts/ShapesAndDesign/themeKeys.dart';
import 'package:thoughts/ShapesAndDesign/thoughtStyles.dart';
import 'package:thoughts/account/profileView.dart';
import 'package:thoughts/drawInput.dart';
import 'package:thoughts/loginThought.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authentication.dart';
import 'package:intl/intl.dart';

class ThoughtsListFormat extends StatefulWidget{
  static const String routName = '/';
  final BaseAuth auth;
  final VoidCallback loginCallBack;
  final ThoughtStyle thoughtsStyle;
  ThoughtsListFormat({Key key, this.auth, this.loginCallBack, this.thoughtsStyle}) : super(key: key);
  

    @override
  _ThoughtListData createState() => _ThoughtListData();

}

  enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }

class _ThoughtListData extends State<ThoughtsListFormat> with SingleTickerProviderStateMixin{
  final PageStorageBucket bucket = PageStorageBucket();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AnimationController controler;
  //String _head ='';
  //String _body ='';
  String _time = '';
  String _penName = '';
  String _pageName = '0';
  var dataBase;
  String postDocumentID;
 // AnimationController animCnt;
  Animation<Offset> offset;
  var wahVal;
  String wahValText = '';
  String _userId = '';
  var score;
  String urlImage = '';
  var isClicked = false;

  static var now = new DateTime.now();
  static var formater = new DateFormat("dd-MM-yyyy");
  final String date = formater.format(now);

  //colors  
  final greenColor = Color(0xFF43AA9E);
  final appColor = Color(0xFF232122);
  final focusColor = Color(0xFF29809B);
  final orangeColor = Color(0xFFBB7F5F);
  final pinkColor = Color(0xFFC77BA2);

  void loginCallback() {
    
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

 void _signOut(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Text('Do you really want to sign out?'),
          actions: <Widget>[
            FlatButton(
              child: Text('YES', 
              style: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.bold)),
              onPressed: () async{
                await widget.auth.signOut();
                await googleSignIn.signOut();
                authStatus = AuthStatus.NOT_LOGGED_IN;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginThought(
                  auth: widget.auth,
                  loginCallBack: logoutCallback,
                )));
              },
            ),
          ],
        );
      }
    );
  }
  
    _launchURL() async {
    const url = 'https://docs.google.com/document/d/1weoNVvc9upupwNMpVRWbfLWQ17d5sutFiPHeD3CfFHI';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _emailSupport() async {
    const url = 'mailto:ekecstatic@gmil.com?subject=My issue is ...&body=Dear sir, \n...';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  

  @override
  void initState() {
    super.initState();

    controler =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controler);
    widget.auth.getCurrentUser().then((user) {
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

  switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _scafoldLayout();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginThought(
          auth: widget.auth,
          loginCallBack: logoutCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return _scafoldLayout();
        } else
          return _scafoldLayout();
        break;
      default:
        return _scafoldLayout();
    }
    
    }

    Widget _scafoldLayout(){
      return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.close, size: 27,),
                tooltip: 'close app',
                onPressed: (){
                  exit(0);
              },)
            ),
        ],
        elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:Text(date,
          style: TextStyle(fontSize: 18,),),

      ),
      body: Stack(
        children: <Widget>[
          _thoughtListInitiate(),
          _showAnimatedViewPanel(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        //bottomAppBar Color => PrimaryDark
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
                child: Text('settings',
                    style: TextStyle(color: Colors.white, fontSize: 17),),
                onTap: () {
                    switch (controler.status) {
                  case AnimationStatus.completed:
                    controler.reverse();
                    break;
                  case AnimationStatus.dismissed:
                    controler.forward();
                    break;
                  default:
                  }
                },
              ),
              GestureDetector(
                child: Text('add thought',
                  style: TextStyle(color: Colors.white, fontSize: 17),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DrawInput(
                      userId: _userId,
                    ),
                  ));
                },
              ),
              GestureDetector(
                child: Text('profile',
                  style: TextStyle(color: Colors.white, fontSize: 17),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileData(
                  auth: widget.auth,
                  loginCallBack: loginCallback,
                  openerID: _userId,
                  originalID: _userId,
                )));
                },
              ),
            ],
          ),
          ),
        ),
    );
    }

    Widget _thoughtListInitiate(){
      return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('singleDayThoughts')
          .where('lastdateAdded', isEqualTo: date).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          return Text('Loading...');
          break;
          default:
          return PageView.builder(
              itemCount: snapshot.data.documents.length,
              
              itemBuilder: (context, index){
                
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10),
                    //color: colorsList[index],
                    child: _thoughtData(
                        snapshot.data.documents[index]),
                );
              },
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
          );
        }
      });
    }

  
  _thoughtData(DocumentSnapshot postDocument){
   //here app is showing the firestore data of user at perticular date i.e., today in appday
   // and thought this app is adding _body, _head and _time of post uploaded
   //also this app is making sure that 
    return FutureBuilder(
      future: Firestore.instance.collection('singleDayThoughts/${postDocument.documentID}/added').document(date).get(),
      builder: (context, snapshot){
        
        switch(snapshot.connectionState){

          case ConnectionState.waiting:
          return Text('Loading...');
          //_listItemLayout(postDocument);
          break;
          default:
          //_body = snapshot.data['body'];
          postDocumentID = postDocument.documentID;
          //_head = snapshot.data['head'];
          _time = snapshot.data['time'];
          _penName = snapshot.data['penName'];
          _pageName = snapshot.data['pageName'];
          urlImage = snapshot.data['url'];
          return _selectPagetoShow(_pageName);
        }
        
      },
    );
  }

  _selectPagetoShow(String pageName){
    //urlImageChanged =  FirebaseStorage.instance.ref().child().getDownloadURL().toString();
    switch (pageName){
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
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
                                      originalID: postDocumentID,
                                    )));
                                  },
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text('-- $_penName', 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 14),),
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
                        originalID: postDocumentID,
                      )));
                    },
                    child: Text('-- $_penName', 
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
                    originalID: postDocumentID,
                  )));
                },
                child: Text('-- $_penName', 
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
  Widget _showAnimatedViewPanel() {
    controler.forward();
    TextStyle textStyleForSliders = TextStyle(fontFamily: 'SourceCode',
        color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);
    return SlideTransition(
      position: offset,
      child: Visibility(
        child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.white,
        height: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Text('Help/Support\n', style: textStyleForSliders,),
              onTap: _emailSupport,
            ),
            GestureDetector(
              child: Text('Privacy and Policy\n', style: textStyleForSliders,),
              onTap: _launchURL,
            ),
            GestureDetector(
              child: Text('Sign Out\n', style: textStyleForSliders,),
              onTap: _signOut,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,          
              children: <Widget>[

                //Blue Color Box
                GestureDetector(
                  onTap: () {
                    _changeTheme(context, MyThemeKeys.BLUE);
                    _save('blue');
                    changeBarsColor(MyThemes.focusColor);
                  },
                  child:Container(
                      color: focusColor,
                      height: 40,
                      width: 40,
                    ),
                  ),
                
                //Orange Color Box
                GestureDetector(
                  onTap: (){
                    _changeTheme(context, MyThemeKeys.ORANGE);
                    _save('orange');
                    changeBarsColor(MyThemes.orangeColor);
                  },
                child: Container(
                  color: orangeColor,
                  height: 40,
                  width: 40,
                ),),

                //Green Color Box
                GestureDetector(
                  onTap: (){
                    _changeTheme(context, MyThemeKeys.GREEN);
                    _save('green');
                    changeBarsColor(MyThemes.greenColor);
                  },
                child: Container(
                  color: greenColor,
                  height: 40,
                  width: 40,
                ),),

                //Dark Color Box
                GestureDetector(
                  onTap: (){
                    _changeTheme(context, MyThemeKeys.DARK);
                    _save('dark');
                    changeBarsColor(MyThemes.appColor);
                  },
                child: Container(
                  color: appColor,
                  height: 40,
                  width: 40,
                ),),

                //Pink Color Box
                GestureDetector(
                  onTap: (){
                    _changeTheme(context, MyThemeKeys.PINK);
                    _save('pink');
                    changeBarsColor(MyThemes.pinkColor);
                  },
                child: Container(
                  color: pinkColor,
                  height: 40,
                  width: 40,
                ),),
              ],
            ),
          ],
        ),
      ),
      ),
      )
    );
  }

    void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  void changeBarsColor(Color color) async{
    await FlutterStatusbarcolor.setStatusBarColor(color);
    await FlutterStatusbarcolor.setNavigationBarColor(color);
  }

  _save(String color) async {
        final prefs = await SharedPreferences.getInstance();
        final key = 'parent_theme';
        final value = color;
        prefs.setString(key, value);
        print('saved $value');
  }
    
}
