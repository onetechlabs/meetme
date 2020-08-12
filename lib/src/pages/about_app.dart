import 'dart:async';
import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutAppState();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class AboutAppState extends State<AboutApp> {
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: new Container(
                          width: 100,// Not sure what to put here!
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                      left: 0,
                                      top: 20,
                                      right: 0,
                                      bottom: 20,
                                    ),
                                  child: Text(
                                    'Meet Me',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: HexColor.fromHex('#A4A7A5')),
                                  ),
                                )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: new Container(
                          width: 300,// Not sure what to put here!
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  top: 20,
                                  right: 0,
                                  bottom: 20,
                                ),
                                child: Text(
                                  'video communications, with an easy, reliable cloud platform for video and audio conferencing',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: HexColor.fromHex('#A4A7A5')),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: new Container(
                          width: 300,// Not sure what to put here!
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  top: 20,
                                  right: 0,
                                  bottom: 20,
                                ),
                                child: Text(
                                  'Copyright \u00a9 2020 Onetechlabs\nAll right reserved.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: HexColor.fromHex('#A4A7A5')),
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
