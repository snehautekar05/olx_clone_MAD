import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/location_screen.dart';
import 'package:olx_clone/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  static const String id='login-screen';
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body:Column(
        children: [
          Expanded(
            child:Container(
              width:MediaQuery.of(context).size.width,//to get device width
            color: Colors.white,
            child: Column(
             children: [
               SizedBox(height: 50),
               Image.asset('assets/images/cart.png',
               color: Colors.cyan.shade900,
                 height: 100,),
               SizedBox(height: 5,),
               Text('Olx',style: TextStyle(
                 fontFamily: 'Horizon',
                 fontSize: 50,
                 fontWeight:FontWeight.bold,
                 color: Colors.cyan.shade900,

               ),)

             ], 
            ),
          ),),
          Expanded(child:Container(
            child: AuthUi(),
          ),),
          Padding(padding: const EdgeInsets.all(8.0),
          child:Text('If you continue,you are accepting\nTerms and Conditions and Privacy Policy'
          ,textAlign:TextAlign.center,style:TextStyle(color: Colors.white,fontSize: 10) ,),
          ),
          ],

      ),



    );
  }
}
