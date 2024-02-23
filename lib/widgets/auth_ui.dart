import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_clone/screens/authentication/email_verification_screen.dart';
import 'package:olx_clone/screens/authentication/google_auth.dart';
import 'package:olx_clone/screens/authentication/phoneauth_screen.dart';
import 'package:olx_clone/screens/authentication/email_auth_screen.dart';
import 'package:olx_clone/services/phoneauth_service.dart';

class AuthUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(3.0),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, PhoneAuthScreen.id);
              },
              child: Row(
                children: [
                  Icon(Icons.phone_android_outlined, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Continue with Phone', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
          SignInButton(
            Buttons.Google,
            text: ('Continue with Google'),
            onPressed: () async {
              User? user = await GoogleAuthentication.signInWithGoogle(context: context);
              if (user != null) {
                PhoneAuthService _authentication = PhoneAuthService();
                _authentication.addUser(context, user.uid);
              }
            },
          ),
          SignInButton(
            Buttons.FacebookNew,
            text: ('Continue with Facebook'),
            onPressed: () {},
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EmailAuthScreen.id);
              //before adding new user,it will navigate to verification screen
              // Navigator.pushNamed(context, EmailVerificationScreen.id);
            },
            child: Container(
              child: Text(
                'Login with Email',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
