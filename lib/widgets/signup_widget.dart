import 'dart:io';
import 'package:chat_app/screens/loading_screens/signingup_loading_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';




class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() {
    return _SignUpWidget();
  }
}

class _SignUpWidget extends State<SignUpWidget> {
  File? selectedImage;


  void _showDialogBox() {
    showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF333333),
              ),
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _imageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                    ),
                    label: const Text(
                      'Open camera',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: _imageFromGallery,
                    icon: const Icon(
                      Icons.photo,
                      size: 35,
                    ),
                    label: const Text(
                      'Select from gallery',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _imageFromCamera() async {
    final imagePicker = ImagePicker();
    Navigator.pop(context);
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return null;
    }

    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  void _imageFromGallery() async {
    final imagePicker = ImagePicker();
    Navigator.pop(context);
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return null;
    }

    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }


  final _formkey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredUserName = '';
  String _passwordCheck = '';

  @override
  Widget build(context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      "Create a new account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                    onTap: _showDialogBox,
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF494949),
                      ),
                      child: selectedImage == null
                          ? const Center(
                              child: Icon(
                              Icons.person_outline_outlined,
                              color: Colors.white,
                              size: 40,
                            ))
                          : Stack(
                        children: [
                          // Loading indicator widget
                          const Center(child: CircularProgressIndicator(color: Colors.grey,)),
                          // Image.network
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
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
                    labelText: "Enter your username",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ThemeData().colorScheme.primary),
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
                  validator: (value) {
                    if (value == null ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return "Enter a valid username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _enteredUserName = value!;
                  },
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 35,
                ),
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
                      borderSide:
                          BorderSide(color: ThemeData().colorScheme.primary),
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
                  validator: (value) {
                    if (value == null ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50 ||
                        !value.trim().contains('@')) {
                      return "Enter a valid email ID";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 35,
                ),
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
                      borderSide:
                          BorderSide(color: ThemeData().colorScheme.primary),
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
                  validator: (value) {
                    if (value == null ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return "Enter a valid password";
                    } else {
                      _passwordCheck = value;
                      return null;
                    }
                  },
                  keyboardType: TextInputType.name,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 50,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    labelText: "Confirm password",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ThemeData().colorScheme.primary),
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
                  validator: (value) {
                    if (value!.isEmpty || value != _passwordCheck) {
                      return "Enter the same password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                  keyboardType: TextInputType.name,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      if (selectedImage == null) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                backgroundColor: const Color(0xFF333333),
                                contentPadding: const EdgeInsets.all(20),
                                content: const Text('Add a profile picture',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),),
                                actions: [
                                  TextButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text("Okay",style: TextStyle(color: Color(
                                          0xFFA29FEA),
                                      fontSize: 18),)),
                                ],
                              );
                            });
                      }
                      else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                          return SignUpLoadingScreen(userName: _enteredUserName, userEmail: _enteredEmail, userPassword: _enteredPassword, userProfilePic: selectedImage!);
                        }));
                      }
                    }
                  },
                  child: const Text("Sign up"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
