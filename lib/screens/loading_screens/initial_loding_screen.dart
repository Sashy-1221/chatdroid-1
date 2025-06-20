import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InitialLoadingScreen extends StatelessWidget{
  const InitialLoadingScreen({super.key});

  @override
  Widget build(context){
    return const Scaffold(
      body: Center(
        child: SpinKitWave(
           color: Colors.white,
        ),
      ),
    );
  }
}