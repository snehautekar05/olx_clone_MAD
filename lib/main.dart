import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/forms/seller_car_form.dart';
import 'package:olx_clone/forms/user_review_screen.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:olx_clone/provider/product_provider.dart';
import 'package:olx_clone/screens/authentication/email_auth_screen.dart';
import 'package:olx_clone/screens/authentication/email_verification_screen.dart';
import 'package:olx_clone/screens/authentication/phoneauth_screen.dart';
import 'package:olx_clone/screens/authentication/reset_password_screen.dart';
import 'package:olx_clone/screens/categories/categories_list.dart';
import 'package:olx_clone/screens/categories/subCat_list.dart';
import 'package:olx_clone/forms/forms_screen.dart';
import 'package:olx_clone/screens/home_screen.dart';
import 'package:olx_clone/screens/login_screen.dart';
import 'package:olx_clone/screens/main_screen.dart';

import 'package:olx_clone/screens/sellitems/product_by_category_screen.dart';
import 'package:olx_clone/screens/sellitems/seller_category_list.dart';
import 'package:olx_clone/screens/sellitems/seller_subCat_list.dart';
import 'package:olx_clone/screens/splash_screen.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'dart:io';

import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?await Firebase.initializeApp(
     options: const FirebaseOptions(
         apiKey: "AIzaSyDuFtAm59795zlrpp16kTJTbd1Lac95KkI",
         appId: "1:232516563209:android:d2dea587c60de17bac63d8",
         messagingSenderId:"232516563209" ,
         projectId: "olxclone-12618",
         storageBucket: "olxclone-12618.appspot.com",
     )
  ):await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType=null;
  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_)=>CategoryProvider()),
        Provider(create: (_)=>ProductProvider()),
        ],
        child: MyApp()
        ,));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.cyan.shade900,
          fontFamily: 'Horizon',
        ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(locationChanging: true,),
        HomeScreen.id: (context) => HomeScreen(locationData: null),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        PasswordResetScreen.id: (context) => PasswordResetScreen(),
        EmailVerificationScreen.id:(context)=>EmailVerificationScreen() ,
        CategoryListScreen.id:(context)=>CategoryListScreen(),
        SubCatList.id:(context)=>SubCatList(),
        MainScreen.id:(context)=>MainScreen(),
        SellerCategoryListScreen.id:(context)=>SellerCategoryListScreen(),
        SellerSubCatList.id:(context)=>SellerSubCatList(),
        UserReviewScreen.id:(context)=>UserReviewScreen(),
        SellerCarForm.id:(context)=>SellerCarForm(),
        FormsScreen.id:(context)=>FormsScreen(),
        // ProductDetailsScreen.id:(context)=>ProductDetailsScreen(),
        ProductByCategory.id:(context)=>ProductByCategory(),
      },

    );
  }
}

