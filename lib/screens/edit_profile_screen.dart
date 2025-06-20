import 'package:chat_app/widgets/signup_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'loading_screens/Edit_loading_screen.dart';

class EditProfileScreen extends StatefulWidget{
  const EditProfileScreen({super.key,required this.homeScreenGetUserData});

  final void Function() homeScreenGetUserData;

  @override
  State<EditProfileScreen> createState() {
    return  _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  File? selectedImage;
  final _formkey = GlobalKey<FormState>();
  String _enteredUserName = '';

  String _username='';
  String _userpicUrl='';
  bool _isGettingUserData=true;

  void _gettingCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    _username = await userData.data()!['username'];
    _userpicUrl = await userData.data()!['profile pic_url'];

    setState(() {
      _isGettingUserData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _gettingCurrentUserData();
  }


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

  @override
  Widget build(context){

    Widget content = const SpinKitWave(
      color: Colors.white,
    );

    if(!_isGettingUserData){
      content = Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                      onTap: _showDialogBox,
                      child: Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF494949),
                        ),
                        child: selectedImage == null
                            ? Stack(
                            children: [
                              // Loading indicator widget
                              const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  )), // Just an example, choose your preferred indicator

                              // Image.network
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.network(
                                  _userpicUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ) : Stack(
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
                      initialValue: _username,
                      maxLength: 50,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        labelText: "Edit your username",
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                              return EditLoadingScreen(userName: _enteredUserName, userProfilePic: selectedImage,homeScreenGetUserData: widget.homeScreenGetUserData,);
                            }));

                        }
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: content,
    );
  }
}