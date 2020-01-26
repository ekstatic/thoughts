
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thoughts/ShapesAndDesign/themeKeys.dart';
import 'package:thoughts/account/showAllThoughts.dart';
import 'package:thoughts/account/updateUserData.dart';
import 'package:thoughts/authentication.dart';
import 'package:thoughts/ShapesAndDesign/customTheme.dart';

class ProfileData extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallBack;
  final String openerID;
  final String originalID;
  ProfileData({Key key, this.auth, this.loginCallBack, this.openerID, this.originalID}) : super(key: key);

  @override
  _ProfileData createState() => _ProfileData();

}



class _ProfileData extends State<ProfileData>{
  String _userId = '';
  String userName, userEmail, userBio, userPenName, userBrand;
  String penNameSearchResult= 'reject';
  String penNameErrorText;
  final greenColor = Color(0xFF43AA9E);
  final appColor = Color(0xFF232122);
  final focusColor = Color(0xFF29809B);
  final orangeColor = Color(0xFFBB7F5F);
  final pinkColor = Color(0xFFC77BA2);
  TextStyle linethrough = TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white);
  TextStyle textFieldHintStyle = TextStyle(color: Colors.white, fontFamily: 'SourceCode', fontSize: 17,);
  //FocusNode myFocusNode;
  //bool _validate = false;
  //DocumentReference userData;
  //Future userDataFuture;

  @override
  void initState(){
    super.initState();

    _userId = widget.originalID;
    
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

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        //title: Text('Profile'),
        elevation: 0,
        //
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 50),
        padding: EdgeInsets.only(left: 25),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),),
        ),
        child: _showFutureDate(),
      ),
      );
  }

  _showFutureDate(){

    return StreamBuilder(
      stream: Firestore.instance.collection('accounts').document(_userId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
          return Text('Loading...');
          case ConnectionState.done:
          return _scrollableContainer(snapshot);
          default:
          return _scrollableContainer(snapshot);
        }
      },
    );
  }

  Widget _scrollableContainer(AsyncSnapshot db){
    if(db.hasData){
      userPenName = db.data['penName'];
      userName = db.data['name'];
      userEmail = db.data['emailId'];
      userBio = db.data['bio'];
      userBrand = db.data['brand'];
    }
    print('User ID: $_userId, $userPenName');
    return SingleChildScrollView(
        child: Row(
          children: <Widget>[
            //_checkBrand(userBrand),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[            
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(top: 5),
                    child: GestureDetector(
                      onTap: (){
                        if(_userId == widget.openerID){
                          _updateUserAction(userName, 'name');
                        }
                        },
                      child: Text(userName, 
                        style: TextStyle(color: Theme.of(context).accentColor, 
                          fontFamily: 'SourceCode', fontSize: 20,),),
                    ),
                    
                  ),
                  //Text(userName, style: TextStyle(fontSize: 20, fontFamily: 'SourceCode'),),
                  Container(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: GestureDetector(
                      onTap: (){
                        if(_userId == widget.openerID){
                          _updateUserAction(userPenName, 'penName');
                        }
                        },
                      child: Text(userPenName, style: TextStyle(color: Theme.of(context).accentColor),),
                    ),
                  ),
                  Text('         Pen Name          ', 
                          style: linethrough),
                  Container(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    margin: EdgeInsets.only(top: 10, bottom: 30),
                    width: double.infinity,
                    child: Text(userEmail, 
                      style: TextStyle(color: MyThemes.appColorLght, 
                        fontWeight: FontWeight.bold),),
                  ),
                  
                  _checkBio(userBio),
                  Text('         Bio          ', 
                          style: linethrough),
                  if(_userId == widget.openerID)
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: FlatButton(
                          shape: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowAllThoughts(
                              userPenName: userPenName,
                              userIdCall: _userId
                            )));
                          },
                          child: Text('Thoughts >'.toUpperCase(), 
                              style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                  //Color Cubes for app color change...
                Container(
                  margin: EdgeInsets.all(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,          
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
            /*StreamBuilder(
              stream: Firestore.instance.collection('singleDayThoughts/$_userId/added').snapshots(),
              builder: (context, snapshot){
                return ;
              },
            ),*/
          ],
        ),
    );
  }

  Widget _checkBio(String userBioExist){
    if(userBioExist.length > 1){
      return Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child: GestureDetector(
          onTap: (){
            if(_userId == widget.openerID){
              _updateUserAction(userBio, 'bio');
            }
            },
          child: Text(userBioExist, style: TextStyle(fontFamily: 'Gloria', color: Theme.of(context).accentColor, fontSize: 16),),
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child: GestureDetector(
          onTap: (){
            if(_userId == widget.openerID){
              _updateUserAction(userBio, 'bio');
            }
            },
          child: Text('---', style: TextStyle(color: Theme.of(context).accentColor),),
        ),
      );
    }
  }

  Widget _checkBrand(String userBrandExist){
    if(userBrandExist.length > 1){
      return Expanded(
        flex: 0,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text('               $userBrand                  \n', 
                    style: TextStyle(fontFamily: 'Gloria' ,
                      decoration: TextDecoration.lineThrough, fontSize: 20, color: Colors.white)),
          ),
        );
    }else{
      return Expanded(
        flex: 0,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text('                                \n', 
                    style: TextStyle(fontFamily: 'Yatra' ,
                      decoration: TextDecoration.lineThrough, fontSize: 20, color: Colors.white,
                      fontWeight: FontWeight.bold)),
          ),
        );
    }
  }

  void _updateUserAction(String _catcherName, String _catcherType){
    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserData(
      catcher: _catcherName,
      catcherType: _catcherType,
      appBarName: 'Profile',
    )));
  }
}