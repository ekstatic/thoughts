import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thoughts/authentication.dart';

class GoogleSignName extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final String userName;
  final String penName;
  GoogleSignName({Key key, this.auth, this.loginCallback, this.userName, this.penName}) : super(key: key);

  @override
  _GoogleSignName createState() => _GoogleSignName();
  }

  enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }
  

class _GoogleSignName extends State<GoogleSignName>{
  static var now = new DateTime.now();
  static var formater = new DateFormat("dd-MM-yyyy");
  final String date = formater.format(now);
  String _userId ='';
  String _penName ='';
  String _submitText = '';
  ProgressDialog workingPorgress;
  String penNameSearchResult= 'reject';
  String penNameErrorText;
  final _userClickCatch = TextEditingController();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  QuerySnapshot result;
  var _validate = true;

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        print(_userId);
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    workingPorgress = new ProgressDialog(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only( right: 10),
              child: IconButton(
                icon: Icon(Icons.close, size: 27,),
                tooltip: 'close app',
                onPressed: (){
                  exit(0);
              },)
            ),
        ],
        elevation: 0,
        shape: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Colors.white,
          ),
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:Text(date,
          style: TextStyle(fontSize: 18, color: Theme.of(context).accentColor),),

      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('\nCreate your pen name:\n'),
          TextFormField(
              style: TextStyle(color: Colors.white),
              validator: (input){
                if(input.isEmpty){
                  workingPorgress.hide();
                  return 'We need your secret pen Name';
                }
              },
              
              controller: _userClickCatch,
              onSaved: (input) => _penName = input,
              onChanged: (_userClickCatch)async{
                result = await Firestore.instance.collection('accounts').where('penName', isEqualTo: _userClickCatch).limit(1).getDocuments();
                final List<DocumentSnapshot> documents = result.documents;
                setState(() {
                  if(_userClickCatch.length <= 3){
                    penNameSearchResult = 'reject';
                    penNameErrorText = 'Pen name too short.';
                    _validate = true;
                    _submitText ='';
                  }else if(documents.length > 0){
                    penNameSearchResult = 'reject';
                    penNameErrorText = 'Pen name already taken.';
                    _validate = true; 
                    _submitText ='';
                  }else if(_userClickCatch != _userClickCatch.toLowerCase()){
                    penNameSearchResult = 'reject';
                    penNameErrorText = 'Invalid Pen Name.';
                    _validate = true;
                    _submitText ='';
                  }else{
                    penNameSearchResult = 'accept';
                    _validate = false;
                    _submitText = 'Submit';
                  }
                 });
              },
              decoration: InputDecoration(
                errorText: _validate ? penNameErrorText: null,
                hintText: 'Pen Name',
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          GestureDetector(onTap: (){
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(_submitText, style: TextStyle(decoration: TextDecoration.underline, fontSize: 17),),
          ),),
        ],
      ),
    )
    );
  }
}
