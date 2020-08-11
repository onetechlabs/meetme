import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  String _role_message;
  List<String> _roles = ['Broadcaster', 'Audience']; // Option 2
  String _selectedRole; // Option 2
  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet Me'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 500,
          child: Column(
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: new Container(
                          width: 100,// Not sure what to put here!
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [new Image.asset(
                              'assets/images/MeetMe.png',
                              fit: BoxFit.fill, // I thought this would fill up my Container but it doesn't
                            ),
                            ],
                          )
                      ),
                    )
                  ],
                ),
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
                children: [
                  ListTile(
                    title: Text("Masuk Sebagai Apa ?"),
                    leading: DropdownButton(
                      hint: Text('Pilih Mode'), // Not necessary for Option 1
                      value: _selectedRole,
                      onChanged: (newValue) {
                        setState(() {
                          /**
                           *
                              if(newValue=="Broadcaster"){
                              _role = ClientRole.Broadcaster;
                              }else{
                              _role = ClientRole.Audience;
                              }
                           */
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
                  )
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
