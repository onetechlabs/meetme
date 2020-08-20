import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class GoogleSignInBaseConfig {
  static GoogleSignIn GoogleSignInVar = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  static GoogleSignInAccount _currentUser;
}