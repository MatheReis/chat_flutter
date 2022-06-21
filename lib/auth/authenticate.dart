import 'package:chat_app/Auth/auth.dart';
import 'package:chat_app/Screens/home_screen.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null ? HomeScreen() : LoginScreen();
  }
}
