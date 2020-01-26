import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thoughts/authentication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'ShapesAndDesign/themeKeys.dart';

class SignUpThought extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final String userName;
  final String penName;
  SignUpThought({Key key, this.auth, this.loginCallback, this.userName, this.penName}) : super(key: key);

  @override
  _SignUpThought createState() => _SignUpThought();
  }

  enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }
  

class _SignUpThought extends State<SignUpThought>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  static var now = new DateTime.now();
  static var formater = new DateFormat("dd-MM-yyyy");
  final String date = formater.format(now);
  ProgressDialog workingPorgress;
  String _email, _password;
  //String _userId = "";
  String _errorText = '';
  String signUpThoughtText = 'Sign up with thoughts:';
  final _userEmailClick = TextEditingController();
  
  final GlobalKey<FormState> _formKeyRegister = new GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    print(widget.penName);
    workingPorgress = new ProgressDialog(context);
    workingPorgress.hide();
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
        key: _formKeyRegister,
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(signUpThoughtText),
            Text(_errorText, style: TextStyle(color: Theme.of(context).errorColor),),

            //Email Id text Field
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              validator: (input) {
                if(input.isEmpty){
                  workingPorgress.hide();
                  return 'Please enter Email';
                }else if(validateEmail(input) != null){
                  return 'Please enter Valid email';
                }
              },
              onSaved:(input) => _email = input,
              controller: _userEmailClick,
              decoration: InputDecoration(
                hintText: 'Email Id',
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                errorBorder: OutlineInputBorder(
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
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ),
            ),
            ),

            // Password text Field

            TextFormField(
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.visiblePassword,
              validator: (input) {
                if(input.length < 6){
                  workingPorgress.hide();
                  return 'Password must be more than 6 characters';
                }
              },
              onSaved:(input) => _password = input,
              decoration: InputDecoration(
                hintText: 'Create Password',
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
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
              ),
              obscureText: true,
            ),

            //Button Container
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  child: GestureDetector(
                    onTap: _signUp,
                    child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.underline),),
                  )
                ),
                /*Container(
                  margin: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => new LoginThought()));
                     },
                    child: Text(' / Back', style: TextStyle(color: Colors.white, fontSize: 18,),),
                  )
                ),*/
              ]
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Future<void> _signUp() async {
    //login to Firebase
    
    final formState = _formKeyRegister.currentState;
    if(formState.validate()){
      formState.save();
      workingPorgress.style(
      message: 'Signing up...',
      elevation: 0,
      messageTextStyle: TextStyle(fontSize: 15, color: MyThemes.appColorDark),
      );
      workingPorgress.show();
      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email, password: _password).catchError((onError){
          setState(() {
            _errorText = 'Email Id exist already';
            workingPorgress.hide();
          });
        });
        FirebaseUser user = result.user;

        if(user.uid != null){
        print(user.uid+widget.penName+_email);
        //widget.loginCallback();
        user.sendEmailVerification();
        await Firestore.instance.collection('accounts').document(user.uid.toString()).setData({'name': widget.userName,
        'penName': widget.penName, 'brand': ' ', 'emailId': _email, 'bio': ' '});
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }

      }catch(e){
        print(e.message());
        workingPorgress.show();
        _formKeyRegister.currentState.reset();
      }
    }   
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

}