import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.msgData});

  final QueryDocumentSnapshot<Map<String, dynamic>> msgData;

  @override
  Widget build(context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    Timestamp timestamp = msgData.data()['timestamp'];

    // Convert the Timestamp to a DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime using the intl package
    String formattedDateTime = DateFormat('h:mm a, dd-MM-yy').format(dateTime);
    
    if (msgData.data()['senderId'] != currentUser.uid) {

      // received message
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              constraints: const BoxConstraints(maxWidth: 250,minWidth: 0),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFF373E4E),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                msgData.data()['message'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.3,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              )),
          Container(
            margin: const EdgeInsets.only(left: 12,right: 8,top: 3,bottom: 20),
            child: Text(formattedDateTime,textAlign: TextAlign.start,style: const TextStyle(color: Colors.white),),
          )
        ],
      );
    } else {
      // sent message
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              constraints: const BoxConstraints(maxWidth: 250,minWidth: 0),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Color(0xFF7A8194),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                msgData.data()['message'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.3,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              )),
          Container(
            margin: const EdgeInsets.only(left: 8,right: 12,top: 3,bottom: 20),
            child: Text(formattedDateTime,textAlign: TextAlign.end,style: const TextStyle(color: Colors.white),),
          )
        ],
      );
    }
  }
}
