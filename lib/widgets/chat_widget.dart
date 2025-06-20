import 'package:chat_app/screens/person_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget{
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState(){
    return _ChatWidgetState();
  }
}

class _ChatWidgetState extends State<ChatWidget>{

  @override
  Widget build(context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (ctx,usersnapshots){

        if(!usersnapshots.hasData||usersnapshots.data!.docs.isEmpty){
          return const Center(
            child: Text(''),
          );
        }



        final availableUsers = usersnapshots.data!.docs;
        final currentUser=FirebaseAuth.instance.currentUser!;
        final otherUsers = availableUsers.where((item) => item.id != currentUser.uid).toList();

        return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 150,
                ),
                children: [
                  for(var i in otherUsers)
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                          return PersonChatScreen(receiverData: i,);
                        }));
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(width: 3,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white),
                                top: BorderSide(width: 3,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white),
                                left: BorderSide(width: 3,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white),
                                right: BorderSide(width: 3,style: BorderStyle.solid,strokeAlign: BorderSide.strokeAlignOutside,color: Colors.white),
                              ),
                              borderRadius: BorderRadius.circular(35),
                              color: const Color(0xFF494949),
                            ),
                            child: Stack(
                              children: [
                                // Loading indicator widget
                                const Center(child: CircularProgressIndicator(color: Colors.grey,)), // Just an example, choose your preferred indicator

                                // Image.network
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.network(
                                    i.data()['profile pic_url'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Container(
                            height: 30, // Adjust the height as needed
                            child: Text(
                              i.data()['username'],
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ]
            );
      },
    );
  }
}