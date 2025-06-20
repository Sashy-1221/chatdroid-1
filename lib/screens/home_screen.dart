import 'dart:async';
import 'package:chat_app/screens/contribute_screen.dart';
import 'package:chat_app/screens/edit_profile_screen.dart';
import 'package:chat_app/screens/user_searching_screen.dart';
import 'package:chat_app/widgets/chat_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'no_internet_screen.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String _userpicUrl = '';
  String _username = '';
  bool _isGettingUserData = true;

  final connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? streamSubscription;

  Future<void> initConnectivity() async {
    streamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return const NoInternetScreen();
        }));
      }
    });
  }

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
    initConnectivity();
  }

  @override
  void dispose() {
    streamSubscription?.cancel(); // Cancel subscription if it exists
    super.dispose();
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notify"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx){
                        return const UserSearchScreen();
                      }
                  );
                },
                icon: const Icon(Icons.search))
          ],
        ),
        drawer: Drawer(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: const Border(
                            bottom: BorderSide(
                                width: 3,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Colors.white),
                            top: BorderSide(
                                width: 3,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Colors.white),
                            left: BorderSide(
                                width: 3,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Colors.white),
                            right: BorderSide(
                                width: 3,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Colors.white),
                          ),
                          borderRadius: BorderRadius.circular(35),
                          color: const Color(0xFF494949),
                        ),
                        child: Stack(
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          _username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                      return  EditProfileScreen(homeScreenGetUserData: _gettingCurrentUserData,);
                    }));
                  },
                  label: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.attach_money_sharp,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const ContributeScreen();
                    }));
                  },
                  label: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Contribute",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(
                    Icons.logout,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _firebase.signOut();
                  },
                  label: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isGettingUserData
            ? const Center(
                child: SpinKitWave(
                  color: Colors.white,
                ),
              )
            : Container(
                height: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(20.0), child: ChatWidget())),
      ),
    );
  }
}
