import 'dart:async';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:olx_clone/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id='product-details-screen';
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading=true;

  @override
  void initState(){
    Timer(Duration(seconds: 2),(){
      setState(() {
            _loading=false;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider=Provider.of<ProductProvider>(context);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              icon:Icon(Icons.share_outlined,
                color: Colors.black,),
            onPressed:(){},
          ),
          LikeButton(
            circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
              );
            },

          ),

        ],
      ),
      body: SafeArea(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.grey.shade300,
                  //if loading
                  child: _loading?Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                      children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        SizedBox(height: 10,),
                        Text('Loading your Ads'),
                      ],
                  ),
                  ):
                  //if loading false
                  // Image.network(_productProvider.productData);
                Text('')
                ),
            Container(),
          ],
        )
      ),
    );
  }
}
