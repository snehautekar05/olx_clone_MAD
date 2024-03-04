import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx_clone/provider/product_provider.dart';
import 'package:olx_clone/screens/account_screen.dart';
import 'package:olx_clone/screens/chat/chat_conversation_screen.dart';
import 'package:olx_clone/screens/home_screen.dart';
import 'package:olx_clone/screens/myAd_screen.dart';
import 'package:olx_clone/screens/sellitems/seller_category_list.dart';
import 'package:olx_clone/services/firebase_service.dart'; // Import FirebaseService

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ProductProvider _productProvider = ProductProvider();
  Widget _currentScreen = HomeScreen(locationData: null);
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  FirebaseService _service = FirebaseService(); // Initialize FirebaseService

  void createChatRoom(ProductProvider _provider, BuildContext context) {
    Map<String, dynamic> product = {
      'productId': _provider.productId,
      'productImage': _provider.productImage,
      'price': _provider.price,
      'title': _provider.title,
    };

    List<String> users = [
      _provider.sellerId ?? '',
      _service.user?.uid ?? '' , // Replace FirebaseService().getCurrentUserId() with _service.getCurrentUserId()
    ];

    String chatRoomId = '${_provider.sellerId}.${_service.user?.uid}.${_provider.productId}'; // Replace FirebaseService().getCurrentUserId() with _service.getCurrentUserId()

    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };

    _service.createChatRoom(_provider, context, chatRoomId);

    Stream<QuerySnapshot> chatMessageStream = FirebaseFirestore.instance
        .collection('chat_messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => ChatConversations(
      chatMessageStream: chatMessageStream,
      chatRoomData: chatData,
    ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SellerCategoryListScreen.id);
        },
        elevation: 0.0,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // evenly distribute the space
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _index = 0;
                      _currentScreen = HomeScreen(locationData: null);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_index == 0 ? Icons.home : Icons.home_outlined),
                      Text(
                        'HOME',
                        style: TextStyle(
                          color: _index == 0 ? Colors.blue : Colors.black,
                          fontWeight: _index == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    createChatRoom(_productProvider, context);
                    setState(() {
                      _index = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_index == 1 ? CupertinoIcons.chat_bubble_fill : CupertinoIcons.chat_bubble),
                      Text(
                        'CHATS',
                        style: TextStyle(
                          color: _index == 1 ? Colors.blue : Colors.black,
                          fontWeight: _index == 1 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _index = 2;
                      _currentScreen = MyAdScreen();
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_index == 2 ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
                      Text(
                        'MY ADS',
                        style: TextStyle(
                          color: _index == 2 ? Colors.blue : Colors.black,
                          fontWeight: _index == 2 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


    );
  }
}
