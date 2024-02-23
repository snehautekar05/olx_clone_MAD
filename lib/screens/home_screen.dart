// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:location/location.dart';
// import 'package:flutter_geocoder/geocoder.dart';
// import 'package:olx_clone/screens/account_screen.dart';
// import 'package:olx_clone/screens/chat_screen.dart';
// import 'package:olx_clone/screens/myAd_screen.dart';
// import 'package:olx_clone/screens/sellitems/seller_category_list.dart';
// import 'package:olx_clone/widgets/banner_widget.dart';
// import 'package:olx_clone/widgets/category_widget.dart';
// import 'package:olx_clone/widgets/custom_appBar.dart';
//
// class HomeScreen extends StatefulWidget {
//   static const String id = 'home-screen';
//   final LocationData? locationData;
//
//   HomeScreen({required this.locationData});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String address = 'India';
//
//   Future<String?> getAddress() async {
//     // From coordinates
//     final coordinates = Coordinates(widget.locationData?.latitude ?? 0.0, widget.locationData?.longitude ?? 0.0);
//     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       address = first.addressLine ?? 'Address not found';
//     });
//     return first.addressLine;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getAddress();
//   }
//
//   // int _index = 0;
//   // Widget _currentScreen = HomeScreenWidget(locationData: null,);
//
//   @override
//   Widget build(BuildContext context) {
//     Color color = Theme.of(context).primaryColor;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(),
//       ),
//       body: _currentScreen,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.purple,
//         onPressed: () {
//           //this button is to make add products for seller
//           Navigator.pushNamed(context,SellerCategoryListScreen.id);
//         },
//         elevation: 0.0,
//         child: CircleAvatar(
//           backgroundColor: Colors.white,
//           child: Icon(Icons.add),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 0,
//         child: Container(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left side of floating button
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 0;
//                         _currentScreen = HomeScreenWidget(locationData: widget.locationData);
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 0 ? Icons.home : Icons.home_outlined),
//                         Text(
//                           'HOME',
//                           style: TextStyle(
//                             color: _index == 0 ? Colors.blue : Colors.black,
//                             fontWeight: _index == 0 ? FontWeight.bold : FontWeight.normal,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 1;
//                         _currentScreen = ChatScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 1 ? CupertinoIcons.chat_bubble_fill : CupertinoIcons.chat_bubble),
//                         Text(
//                           'CHATS',
//                           style: TextStyle(
//                             color: _index == 1 ? Colors.blue : Colors.black,
//                             fontWeight: _index == 1 ? FontWeight.bold : FontWeight.normal,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Right side of floating button
//               Row(
//                 children: [
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 2;
//                         _currentScreen = MyAdScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 2 ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
//                         Text(
//                           'MY ADS',
//                           style: TextStyle(
//                             color: _index == 2 ? Colors.blue : Colors.black,
//                             fontWeight: _index == 2 ? FontWeight.bold : FontWeight.normal,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _index = 3;
//                         _currentScreen = AccountScreen();
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(_index == 3 ? CupertinoIcons.person_fill : CupertinoIcons.person),
//                         Text(
//                           'ACCOUNT',
//                           style: TextStyle(
//                             color: _index == 3 ? Colors.blue : Colors.black,
//                             fontWeight: _index == 3 ? FontWeight.bold : FontWeight.normal,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class HomeScreenWidget extends StatelessWidget {
//   final LocationData? locationData;
//
//   const HomeScreenWidget({Key? key, required this.locationData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ListView(
//       children: [
//         Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 40,
//                     child: TextField(
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search, color: Colors.grey),
//                         labelText: 'Find Cars, Mobiles and many more',
//                         labelStyle: TextStyle(fontSize: 12),
//                         contentPadding: EdgeInsets.only(left: 10, right: 10),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Icon(Icons.notifications_none),
//                 SizedBox(width: 10),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//           child: Column(
//             children: [
//               // Banner
//               BannerWidget(),
//               CategoryWidget(),
//               // categories
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:location/location.dart';
// import 'package:flutter_geocoder/geocoder.dart';
// import 'package:olx_clone/screens/account_screen.dart';
// import 'package:olx_clone/widgets/banner_widget.dart';
// import 'package:olx_clone/widgets/category_widget.dart';
// import 'package:olx_clone/widgets/custom_appBar.dart';
//
// class HomeScreen extends StatefulWidget {
//   static const String id = 'home-screen';
//   final LocationData? locationData;
//
//   HomeScreen({required this.locationData});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String address = 'India';
//
//   Future<String?> getAddress() async {
//     final coordinates = Coordinates(widget.locationData?.latitude ?? 0.0, widget.locationData?.longitude ?? 0.0);
//     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     setState(() {
//       address = first.addressLine ?? 'Address not found';
//     });
//     return first.addressLine;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getAddress();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Color color = Theme.of(context).primaryColor;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: CustomAppBar(),
//       ),
//       body: HomeScreenWidget(locationData: widget.locationData),
//     );
//   }
// }
//
// class HomeScreenWidget extends StatelessWidget {
//   final LocationData? locationData;
//
//   const HomeScreenWidget({Key? key, required this.locationData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ListView(
//       children: [
//         Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 40,
//                     child: TextField(
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search, color: Colors.grey),
//                         labelText: 'Find Cars, Mobiles and many more',
//                         labelStyle: TextStyle(fontSize: 12),
//                         contentPadding: EdgeInsets.only(left: 10, right: 10),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Icon(Icons.notifications_none),
//                 SizedBox(width: 10),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
//           child: Column(
//             children: [
//               // Banner
//               BannerWidget(),
//               CategoryWidget(),
//               // categories
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/screens/login_screen.dart';
import 'package:olx_clone/screens/product_list.dart';
import 'package:olx_clone/widgets/banner_widget.dart';
import 'package:olx_clone/widgets/category_widget.dart';
import 'package:olx_clone/widgets/custom_appBar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  final LocationData? locationData;

  HomeScreen({required this.locationData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = 'India';

  Future<String?> getAddress() async {
    // From coordinates
    final coordinates = Coordinates(widget.locationData?.latitude, widget.locationData?.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      address = first.addressLine ?? 'Address not found';
    });
    return first.addressLine;
  }

  @override
  void initState() {
    super.initState();

    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade100 ,
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(100),
          child:SafeArea(child: CustomAppBar())),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Column(
                  children: [
                    //Banner
                    BannerWidget(),
                    CategoryWidget(),
                    //categories
        
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            ProductList(),
            //product list
          ],
        ),
      ),
    );
  }
}
