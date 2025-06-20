import 'package:chat_app/screens/loading_screens/login_loading_screen.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget{
  const LoginWidget({super.key});


  @override
  State<LoginWidget> createState(){
    return _LoginWidgetState();
  }
}


class _LoginWidgetState extends State<LoginWidget>{

  final _formkey= GlobalKey<FormState>();
  String _enteredEmail='';
  String _enteredPassword='';


  @override
  Widget build(context){
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome Back",style: TextStyle(
              color: Colors.white,
              fontSize: 35,
            ),),
            const Text("Login with your account",style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),),
            const SizedBox(height: 30,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 50,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    labelText: "Enter your email",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeData().colorScheme.primary),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    counterText: '',
                  ),
                  validator: (value){
                    if(value==null||value.trim().length<=1||value.trim().length>50||!value.trim().contains('@')){
                      return "Enter a valid email ID";
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    _enteredEmail=value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 35,),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 50,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    labelText: "Enter your Password",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeData().colorScheme.primary),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    counterText: '',
                  ),
                  validator: (value){
                    if(value==null||value.trim().length<=1||value.trim().length>50){
                      return "Enter a valid password";
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    _enteredPassword=value!;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 35,),
                ElevatedButton(
                    onPressed:() async {
                      if(_formkey.currentState!.validate()){
                        _formkey.currentState!.save();
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                          return LoginLoadingScreen(userEmail: _enteredEmail, userPassword: _enteredPassword);
                        }));
                      }
                    },
                    child: const Text("Login")
                ),
              ],
            )],
        ),
      ),
    );
  }

}