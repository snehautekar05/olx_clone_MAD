import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/services/firebase_service.dart';
import 'package:olx_clone/services/search_service.dart';


class CustomAppBar extends StatefulWidget {
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseService _service = FirebaseService();
  SearchService _search =SearchService();
  static List<Products> products = [];

  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot){
     snapshot.docs.forEach((doc) {
      setState(() {
       products.add(
        Products(title:doc['title'],
            description:doc['description'] ,
            category: doc['category'],
            subCat: doc['subCat'],
            price: doc['price'],
            document: doc)
       );
      });
     });
    });
    super.initState();
  }

  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user?.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address not selected");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          if (data != null && data['address'] == null) {
            GeoPoint latLong = data['location'];
            _service.getAddress(latLong.latitude, latLong.longitude);
            return appBar('Fetching location', context);
          } else {
            return appBar(data['address'], context);
          }
        }
        return appBar('Fetching location', context);
      },
    );
  }

  Widget appBar(address, context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: (){
          Navigator.pushNamed(context,LocationScreen.id);
        },

        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(CupertinoIcons.location_solid, color: Colors.black, size: 18,),
                Flexible(
                  child: Text(
                    address,
                    style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.arrow_downward_outlined, color: Colors.black, size: 18,),
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: InkWell(
          onTap: (){

          },
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12,0,12,8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onTap: (){
                          _search.search(context:context,productList:products);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey,),
                          labelText: 'Find Cars, Mobiles and many more',
                          labelStyle: TextStyle(fontSize: 12),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.notifications_none),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async{
            await FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}

