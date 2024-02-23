import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/authentication/email_verification_screen.dart';

import '../screens/location_screen.dart';

class EmailAuthentication {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> getAdminCredential({
    required String email,
    required String password,
    required bool isLog,
    required BuildContext context,
  }) async {
    DocumentSnapshot _result = await users.doc(email).get();
    if (isLog) {
      emailLogin(email, password, context);
    } else {
      if (_result.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An Account Already Exists with this Email'),
          ),
        );
      } else {
        emailRegister(email, password, context);
      }
    }

    return _result;
  }

  emailLogin(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password);
      if(userCredential.user?.uid!=null){
        Navigator.pushReplacementNamed(context,LocationScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found for that email')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Wrong Password provided for that user')),
        );
      }
    }
  }

  emailRegister(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid != null) {
        //login success .Add user data to firestore
        return users.doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'mobile': null,
          'email': userCredential.user!.email,
          'name':null,
          'address':null,
        }).then((value)async {
            //before going to location screen will send email verification
            await userCredential.user?.sendEmailVerification().then((value){
              //after sending verification email,screen will move to emailverification screen
              Navigator.pushReplacementNamed(context, EmailVerificationScreen.id);
            });


        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add user')),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('The account already exists for that email.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred')),
      );
    }
  }
}
