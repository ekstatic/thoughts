

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thoughts/ShapesAndDesign/themeKeys.dart';
import 'package:thoughts/account/profileView.dart';
import 'package:thoughts/authentication.dart';

class UpdateUserData extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallBack;
  final String catcher;
  final String catcherType;
  final String appBarName;
  UpdateUserData({Key key, this.auth, this.loginCallBack, this.catcher, this.catcherType, this.appBarName}) : super(key: key);

  @override
  _UpdateUserData createState() => _UpdateUserData();

}

class _UpdateUserData extends State<UpdateUserData>{
  final _userClickCatch = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId;
  String _catcherType;
  String penNameSearchResult= 'reject';
  String penNameErrorText;
  String appBarText = 'Profile';
  String _textDone = '';
  String _greenText = '';
  String _confirmText = '';
  String _hiddenString = '';
  var _validate = true;
  QuerySnapshot result;
  ProgressDialog workingPorgress;

  @override
  void initState() {
    super.initState();
    _userClickCatch.text = widget.catcher;
    appBarText = widget.appBarName;
    _catcherType = widget.catcherType;

    FirebaseAuth.instance.currentUser().then((user){
      setState((){
        this._userId = user.uid.toString();
      });
    });

  }


  @override
  void dispose() {
    _userClickCatch.dispose();
   // myFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    workingPorgress = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text(appBarText),
        elevation: 0,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 16, right: 25,),
              child: GestureDetector(
                onTap: (){
                  _updateActionSubmit();
                },
                child: Text(_textDone, style: TextStyle(fontWeight: FontWeight.bold),),
              )
            ),
        ],
        //
      ),
      body: _updateAction()
    );
  }

  _updateActionSubmit()async{
    workingPorgress.style(
    message: 'Connecting...',
    elevation: 0,
    messageTextStyle: TextStyle(fontSize: 15, color: MyThemes.appColorDark),
    );
    workingPorgress.show();
    switch(penNameSearchResult){
      case 'accept':
      Firestore.instance.runTransaction((transaction) async {
        DocumentReference userDatabase = Firestore.instance.collection('accounts').document(_userId);
        DocumentSnapshot userDatabaseDocument = await transaction.get(userDatabase);
        await transaction.update(userDatabaseDocument.reference, {_catcherType: _userClickCatch.text});
      Navigator.pop(context, MaterialPageRoute(builder: (context) => ProfileData()));
      workingPorgress.dismiss();
      });
      break;
      case 'request':
        await resetPassword(_userClickCatch.text).catchError((error){
          setState(() {
              _hiddenString = 'Invalid';
          });
        }).whenComplete((){
          workingPorgress.dismiss();
          setState(() {
          if(_hiddenString == 'Invalid'){
            _greenText = 'Invalid emailId or not registred with thoughts';
            _confirmText = '';
            _hiddenString = '';
          }else{
            _confirmText = 'The Link for reset password has been sent to the emailId';
            _greenText = '';
            _hiddenString = '';
          }
          });
        });
        
      break;
      default:
      print('rejected');
      break;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  _updateAction(){
    if(_catcherType == 'penName'){
      return Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
        child: TextField(
          controller: _userClickCatch,
          onChanged: (_userClickCatch)async{
            result = await Firestore.instance.collection('accounts').where('penName', isEqualTo: _userClickCatch).limit(1).getDocuments();
            final List<DocumentSnapshot> documents = result.documents;
            setState(() {
              if(_userClickCatch.length <= 3){
                penNameSearchResult = 'reject';
                penNameErrorText = 'UserName too short.';
                _validate = true;
                _textDone = '';
              }else if(documents.length > 0){
                penNameSearchResult = 'reject';
                penNameErrorText = 'UserName already taken.';
                _validate = true; 
                _textDone = '';
              }else if(_userClickCatch != _userClickCatch.toLowerCase()){
                penNameSearchResult = 'reject';
                penNameErrorText = 'Invalid User Name.';
                _validate = true;
                _textDone = '';
              }else{
                penNameSearchResult = 'accept';
                _validate = false;
                _textDone = 'DONE >';
              }
            });
          },
          decoration: InputDecoration(
            errorText: _validate ? penNameErrorText: null,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.0
              ),
            ),
          ),
        ),
      );
    }else if(_catcherType == 'bio'){
      return Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
        child: TextField(
          controller: _userClickCatch,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          onChanged: (_userClickCatch){
            setState(() {
            penNameSearchResult = 'accept';
            _textDone = 'DONE >';
            });
          },
          decoration: InputDecoration(
            errorText: _validate ? penNameErrorText : null,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.0
              ),
            ),
          ),
        ),
      );
    }else if(_catcherType == 'name'){
      return Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
        child: TextField(
          controller: _userClickCatch,
          onChanged: (_userClickCatch){
            setState(() {
            penNameSearchResult = 'accept';
            _textDone = 'DONE >';
            });
          },
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.0
              ),
            ),
          ),
        ),
      );
    }else if(_catcherType == 'forgotPass'){
      return Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Column(
          children: <Widget>[
             TextField(
              controller: _userClickCatch,
              onChanged: (_userClickCatch){
                setState(() {
                penNameSearchResult = 'request';
                _textDone = 'DONE >';
                });
              },
              
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0
                  ),
                ),
                hintText: 'Your email Id',
              ),
            ),
            Text('\n$_greenText', style: TextStyle(color: MyThemes.errorColor),),
            Text('\n$_confirmText', style: TextStyle(color: Colors.white),),
          ],
        ),
      );
    }
  }

}