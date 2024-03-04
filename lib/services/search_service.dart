import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/product_list.dart';
import 'package:olx_clone/widgets/product_card.dart';
import 'package:search_page/search_page.dart';

class Products {
  final String title, description, category, subCat, price;
  final DocumentSnapshot document;

  Products(
      {required this.title,
        required this.description,
        required this.category,
        required this.subCat,
        required this.price,
        required this.document});
}

class SearchService {
  search({context, productList}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
        onQueryUpdate: (s) => print(s),
        items: productList,
        searchLabel: 'Search products',
        suggestion: ProductList(), // Remove any arguments here
        builder: (product) => ListTile(
          title: Text(product.title),
        ), filter: (product)=>[
          product.title,
        product.description,
        product.category,
      ],
      ),
    );
  }
}
