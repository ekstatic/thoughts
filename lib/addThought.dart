import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thoughts/ShapesAndDesign/customTheme.dart';
import 'package:thoughts/ShapesAndDesign/themeKeys.dart';
import 'package:thoughts/authentication.dart';

class AddThoughtFormat extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback loginCallBack;
  final String head;
  final image;
  final String userId;
  AddThoughtFormat({Key key, this.auth, this.loginCallBack, this.head, this.image, this.userId}) : super(key: key);

  @override
  _AddThoughtData createState() => _AddThoughtData();

}

class _AddThoughtData extends State<AddThoughtFormat> {
  //final String penName = '';
  //final _head = TextEditingController();
  //final _body = TextEditingController();
  PageController _thoughtFormatControler = PageController();
  final greenColor = Color(0xFF43AA9E);
  final appColor = Color(0xFF232122);
  final focusColor = Color(0xFF29809B);
  final orangeColor = Color(0xFFBB7F5F);
  final pinkColor = Color(0xFFC77BA2);
  String themeColor;
  String penName = '';
  var url;
  String pageName = 'Classic Layo';
  ProgressDialog _progressDialog;
  static var now = new DateTime.now();
  static var formatter = DateFormat("dd-MM-yyyy");
  final String date = formatter.format(now);
  static var timeFormatter = DateFormat("kk : mm");
  final String time = timeFormatter.format(now);

  @override
  void initState() {
    super.initState();
    Firestore.instance.collection('accounts').document(widget.userId).get().then((db){
      setState(() {
        penName = db.data['penName'];
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context);
    return Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColorDark,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(pageName),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _uploadThought();
            },
            child: Container(
              margin: EdgeInsets.only(top: 20, right: 25,),
              child: Text('UPLOAD >', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
        ],
        //..
      ),
      body: _pageViewFormat(),
    );
  }

  Widget _pageViewFormat(){
    return PageView.builder(
      controller: _thoughtFormatControler,
      itemBuilder: (context, position){
        switch(position){
          case 0:
            return _thoughtFormat();
          case 1:
            return _thoughtsFormat2();
          case 2:
            return _thoughtFormat3();
        }
      },
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      onPageChanged: (page){
        setState(() {
          switch(page){
            case 0:
            pageName = 'Classic Layo';
            break;
            case 1:
            pageName = 'Box Reality';
            break;
            case 2:
            pageName = 'Screen';
            break;
          }
        });
      },
    );
  }
  Widget _thoughtFormat() {
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
                                    child: Text(time, 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 14)),
                                  ),
                              ),
                              Expanded(
                                flex: 1,
                                child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text('-- $penName', 
                                    style: TextStyle(fontFamily: 'SourceCode', fontSize: 14),),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.memory(Uint8List.view(widget.image.buffer),
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
        ),
    );
  }

  Widget _thoughtsFormat2(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  child: Text(time, style: TextStyle(fontFamily: 'SourceCode', 
                    fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: -1,
                  child: Text('-- $penName', style: TextStyle(fontFamily: 'SourceCode', 
                    fontSize: 14, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 30, right: 15, bottom: 20,),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 250,
              width: double.infinity,
              child: Image.memory(Uint8List.view(widget.image.buffer)),
          ),
          //_thoughtDataBottom(document),
        ],
      ),
    );
  }

  Widget _thoughtFormat3(){
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
            child: Image.memory(Uint8List.view(widget.image.buffer)),
          ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(time, 
                        style: TextStyle(fontFamily: 'SourceCode', fontSize: 14,)),
              ),
              Expanded(
                flex: -1,
                child: Text('-- $penName', 
                        style: TextStyle(fontFamily: 'SourceCode', 
                          fontSize: 14, 
                          fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ),
      ],
    );
  }
  void _uploadThought()async{
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://thoughts-fb2eb.appspot.com');
    _progressDialog.style(
      message: 'Uploading...',
      elevation: 0,
      messageTextStyle: TextStyle(fontSize: 15, color: MyThemes.appColorDark),
    );
    _progressDialog.show();
    //File _imageFile = widget.imageFile;
    var now = new DateTime.now();
    var formater = new DateFormat("dd-MM-yyyy");
    final String date = formater.format(now);

    String filePath = '$penName/$date.png';
    StorageUploadTask _uploadTask = _storage.ref().child(filePath).putData(Uint8List.view(widget.image.buffer));
    
    await _uploadTask.onComplete.whenComplete((){
      
      FirebaseStorage.instance.ref().child('$penName/$date.png').getDownloadURL().then((url){
        String urlGot = url;
        Firestore.instance.runTransaction((transaction) async {
      DocumentReference dr2 = Firestore.instance.collection('singleDayThoughts').document(widget.userId);
      DocumentSnapshot db2 = await transaction.get(dr2);
      await transaction.set(db2.reference, {'lastdateAdded':date, 'time': time});
      });
      Firestore.instance.runTransaction((transaction) async {
      DocumentReference dr = Firestore.instance.collection('singleDayThoughts/${widget.userId}/added').document(date);
        DocumentSnapshot db = await transaction.get(dr);
        await transaction.set(db.reference, {'head':widget.head, 'time': time,
        'pageName': pageName, 'penName': penName, 'url' : urlGot});
      });
      Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    });
  }

}