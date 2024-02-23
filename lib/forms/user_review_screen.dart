import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:olx_clone/screens/main_screen.dart';
import 'package:olx_clone/services/firebase_service.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
 static const  String id='user-review-screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {

  final _formKey = GlobalKey<FormState>();
  bool _loading=false;
  FirebaseService _service=FirebaseService();
  var _nameController=TextEditingController();
  var _countryCodeController=TextEditingController(text:'+91');
  var _phoneController=TextEditingController();
  var _emailController=TextEditingController();
  var _addressController=TextEditingController();

  @override
  void didChangeDependencies(){
    var _provider=Provider.of<CategoryProvider>(context);
    if (_provider != null) {
      _provider.getUserDetails();
      setState(() {
        _nameController.text = _provider.userDetails?['name'] ?? '';
        _phoneController.text = _provider.userDetails?['mobile'] ?? '';
        _emailController.text = _provider.userDetails?['email'] ?? '';
        _addressController.text = _provider.userDetails?['address'] ?? '';
      });
    }
    super.didChangeDependencies();
  }

  Future<void> updateUser(provider,Map<String, dynamic> data, context) {
    //first will update the user
    return _service.users
        .doc(_service.user?.uid)
        .update(data)
        .then((value) {
          //save the product details
          saveProductToDb(provider,context);
          

    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update users'),
        ),
      );
    });
  }
  //
  // Future<void> saveProductToDb(CategoryProvider provider,context) {
  //   return _service.products
  //       .doc(_service.user?.uid)
  //       .set(provider.dataToFirestore)
  //       .then((value) {
  //         //data updated
  //       })
  //       .catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Failed to add products'),
  //       ),
  //     );
  //   });
  // }

  Future<void> saveProductToDb(CategoryProvider provider, context) async {
    try {
      // Attempt to save data to Firestore
      return _service.products
          .doc(_service.user?.uid)
          .set(provider.dataToFirestore)
          .then((_) {
        // Data saved successfully
        print('Product data saved successfully');
      })
          .catchError((error) {
        // Print and show error message
        print('Error saving product data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save product details'),
          ),
        );
      });
    } catch (error) {
      // Handle the specific error related to nested arrays
      print('Error saving product data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save product details. Nested arrays are not supported.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    var _provider=Provider.of<CategoryProvider>(context);

    showConfirmDialog(){
     return showDialog(
         context: context,
       builder: (BuildContext cotext){
           return Dialog(
               child:Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Column(
                     mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Confirm',style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                     ),
                     SizedBox(height:10 ,),
                     Text('Are you sure,you want to save the below product'),
                     SizedBox(height: 10,),
                     ListTile(
                       leading: Image.network(_provider.dataToFirestore['images'][0]),
                       title:Text(_provider.dataToFirestore['title'],maxLines: 1,),
                       subtitle:Text(_provider.dataToFirestore['price']),
                     ),
                     SizedBox(height: 20,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         NeumorphicButton(
                           onPressed: (){
                             setState(() {
                               _loading=false;
                             });
                             Navigator.pop(context);
                           }
                           ,
                           style: NeumorphicStyle(
                             border: NeumorphicBorder(color: Theme.of(context).primaryColor),
                             color:Colors.transparent,
                           ),
                           child: Text('Cancel'),
                         ),
                         SizedBox(width: 10,),
                         NeumorphicButton(
                           style: NeumorphicStyle(
                             color: Theme.of(context).primaryColor
                           ),
                           child: Text('Confirm',style: TextStyle(color:Colors.white),),
                           onPressed: (){
                             setState(() {
                               _loading=true;
                             });
                             updateUser(_provider,{
                               'contactDetails':{
                                 'name':_nameController.text,
                                 'contactMobile':_phoneController.text,
                                 'comtactEmail':_emailController.text,
                                 'address':_addressController.text,
                               }
                             }, context).whenComplete((){

                             ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                             content: Text('We have received your products'),
                             ),
                             );

                               setState(() {
                                 _loading=false;
                               });
                             });
                             Navigator.pushReplacementNamed(context,MainScreen.id);
                           },
                         ),

                       ],
                     ),
                     SizedBox(height:20 ,),
                     Center(child: CircularProgressIndicator(
                       valueColor:AlwaysStoppedAnimation<Color>(
                           Theme.of(context).primaryColor),
                     )),



                   ],
                 ),
               )
           );

       }
     );
     
    }

  return Scaffold(
    appBar:AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      title: Text(
        'Review your details',
        style: TextStyle(color: Colors.black),
      ),
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),

    ),
    body:Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius:40,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue.shade500,
                      radius: 38,
                      child: Icon(CupertinoIcons.person_alt,
                        color: Colors.red.shade300,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextFormField(
                     controller:_nameController,
                       decoration: InputDecoration(
                            labelText: 'Your Name'),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter your name';
                        }
                        return null;
                      },
          
                    ),
                  )
                ],
              ),
                    SizedBox(height: 30,),
                   Text('Contact Details',
                style:TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                      child: TextFormField(
          
                    controller:_countryCodeController,
                       enabled: false,
                        decoration: InputDecoration(

                          labelText:'Country',
                        ),
                  )),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 3,
                      child: TextFormField(
                        controller:_phoneController ,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                         labelText: 'Mobile Number' ,
                          helperText: 'Enter your mobile number',
          
          
                        ),
                        maxLength:10 ,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      )),
                ],
              ),
              SizedBox(
                height: 30,),
              TextFormField(
              controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  helperText: "Enter your Email",
                ),
                validator: (value) {
                  final bool isValid =
                  EmailValidator.validate(_emailController.text);
                  if (value == null || value.isEmpty) {
                    return 'Enter Email';
                  }
                  if (value.isNotEmpty && isValid == false) {
                    return 'Enter Valid Email';
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: false,
                controller: _addressController,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: 'Address',
                  helperText: 'Contact Address',
                  suffixIcon: Icon(Icons.arrow_forward_ios,size: 12,),
                ),
              )
            ],
          
          ),
        ),
      ),
    ),
   bottomSheet:Padding(
     padding: const EdgeInsets.all(20.0),
     child: Row(
       children: [
         Expanded(
           child: NeumorphicButton(
             style: NeumorphicStyle(color:Theme.of(context).primaryColor),
             child: Text('Confirm',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.white,
             fontWeight: FontWeight.bold),
             ),
             onPressed: (){
               if(_formKey.currentState?.validate() ?? false){
                 showConfirmDialog();

               }
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                     content: Text('Enter the required fields'),
                 ),
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
