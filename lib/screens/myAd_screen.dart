// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:like_button/like_button.dart';
// import 'package:olx_clone/services/firebase_service.dart';
//
// class MyAdScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     FirebaseService _service = FirebaseService();
//     final _format = NumberFormat('##,##,##0');
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0.0,
//           title: Text(
//             'My Ads',
//             style: TextStyle(color: Colors.black),
//           ),
//           bottom: TabBar(
//             indicatorColor: Theme.of(context).primaryColor,
//             unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//             labelStyle: TextStyle(fontWeight: FontWeight.bold),
//             indicatorWeight: 6,
//             tabs: [
//               Tab(
//                 child: Text(
//                   'ADS',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'FAVOURITES',
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//         Container(
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//           child: FutureBuilder<QuerySnapshot>(
//             future: _service.products.get(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Something went wrong');
//               }
//
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Padding(
//                   padding: const EdgeInsets.only(left: 140, right: 140),
//                   child: LinearProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//                     backgroundColor: Colors.grey.shade100,
//                   ),
//                 );
//               }
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 56,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'My Ads',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GridView.builder(
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                         maxCrossAxisExtent: 200,
//                         childAspectRatio: 2 / 2.5,
//                         crossAxisSpacing: 8,
//                         mainAxisSpacing: 10,
//                       ),
//                       itemCount: snapshot.data?.size,
//                       itemBuilder: (BuildContext context, int i) {
//                         var data = snapshot.data?.docs[i];
//                         var _price = int.parse(data?['price']);
//                         String _formattedPrice = '\Rs ${_format.format(_price)}';
//                         return Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Theme.of(context).primaryColor.withOpacity(.8),
//                             ),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Stack(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: 100,
//                                       child: Center(child: Image.network(data?['images'][0])),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Text(
//                                       _formattedPrice,
//                                       style: TextStyle(fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       data?['title'],
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                                 Positioned(
//                                   right: 0.0,
//                                   child: CircleAvatar(
//                                     backgroundColor:Colors.white ,
//                                     child: Center(
//                                       child: LikeButton(
//                                         circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
//                                         bubblesColor: BubblesColor(
//                                           dotPrimaryColor: Color(0xff33b5e5),
//                                           dotSecondaryColor: Color(0xff0099cc),
//                                         ),
//                                         likeBuilder: (bool isLiked) {
//                                           return Icon(
//                                             Icons.favorite,
//                                             color: isLiked ? Colors.red : Colors.grey,
//                                           );
//                                         },
//
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//               ),
//             Center(child: Text('My Favourites'),)
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:olx_clone/services/firebase_service.dart';

class MyAdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'My Ads',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorWeight: 6,
            tabs: [
              Tab(
                child: Text(
                  'ADS',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              Tab(
                child: Text(
                  'FAVOURITES',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products.get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 140, right: 140),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          backgroundColor: Colors.grey.shade100,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'My Ads',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2.5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data?.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data?.docs[i];
                              var _price = int.parse(data?['price']);
                              String _formattedPrice = '\Rs ${_format.format(_price)}';
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor.withOpacity(.8),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100,
                                            child: Center(child: Image.network(data?['images'][0])),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            _formattedPrice,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data?['title'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        child: CircleAvatar(
                                          backgroundColor:Colors.white ,
                                          child: Center(
                                            child: LikeButton(
                                              isLiked: data?['liked'] ?? false,
                                              onTap: (bool isLiked) async {
                                                // Update liked status in Firestore
                                                await _service.updateProductLikedStatus(data?.id, !isLiked);
                                                return !isLiked;
                                              },
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Center(
              child: FutureBuilder<QuerySnapshot>(
                future: _service.products.where('liked', isEqualTo: true).get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Text('No favourites yet');
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int i) {
                      var data = snapshot.data?.docs[i];
                      var _price = int.parse(data?['price']);
                      String _formattedPrice = '\Rs ${_format.format(_price)}';
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(.8),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    child: Center(child: Image.network(data?['images'][0])),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    _formattedPrice,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data?['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0.0,
                                child: CircleAvatar(
                                  backgroundColor:Colors.white ,
                                  child: Center(
                                    child: LikeButton(
                                      isLiked: true, // Always true for favourites
                                      circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xff33b5e5),
                                        dotSecondaryColor: Color(0xff0099cc),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.favorite,
                                          color: Colors.red, // Always red for favourites
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
