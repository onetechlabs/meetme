import 'dart:async';
import 'dart:math';
import 'dart:convert' show json;
import 'package:carousel_slider/carousel_slider.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignIn extends StatefulWidget {
  @override
  State createState() => SignInState();
}

class SignInState extends State<SignIn> {
  static final List<String> imgSlider = [
    'slider0.png',
    'slider1.png',
    'slider2.png',
  ];

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

  GoogleSignInAccount _currentUser;
  String _contactText;
  final random = new Random();
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
        ],
      );
    } else {
      return Column(
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: new Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Container(
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
                              Padding(
                                padding: EdgeInsets.only(top:5),
                                child: Text(
                                  "Meet Me - Video Conference App",
                                  style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top:5,bottom:5),
                                  child: Container(
                                      width: 250,
                                      child: Center(
                                        child: Text(
                                          "Sudah punya google akun ?\nKlik tombol dibawah untuk masuk akun .",
                                          style: TextStyle(fontSize: 12, color: Color.fromRGBO(255, 255, 255, 1)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  )
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),


          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        children: [
                          autoPlayImage,
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Text(
                              "Masuk Akun",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Color.fromRGBO(23, 134, 190, 1)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Container(
                              width:200,
                              child: GestureDetector(
                                onTap: _handleSignIn,
                                child: Image.asset('assets/images/login_google_long.png'),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),

        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Masuk Akun ke Meet Me'),
        ),
        body: SafeArea(
          child: _buildBody(),
        ));
  }
}
