import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  DocumentSnapshot? _productData;
  String? _sellerId;

  DocumentSnapshot? get productData => _productData;
  String? get sellerId => _sellerId;

  String? get productId => _productData?['productId']; // Define this way if productId is a field in your productData
  String? get productImage => _productData?['productImage'];
  String? get price => _productData?['price'];
  String? get title => _productData?['title'];

  void getProductDetails(DocumentSnapshot details) {
    _productData = details;
    notifyListeners();
  }

  void setSellerId(String sellerId) {
    _sellerId = sellerId;
    notifyListeners();
  }
}
