import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thoughts/authentication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thoughts/loginThought.dart';
import 'package:thoughts/signUpThought.dart';
import 'package:thoughts/transactionStyle/enterExitRoute.dart';

class SignUpThoughtNext extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallback;
  SignUpThoughtNext({Key key, this.auth, this.loginCallback}) : super(key: key);

  @override
  _SignUpThoughtNext createState() => _SignUpThoughtNext();
  }

  enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }

class _SignUpThoughtNext extends State<SignUpThoughtNext>{
  static var now = new DateTime.now();
  static var formater = new DateFormat("dd-MM-yyyy");
  final String date = formater.format(now);

  final _userClickCatch = TextEditingController();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  //String _catcherType;
  ProgressDialog workingPorgress;
  String _userName, _penName;
  //String _userId;
  String penNameSearchResult= 'reject';
  String penNameErrorText;
  var _validate = true;
  QuerySnapshot result;
  
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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

      ),
      body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Sign up with thoughts:'),

            //Name textField
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
              style: TextStyle(color: Colors.white),
              validator: (input) {
                if(input.isEmpty){
                  workingPorgress.hide();
                  return 'Please provide your name';
                }
                
              },
              onSaved:(input) => _userName = input,
              decoration: InputDecoration(
                hintText: 'Your Name',
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
            ),

            //PenName text Field

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
                  }else if(documents.length > 0){
                    penNameSearchResult = 'reject';
                    penNameErrorText = 'Pen name already taken.';
                    _validate = true; 
                  }else if(_userClickCatch != _userClickCatch.toLowerCase()){
                    penNameSearchResult = 'reject';
                    penNameErrorText = 'Invalid Pen Name.';
                    _validate = true;
                  }else{
                    penNameSearchResult = 'accept';
                    _validate = false;
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
            
            //Button Container
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  child: GestureDetector(
                    onTap: () => signIn(),
                    child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.underline),),
                  )
                ),
              ]
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Future<void> signIn() async {
    //login to Firebase
    final formState = _formKey.currentState;
    if(_validate != true){
    if(formState.validate()){
        formState.save();
        //workingPorgress.show();
        try{
          Navigator.push(context,  EnterExitRoute(exitPage: SignUpThoughtNext(), enterPage: SignUpThought(
            userName: _userName,
            penName: _penName,
          )));
        }catch(e){
          print(e.message());
        }
      }
    }
  }
}