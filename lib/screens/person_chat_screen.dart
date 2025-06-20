import 'package:chat_app/widgets/person_chat_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PersonChatScreen extends StatefulWidget{
  const PersonChatScreen({super.key,required this.receiverData});

  final QueryDocumentSnapshot<Map<String,dynamic>> receiverData;



  @override
  State<PersonChatScreen> createState(){
    return _PersonChatScreenState();
  }
}

class _PersonChatScreenState extends State<PersonChatScreen>{

  final _msgController = TextEditingController();


  Future<void> _sendMsg() async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    String enteredMsg = _msgController.text;
    _msgController.clear();


    Map<String, dynamic> msgData= {
        'senderId': currentUser.uid,
        'senderEmail': currentUser.email,
        'receiverId': widget.receiverData.id,
        'message': enteredMsg,
        'timestamp': Timestamp.now(),
      };


    List<String> ids = [currentUser.uid, widget.receiverData.id];
    ids.sort(); // sort the ids (this ensure the chat room id is always the same for any pair of 2 users)
    String chatRoomId = ids.join("_");

    await FirebaseFirestore.instance.collection('chat-room').doc(chatRoomId).collection('message').add(msgData);
  }



  @override
  void dispose(){
    super.dispose();
    _msgController.dispose();
  }


  @override
  Widget build(context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 2,
          toolbarHeight: 80,
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 25),
                width: 50,
                height: 50,
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
                        widget.receiverData.data()['profile pic_url'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Text(widget.receiverData.data()['username']),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: PersonChatWidget(receiverData: widget.receiverData)),
            Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      child: Expanded(
                        child: TextFormField(
                          controller: _msgController,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          enableSuggestions: true,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2A2A2A),
                            labelText: "Enter The message",
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ThemeData().colorScheme.primary),
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),),
                  const SizedBox(width: 5,),
                  IconButton(onPressed: () async {
                    if(_msgController.text.isEmpty){
                      return;
                    }
                    await _sendMsg();
                  },icon: const Icon(Icons.send_rounded,color: Color(0xFFB7BADD),size: 40,)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}