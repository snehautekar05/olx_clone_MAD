import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/forms/seller_car_form.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:olx_clone/screens/categories/subCat_list.dart';
import 'package:olx_clone/screens/sellitems/seller_subCat_list.dart';
import 'package:olx_clone/services/firebase_service.dart';
import 'package:provider/provider.dart';

class SellerCategoryListScreen extends StatelessWidget {
  static const String id='seller-category-list-screen';
  @override
  Widget build(BuildContext context) {

    FirebaseService _service=FirebaseService();
    var _catProvider=Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Choose Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Container(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0, // Use null-coalescing operator to handle null snapshot
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data?.docs[index];
                  if (doc == null) return Container(); // Handle null document
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        if(doc['subCat'] == null || (doc['subCat'] as List).isEmpty){
                        _catProvider.getCategory(doc['catName']);
                        _catProvider.getCatSnapshot(doc);
                           Navigator.pushNamed(context,SellerCarForm.id);
                        }
                        Navigator.pushNamed(context, SellerSubCatList.id,arguments:doc, );
                      },
                      leading: Image.network(doc['image'], width: 40,),
                      title: Text(
                        doc['catName'],
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing:doc['subCat']==null? null:Icon(Icons.arrow_forward_ios, size: 12,),
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
