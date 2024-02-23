import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firebase_service.dart';

class SubCatList extends StatelessWidget {
  static const String id = 'subCat-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    DocumentSnapshot? args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot?;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          args?['catName'] ?? '',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args!.id).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError || snapshot.data == null) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data!.get('subCat') as List<dynamic>;
            return Container(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:8,right:8),
                    child: ListTile(
                      onTap: () {
                        // Add your onTap logic here
                      },
                      title: Text(
                        data[index].toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
