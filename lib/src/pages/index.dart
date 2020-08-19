import 'dart:async';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './about_app.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  String _photourl_google;
  String _email_google;
  String _displayname_google;
  static final List<String> imgSlider = [
    'slider0.png',
    'slider1.png',
    'slider2.png',
  ];
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  final random = new Random();
  /// if channel textField is validated to have error
  bool _validateError = false;
  String _role_message;
  List<String> _roles = ['Broadcaster', 'Audience']; // Option 2
  String _selectedRole; // Option 2
  ClientRole _role = ClientRole.Broadcaster;

  getPref()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _photourl_google = preferences.getString("photourl_google");
      _displayname_google = preferences.getString("displayname_google");
      _email_google = preferences.getString("email_google");
    });

  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  final CarouselSlider autoPlayImage = CarouselSlider(
    items: imgSlider.map((fileImage) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/images/${fileImage}',
            width: 10000,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList(),
    height: 150,
    autoPlay: true,
    enlargeCenterPage: true,
    aspectRatio: 2.0,
  );

  @override
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign Out"),
      content: Text("Are you sure to sign out this app?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  void handleHeadMenuClick(String value) {
    switch (value) {
      case 'About':
        Navigator.push(context,MaterialPageRoute(builder: (context) => AboutApp()));
        break;
      case 'Sign Out':
        showAlertDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet Me'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleHeadMenuClick,
            itemBuilder: (BuildContext context) {
              return {'About', 'Sign Out'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          //decoration: new BoxDecoration(color: Colors.red),
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: double.infinity, minHeight: 190),
                decoration: new BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage("assets/images/background${random.nextInt(2)}.png"),
                      fit: BoxFit.cover,
                    ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: new Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      _photourl_google
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:5),
                                  child: Text(
                                    _displayname_google,
                                      style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:5,bottom:5),
                                  child: Text(
                                    _email_google,
                                    style: TextStyle(fontSize: 12, color: Color.fromRGBO(255, 255, 255, 1)),
                                  ),
                                )
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            autoPlayImage,
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Bersiap Memulai Percakapan?",
                                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Color.fromRGBO(23, 134, 190, 1)),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: TextField(
                                                        controller: _channelController,
                                                        decoration: InputDecoration(
                                                          errorText:
                                                          _validateError ? 'ID Saluran Wajib Diisi' : null,
                                                          border: UnderlineInputBorder(
                                                            borderSide: BorderSide(width: 1),
                                                          ),
                                                          hintText: 'ID Saluran',
                                                        ),
                                                      ))
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  DropdownButton(
                                                    isExpanded: true,
                                                    hint: Text('Pilih Mode'),
                                                    value: _selectedRole,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _selectedRole = newValue;
                                                        if(newValue=="Broadcaster"){
                                                          _role_message = "Pada Mode ini Anda dapat Berkomunikasi dengan Pengguna Lain";
                                                          _role=ClientRole.Broadcaster;
                                                        }else{
                                                          _role_message = "Pada Mode ini Anda Hanya dapat menonton dan tidak dapat berkomunikasi langsung dengan Pengguna Lain";
                                                          _role=ClientRole.Audience;
                                                        }

                                                        AlertDialog alert = AlertDialog(
                                                          title: Text("Mode "+_selectedRole),
                                                          content: Text(_role_message),
                                                        );
                                                        // show the dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return alert;
                                                          },
                                                        );
                                                      });
                                                    },
                                                    items: _roles.map((role) {
                                                      return DropdownMenuItem(
                                                        child: new Text(role),
                                                        value: role,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: RaisedButton(
                                                        onPressed: onJoin,
                                                        child: Text('Ikuti Pertemuan'),
                                                        color: Colors.blueAccent,
                                                        textColor: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if(_selectedRole==null || _selectedRole.isEmpty){
      AlertDialog alert = AlertDialog(
        title: Text("Perhatian"),
        content: Text("Anda harus memilih salah satu mode yang tersedia."),
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }else{
      if (_channelController.text.isNotEmpty) {
        // await for camera and mic permissions before pushing video page
        await _handleCameraAndMic();
        // push video page with given channel name
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              channelName: _channelController.text,
              role: _role,
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}

