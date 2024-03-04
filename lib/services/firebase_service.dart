import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:olx_clone/provider/product_provider.dart';
import 'package:olx_clone/screens/chat/chat_conversation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_clone/screens/main_screen.dart';

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
  FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
  FirebaseFirestore.instance.collection('chat_messages');

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> updateUser(Map<String, dynamic> data, context) {
    return users
        .doc(user?.uid)
        .update(data)
        .then((value) {
      Navigator.pushNamed(context, MainScreen.id);
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  Future<String> getAddress(double lat, double long) async {
    final coordinates = Coordinates(lat, long);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine ?? "Address not found";
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user?.uid).get();
    return doc;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessageStream(
      String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chat_messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String messageText, String chatRoomId) {
    return FirebaseFirestore.instance.collection('chat_messages').add({
      'message': messageText,
      'senderUid': FirebaseAuth.instance.currentUser!.uid,
      'receiverUid': chatRoomId.split('.').first,
      'timestamp': Timestamp.now(),
      'chatRoomId': chatRoomId,
    });
  }

  void createChatRoom(
      ProductProvider _provider, BuildContext context, String chatRoomId) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> chatRoomData = {
      'sellerId': _provider.sellerId,
    };

    Stream<QuerySnapshot<Map<String, dynamic>>> chatMessageStream =
    getChatMessageStream(chatRoomId);

    FirebaseFirestore.instance.collection('chat_messages').doc(chatRoomId).set(chatRoomData).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatConversations(
            chatRoomData: chatRoomData,
            chatMessageStream: chatMessageStream,
          ),
        ),
      );
    }).catchError((error) {
      // Handle error
    });
  }
}
