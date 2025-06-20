import 'package:chat_app/screens/person_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() {
    return _UserSearchScreenState();
  }
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _searchController = TextEditingController();
  String? _searchName;

  @override
  Widget build(context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 600,
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                textInputAction: TextInputAction.search,
                onEditingComplete: () {
                  setState(() {
                    _searchName = _searchController.value.text.trim();
                  });
                  FocusScope.of(context).unfocus();
                },
                controller: _searchController,
                enableSuggestions: true,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  labelText: "Enter Username",
                  counterText: '',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ThemeData().colorScheme.primary),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (ctx, usersnapshots) {
                    if (!usersnapshots.hasData ||
                        usersnapshots.data!.docs.isEmpty ||
                        _searchName == '' ||
                        _searchName == null) {
                      return const Center(
                        child: Text(''),
                      );
                    }

                    final availableUsers = usersnapshots.data!.docs;
                    final currentUser = FirebaseAuth.instance.currentUser!;
                    final otherUsers = availableUsers
                        .where((item) => item.id != currentUser.uid)
                        .toList();

                    final searchedUser = otherUsers
                        .where((item) => item.data()['username'].toString().trim().toLowerCase() == _searchName.toString().trim().toLowerCase())
                        .toList();

                    return SizedBox(
                      height: 690,
                      child: ListView.builder(
                        itemCount: searchedUser.length,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                return PersonChatScreen(receiverData: searchedUser[index],);
                              }));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      border: const Border(
                                        bottom: BorderSide(
                                            width: 3,
                                            style: BorderStyle.solid,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Colors.white),
                                        top: BorderSide(
                                            width: 3,
                                            style: BorderStyle.solid,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Colors.white),
                                        left: BorderSide(
                                            width: 3,
                                            style: BorderStyle.solid,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Colors.white),
                                        right: BorderSide(
                                            width: 3,
                                            style: BorderStyle.solid,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
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
                                        )),

                                        // Image.network
                                        Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image.network(
                                            searchedUser[index]
                                                .data()['profile pic_url'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      searchedUser[index].data()['username'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ]),
          )),
        )),
      ),
    );
  }
}
