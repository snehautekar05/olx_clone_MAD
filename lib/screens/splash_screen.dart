import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/screens/login_screen.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id='splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3), // Corrected the syntax here
          () {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          } else {
            Navigator.pushReplacementNamed(context, LocationScreen.id);
          }
        });
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.cyan,

    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Horizon',//need to add our own font
      fontWeight: FontWeight.bold,
    );


    return  Scaffold(
      backgroundColor:Colors.cyan.shade900 ,
      body:Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           Image.asset('assets/images/cart.png',
               // color: Colors.white
             ),
           SizedBox(
             height:10,
           ),
            //need an animated text
        AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Olx',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
              ),

            ],
            isRepeatingAnimation: true,
            onTap: () {
              print("Tap Event");
            },
          ),

          ],
        ),
      ),

    );
  }
}


