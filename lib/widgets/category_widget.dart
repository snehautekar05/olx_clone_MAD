import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/categories/categories_list.dart';
import 'package:olx_clone/services/firebase_service.dart';

class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          // print(doc?['catName']);
        },
        child: Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _service.categories.orderBy('catName',descending:false).get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }
        
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
        
              return Container(
                height: 150,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Categories',style: TextStyle(fontWeight: FontWeight.bold),),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CategoryListScreen.id);
                          },
                          child: Row(
                            children: [
                              Text(
                                'See All',
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.docs.length ?? 0, // Use null-coalescing operator to handle null snapshot
                        itemBuilder: (BuildContext context, int index) {
                          var doc = snapshot.data?.docs[index];
                          if (doc == null) return Container(); // Handle null document
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width:60,
                              height: 50,
                              child: Column(
                                children: [
                                  Image.network(doc['image'] ?? ''), // Use null-coalescing operator to handle null image
                                  Flexible(
                                    child: Text(doc['catName']?? '',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize:10)),
                                  ), // Use null-coalescing operator to handle null catName
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
