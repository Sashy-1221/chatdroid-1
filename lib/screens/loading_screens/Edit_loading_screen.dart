import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../error_screen.dart';





class EditLoadingScreen extends StatefulWidget{
  const EditLoadingScreen({super.key,required this.userName,required this.userProfilePic,required this.homeScreenGetUserData});

  final String userName;
  final File? userProfilePic;

  final void Function() homeScreenGetUserData;

  @override
  State<EditLoadingScreen> createState() {
    return _EditLoadingScreenState();
  }
}

class _EditLoadingScreenState extends State<EditLoadingScreen> {


  void _Editing() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      //for changing username
      await FirebaseFirestore.instance.collection('users').doc(user.uid)
          .update({
        'username':widget.userName,
      });


      if(widget.userProfilePic!=null) {
        final storageRef= FirebaseStorage.instance.ref().child("user_images").child('${user.uid}.jpg');
        await storageRef.putFile(widget.userProfilePic!);
        final imageUrl=await storageRef.getDownloadURL();

        //for changing profile picture
        await FirebaseFirestore.instance.collection('users').doc(user.uid)
            .update({
          'profile pic_url':imageUrl,
        });
      }

      widget.homeScreenGetUserData();
      await Future.delayed(const Duration(seconds: 3));



      if(!context.mounted){
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
    _Editing();
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