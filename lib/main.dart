import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/loading_screens/initial_loding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


var kDarkColorScheme= ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF14275D),
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    darkTheme: ThemeData().copyWith(
      colorScheme: kDarkColorScheme,
      scaffoldBackgroundColor: Colors.black38,
    ),
    themeMode: ThemeMode.dark,

    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const InitialLoadingScreen();
        }


        if(snapshot.hasData){
          return const HomeScreen();
        }
        else{
          return const AuthScreen();
        }

      }
    ),
  ));
}