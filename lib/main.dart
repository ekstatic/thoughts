import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thoughts/account/profileView.dart';
import 'package:thoughts/authentication.dart';
import 'package:thoughts/loginThought.dart';
import 'package:thoughts/thoughtsList.dart';
import 'ShapesAndDesign/customTheme.dart';
import 'ShapesAndDesign/themeKeys.dart';

void main(){
  //BuildContext context;
  WidgetsFlutterBinding.ensureInitialized();
  getThemeColor();
  }
  void getThemeColor() async{
    final tik = await _read();
  if(tik == 'blue'){
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.BLUE,
      child: MyApp(),
    ),);
        await FlutterStatusbarcolor.setStatusBarColor(MyThemes.focusColor);
        await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.focusColor);
  }else if(tik == null){
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.DARK,
      child: MyApp(),
    ),);
    await FlutterStatusbarcolor.setStatusBarColor(MyThemes.appColor);
    await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.appColor); 
  }else if(tik == 'green'){
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.GREEN,
      child: MyApp(),
    ),);
    await FlutterStatusbarcolor.setStatusBarColor(MyThemes.greenColor);
    await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.greenColor); 
  }else if(tik == 'orange'){
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.ORANGE,
      child: MyApp(),
    ),);
    await FlutterStatusbarcolor.setStatusBarColor(MyThemes.orangeColor);
    await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.orangeColor); 
  }else if(tik == 'pink'){
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.PINK,
      child: MyApp(),
    ),);
    await FlutterStatusbarcolor.setStatusBarColor(MyThemes.pinkColor);
    await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.pinkColor); 
  }else{
    runApp(CustomTheme(
      initialThemeKey: MyThemeKeys.DARK,
      child: MyApp(),
    ),);
    await FlutterStatusbarcolor.setStatusBarColor(MyThemes.appColor);
    await FlutterStatusbarcolor.setNavigationBarColor(MyThemes.appColor); 
  }
    
  }

  _read() async {
      final prefs = await SharedPreferences.getInstance();
      final key = 'parent_theme';
      final value = prefs.getString(key) ?? 0;
      return value.toString();
    }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //print('read :${_read()}');
    return MaterialApp(
      title: 'Thoughts',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => ThoughtsListFormat(auth: Auth(),),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => LoginThought(),
        '/third' : (context) => ProfileData(),
      },
      theme: CustomTheme.of(context),
      //home: ThoughtsListFormat(auth: new Auth()),
      
      
    );
  }
}