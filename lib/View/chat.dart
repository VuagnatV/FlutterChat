import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eferei2023gr109/View/all_personn.dart';
import 'package:eferei2023gr109/View/my_background.dart';
import 'package:eferei2023gr109/View/my_check_map.dart';
import 'package:eferei2023gr109/View/my_map.dart';
import 'package:eferei2023gr109/constant.dart';
import 'package:eferei2023gr109/controller/firebase_helper.dart';
import 'package:eferei2023gr109/controller/message_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUserID;
  const Chat({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,

  });

  @override
  State<Chat> createState() => _ChatState();

}

class _ChatState extends State<Chat> {

  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _messageService.sendMessage(widget.receiverUserID, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverUserEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      )
    );
  }

  Widget _buildMessageInput() {
    return Row(

      children: [
        Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(hintText: "Entrer un message"),
              controller: _messageController,
              obscureText: false,

            ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send), iconSize: 40),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:  (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:  (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            Text(data['message']),
          ],
        ),
      )

    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(stream: _messageService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid), builder: (context, snapshot) {
      if(snapshot.hasError) {
        return Text('Error${snapshot.error}');
      }
      if(snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loadng..');
      }
      return  ListView(
        children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
      );
    }
    );
  }

}