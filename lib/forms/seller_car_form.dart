import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:olx_clone/forms/user_review_screen.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:olx_clone/services/firebase_service.dart';
import 'package:provider/provider.dart';

import '../widgets/imagePicker_widget.dart';

class SellerCarForm extends StatefulWidget {
  static const String id = 'car-form';

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseService _service=FirebaseService();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _kmController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _titleController = TextEditingController();
  var _addressController = TextEditingController();



  void validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
        if(provider.urlList.isNotEmpty){
          //should have image
             provider.dataToFirestore.addAll({
               'category':provider.selectedCategory,
               'subCat':provider.selectedSubCategory,
               'brand':_brandController.text,
               'year':_yearController.text,
               'price':_priceController.text,
               'fuel':_fuelController.text,
               'transmission':_transmissionController.text,
               'kmDrive':_kmController.text,
               'noOfOwners':_noOfOwnerController.text,
               'title':_titleController.text,
               'description':_descriptionController.text,
               'sellerUid':_service.user?.uid,
               'images':provider.urlList,
               'postedAt':DateTime.now().microsecondsSinceEpoch,
               'liked':false,
             });

             print(provider.dataToFirestore);
             Navigator.pushNamed(context,UserReviewScreen.id);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Image not uploaded'),
            ),
          );
        }

    }else{
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
           content: Text('Please complete the required fields...')
       ),
     );
    }
  }

  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];
  List<String> _transmission = ['Manually', 'Automatic'];
  List<String> _noOfOwner = ['1','2','3','4','4+'];





   @override
   void didchangeDependencies(){
    var _catProvider=Provider.of<CategoryProvider>(context);
    setState(() {
      _brandController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['brand'];
      _yearController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['year'];
      _priceController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['price'];
      _fuelController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['fuel'];
      _transmissionController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['transmission'];
      _kmController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['kmDrive'];
      _noOfOwnerController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['noOfowners'];
      _titleController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['title'];
      _descriptionController.text=_catProvider.dataToFirestore.isEmpty?
      null:_catProvider.dataToFirestore['description'];

    });
   }
  @override


  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);


    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        title: Text(
          '$title>$fieldValue',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _catProvider.doc!['models'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      _brandController.text =
                      _catProvider.doc!['models'][index];
                      Navigator.pop(context);
                    },
                    title: Text(_catProvider.doc!['models'][index]),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list,textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: (){
                    textController.text=list[index];
                    Navigator.pop(context);
                  },
                  title: Text(list[index]),
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add Some Details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CAR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _brandList();
                        },
                      );
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Brand/Model/Variant',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter brand/model/variant';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Year*',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter year';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
              
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price*',
                      prefixText: 'Rs',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listView(
                              fieldValue: 'Fuel',
                              list: _fuelList,textController:_fuelController );
                        },
                      );
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuelController,
                      decoration: InputDecoration(
                        labelText: 'Fuel*',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fuel';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listView(
                              fieldValue: 'Transmission',
                              list: _transmission,
                              textController:_transmissionController);
                        },
                      );
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      decoration: InputDecoration(
                        labelText: 'Transmission*',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fuel';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
              
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'KM Driven*',
              
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter KMDriven';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _listView(
                              fieldValue: 'No.of owners',
                              list: _noOfOwner,
                              textController:_noOfOwnerController);
                        },
                      );
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      decoration: InputDecoration(
                        labelText: 'No.of Owners*',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter no.of owners';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
              
                    controller: _titleController,
                    keyboardType: TextInputType.text,

                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Add title*',
                      helperText:'Mention the key features(e.g brand,model)',
              
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
              
                    controller: _descriptionController,

                    maxLength: 4000,
                    decoration: InputDecoration(
                      labelText: 'Description*',
                      helperText:'Include condition,features,reasons for selling',
              
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),
                  Divider(color: Colors.grey,),

                  Container(


                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _catProvider.urlList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _catProvider.urlList[index],
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height:10,),
                  InkWell(
                    onTap: (){
                        //image uploading

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ImagePickerWidget();
                        },
                      );

                    },
                    child: Neumorphic(
                      style: NeumorphicStyle(
                      border: NeumorphicBorder(
                        color: Theme.of(context).primaryColor,
                      )
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child:Text(_catProvider.urlList.length>0
                              ? 'Upload images'
                              : 'Upload Image',),

                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 80,),

              
              
              
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: NeumorphicButton(
          style: NeumorphicStyle(
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Save',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            validate(_catProvider);
            print(_catProvider.dataToFirestore);
          },
        ),
      ),
    );
  }
}
