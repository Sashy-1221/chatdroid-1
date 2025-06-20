import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


class NoInternetScreen extends StatefulWidget{
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() {
    return _NoInternetScreenState();
  }
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  int popCheck=0;//if popCheck=0 then page is not popped yet else page is popped once;


  @override
  Widget build(context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Oops! No Internet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox (height: 10,),
              Image.asset('assets/images/no_internet.webp'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool hasConnection = await InternetConnection().hasInternetAccess;
                    if(hasConnection){
                      if(!context.mounted) {
                        return;
                      }
                      if(popCheck==0) {
                        Navigator.of(context).pop();
                        setState(() {
                          popCheck++;
                        });
                      }
                    }},
                  child: const Text("Retry")
              )
            ]),
      ),
    );
  }
}