import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/screens/error_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _firebase=FirebaseAuth.instance;


class LoginLoadingScreen extends StatefulWidget{
  const LoginLoadingScreen({super.key,required this.userEmail,required this.userPassword});

  final String userEmail;
  final String userPassword;

  @override
  State<LoginLoadingScreen> createState(){
    return _LoginLoadingScreenState();
  }
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen>{

  void _loggingIn() async {
    try {

      final userCredentials = await _firebase.signInWithEmailAndPassword(email: widget.userEmail, password: widget.userPassword);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();

    } on FirebaseAuthException catch (error) {
      String _errorMsg = error.message ?? "Authentication Failed!";
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return ErrorScreen(errorMsg: _errorMsg);
      }));

    }
  }

  @override
  void initState(){
    super.initState();
    _loggingIn();
  }

  @override
  Widget build(context){
    return const Scaffold(
      body: SpinKitWave(
        color: Colors.white,
      ),
    );
  }
}

