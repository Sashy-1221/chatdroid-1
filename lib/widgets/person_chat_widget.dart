import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonChatWidget extends StatefulWidget{
  const PersonChatWidget({super.key,required this.receiverData});

  final QueryDocumentSnapshot<Map<String,dynamic>> receiverData;

  @override
  State<PersonChatWidget> createState(){
    return _PersonChatWidgetState();
  }
}

class _PersonChatWidgetState extends State<PersonChatWidget> {

  String chatRoom='';

  void _getChatRoomId(){
    final currentUser = FirebaseAuth.instance.currentUser!;

    List<String> ids = [currentUser.uid, widget.receiverData.id];
    ids.sort(); // sort the ids (this ensure the chat room id is always the same for any pair of 2 users)
    chatRoom = ids.join("_");
  }

  @override
  void initState(){
    super.initState();
    _getChatRoomId();
  }
  
  @override
  Widget build(context){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat-room').doc(chatRoom).collection('message').orderBy('timestamp',descending: true).snapshots(),
        builder: (ctx,msgsnapshot){

          if(!msgsnapshot.hasData||msgsnapshot.data!.docs.isEmpty){
            return const Center(
              child: Text(''),
            );
          }

          final availableMsg = msgsnapshot.data!.docs;


            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: availableMsg.length,
              reverse: true,
              itemBuilder: (ctx,index){
                return ChatBubble(msgData: availableMsg[index]);
              },
            );

        }
    );
  }
}