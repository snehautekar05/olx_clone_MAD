import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:olx_clone/forms/form_class.dart';
import 'package:olx_clone/forms/user_review_screen.dart';
import 'package:olx_clone/provider/cat_provider.dart';
import 'package:olx_clone/services/firebase_service.dart';
import 'package:olx_clone/widgets/imagePicker_widget.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  static const String id="form-screen";

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseService _service=FirebaseService();

  var  _brandText=TextEditingController();
  var  _titleController=TextEditingController();
  var  _descController=TextEditingController();
  var  _priceController=TextEditingController();

  void validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if(provider.urlList.isNotEmpty){
        //should have image
        provider.dataToFirestore.addAll({
          'category':provider.selectedCategory,
          'subCat':provider.selectedSubCategory,
          'brand':_brandText.text,
          'price':_priceController.text,
          'title':_titleController.text,
          'description':_descController.text,
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

  FormClass _formClass=FormClass();


  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<CategoryProvider>(context);

    showFormDialog(list,_textController) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context,int i){
                          return ListTile(
                            onTap: (){
                    
                              setState(() {
                              _textController.text=list[i];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(list?[i],),
                          );
                        },),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }



    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
          title: Text('Add some Details',
          style: TextStyle(color: Colors.black),),
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),),
      body:Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_provider.selectedCategory ?? 'Category'} > ${_provider.selectedSubCategory ?? 'Subcategory'}'),

              InkWell(
                onTap: (){
               showFormDialog(_provider.doc?['brands'],_brandText);
                },
                child: TextFormField(
                  controller: _brandText,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Brands'
                  ),
                ),
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
        
                controller: _descController,
        
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
                  itemCount: _provider.urlList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        _provider.urlList[index],
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
                      child:Text(_provider.urlList.length>0
                          ? 'Upload images'
                          : 'Upload Image',),

                    ),
                  ),
                ),
              ),




            ],
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
            validate(_provider);
            print(_provider.dataToFirestore);
            },
    ),
    ),
    );
  }
}
