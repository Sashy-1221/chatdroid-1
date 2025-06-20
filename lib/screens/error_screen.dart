import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget{
  const ErrorScreen({super.key,required this.errorMsg});

  final String errorMsg;
  @override
  Widget build(context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                errorMsg,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox (height: 10,),
              Image.asset('assets/images/auth_failed.webp'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("Retry")
              )
            ]),
      ),
    );
  }
}