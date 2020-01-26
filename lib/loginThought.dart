import 'package:flutter/material.dart';
import 'package:thoughts/ShapesAndDesign/themeKeys.dart';
import 'package:thoughts/account/updateUserData.dart';
import 'package:thoughts/authentication.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thoughts/signUpThoughtNext.dart';
import 'package:thoughts/transactionStyle/enterExitRoute.dart';

class LoginThought extends StatefulWidget{
  static const String routName = '/second';
  final BaseAuth auth;
  final VoidCallback loginCallBack;
  LoginThought({Key key, this.auth, this.loginCallBack}) : super(key: key);

  @override
  _LoginThoughtFormat createState() => _LoginThoughtFormat();
  }

  enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  }

class _LoginThoughtFormat extends State<LoginThought>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  String _userId;
  String _errorText = '';
  ProgressDialog workingPorgress;

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

  String _email, _password;
  
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //initialize progress...
    workingPorgress = ProgressDialog(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100),
        child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(right: 30, left: 30),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text('Thoughts\n',style: TextStyle(fontSize: 20, color: Colors.white),),
            Text('Sign in to continue:',style: TextStyle(fontFamily: 'SourceCode' ,color: Colors.white),),
            
            //Email Id text Field
            
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextFormField(
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
              decoration: InputDecoration(
                labelText: 'Email Id',
                labelStyle: TextStyle(color: Colors.white),
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

            // Password text Field

            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                validator: (input) {
                  if(input.length < 6){
                    workingPorgress.hide();
                    return 'Password must be more than 6 characters';
                  }
                },
              onSaved:(input) => _password = input,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                  ),
                ),
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
              ),
              obscureText: true,
            ),
            ),
            //Button Container
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: signIn,
                    child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.underline),),
                  ),
                  GestureDetector(
                    onTap: creatAccount,
                    child: Text(' / Create Account', style: TextStyle(color: Colors.white, fontSize: 18,),),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new UpdateUserData(
                  catcherType: 'forgotPass',
                  catcher: _email,
                  appBarName: 'Send link',
                )));
              },
              child: Text('\nForgot password?', style: TextStyle(color: Colors.white,),),
            ),
            Text(_errorText, style: TextStyle(color: Theme.of(context).errorColor),),
          ],
        ),
        ),
      ),
      ),
    );
  }

  creatAccount(){
    Navigator.push(context, EnterExitRoute(exitPage: LoginThought(), enterPage: SignUpThoughtNext()));
  }

  Future<void> signIn() async {
    //login to Firebase
    final formState = _formKey.currentState;
    if(formState.validate()){
      //show Progress..
    workingPorgress.style(
    message: 'Logging in...',
    elevation: 0,
    messageTextStyle: TextStyle(fontSize: 15, color: MyThemes.appColorDark),
    );
    workingPorgress.show();
      formState.save();
      try{
        _userId = await widget.auth.signIn(_email, _password).catchError((onError){
          workingPorgress.hide();
          setState(() {
            _errorText = 'Invalid email Id or password';
          });
          print('error in auth Ashish');
        });
        
      if (_userId.length > 0 && _userId != null) {
        widget.loginCallBack();
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
        
      }catch(e){
        print(e);
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