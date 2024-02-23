import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  late DocumentSnapshot productData;

  getProductDetails(details){
    this.productData=details;
    notifyListeners();
}
}