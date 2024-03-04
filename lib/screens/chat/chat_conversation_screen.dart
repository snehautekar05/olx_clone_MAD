import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatConversations extends StatefulWidget {
  final Map<String, dynamic> chatRoomData;
  final Stream<QuerySnapshot<Object?>> chatMessageStream;

  ChatConversations({
    required this.chatRoomData,
    required this.chatMessageStream,
  });

  @override
  State<ChatConversations> createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  TextEditingController _messageController = TextEditingController();

  // Update your chat message stream to include messages sent by both the sender and the receiver
  Stream<QuerySnapshot<Object?>> getChatMessageStream() {
    return FirebaseFirestore.instance
        .collection('chat_messages')
        .where('chatRoomId', isEqualTo: widget.chatRoomData['chatRoomId'])
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: getChatMessageStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true, // Reverse the list to display new messages at the bottom
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      var data = message.data() as Map<String, dynamic>;
                      var senderUid = data['senderUid'] ?? '';
                      var receiverUid = data['receiverUid'] ?? '';
                      var senderName = data['senderName'] ?? '';
                      var receiverName = data['receiverName'] ?? '';
                      var timestamp = (data['timestamp'] as Timestamp).toDate();
                      bool isSender = senderUid == FirebaseAuth.instance.currentUser!.uid;
                      return _buildMessageBubble(data['message'], senderName, receiverName, timestamp, isSender);
                    },
                  );
                },
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, String senderName, String receiverName, DateTime timestamp, bool isSender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            isSender ? 'You' : senderName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        if (!isSender && senderName != receiverName) // Display sender's name if the message is from the receiver and sender's name is different
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              senderName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              message,
              style: TextStyle(color: isSender ? Colors.white : Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${timestamp.hour}:${timestamp.minute}',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ),
      ],
    );
  }


  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
      Expanded(
      child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Add camera functionality
            },
          ),
          SizedBox(width: 8.0),
        ],
      ),
    ),
    ),
    SizedBox(width: 8.0),


    FloatingActionButton(
            onPressed: () {
              String messageText = _messageController.text.trim();
              if (messageText.isNotEmpty) {
                // Send the message using Firebase Firestore
                FirebaseFirestore.instance.collection('chat_messages').add({
                  'message': messageText,
                  'senderUid': FirebaseAuth.instance.currentUser!.uid,
                  'receiverUid': widget.chatRoomData['sellerUid'],
                  'senderName': FirebaseAuth.instance.currentUser!.displayName,
                  'receiverName': widget.chatRoomData['receiverName'],
                  'timestamp': Timestamp.now(),
                  'chatRoomId': widget.chatRoomData['chatRoomId'],
                });
                _messageController.clear();
              }
            },
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
