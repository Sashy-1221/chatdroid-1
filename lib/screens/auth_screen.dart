import 'package:chat_app/widgets/login_widget.dart';
import 'package:chat_app/widgets/signup_widget.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  bool login_check = true;

  @override
  Widget build(context) {
    Widget body_content;
    if (login_check) {
      body_content = const LoginWidget();
    } else {
      body_content = const SignUpWidget();
    }

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        login_check = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          login_check ? Colors.white : const Color(0xFF2A2A2A),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.zero,
                            bottomRight:
                                Radius.zero), // Adjust the radius as needed
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: login_check
                            ? Colors.black
                            : ThemeData().colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          login_check = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: login_check
                            ? const Color(0xFF2A2A2A)
                            : Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.zero,
                              bottomLeft:
                                  Radius.zero), // Adjust the radius as needed
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: login_check
                              ? ThemeData().colorScheme.primaryContainer
                              : Colors.black,
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: body_content),
          ],
        ),
      ),
    );
  }
}
