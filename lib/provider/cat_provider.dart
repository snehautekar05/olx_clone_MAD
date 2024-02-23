import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/services/firebase_service.dart';


class CategoryProvider with ChangeNotifier{
  FirebaseService _service=FirebaseService();

  DocumentSnapshot ?doc;
  late String selectedCategory='';
  late String selectedSubCategory= '';
  late String selectedBrand= '';

  DocumentSnapshot? userDetails;
  List<String> urlList = [];
 Map<String,dynamic> dataToFirestore={};

 //this is the data we are going to upload to firestore

  List<String> brands = []; // List to hold fetched brands

  getCategory(selectedCat) {
    print('Selected category: $selectedCat');
    this.selectedCategory = selectedCat;
    notifyListeners();
  }

  getBrands(selectedBrand) {
    print('Selected category: $selectedBrand');
    this.selectedBrand = selectedBrand;
    notifyListeners();
  }



  getSubCategory(selectedsubCat){
    this.selectedSubCategory=selectedsubCat;
    notifyListeners();
  }
  getCatSnapshot(snapshot){
    this.doc=snapshot;
    notifyListeners();
  }

  getImages(List<String> urls) {
    urlList.addAll(urls); // Append the new URLs to the existing list
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore=data;
    notifyListeners();
  }

   getUserDetails(){
    _service.getUserData().then((value){
     this.userDetails=value;
     notifyListeners();

    });
   }

   clearData(){
    this.urlList=[];
    dataToFirestore={};
    notifyListeners();

   }
}