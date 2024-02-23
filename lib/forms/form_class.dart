import 'package:flutter/material.dart';
import 'package:olx_clone/provider/cat_provider.dart';

class FormClass{
  Widget appBar(CategoryProvider _provider){
    return AppBar(
      elevation: 0.0,
      shape:Border(bottom: BorderSide(color: Colors.grey.shade300),) ,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title:Text(
        _provider.selectedSubCategory,
      style: TextStyle(color: Colors.black),
      ),
    );

  }
}