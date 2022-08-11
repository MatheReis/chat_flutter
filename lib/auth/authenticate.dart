import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null ? HomeScreen() : LoginScreen();
  }
}
