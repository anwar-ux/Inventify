import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/dbmodel.dart';  // Assuming your DataModel2 is in a file called dbmodel.dart
import 'package:inventify/db/db.dart';

class AddSubcategory extends StatefulWidget {
  final int categoryId;  
  const AddSubcategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  _AddSubcategoryState createState() => _AddSubcategoryState();
}

class _AddSubcategoryState extends State<AddSubcategory> {
  File? image;
  final nameController = TextEditingController();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subcategory'),
        titleTextStyle: const TextStyle(
             fontFamily: Appfont.primaryFont,
          color: AppColors.thirdcolor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (image != null) {
                  onsave();
                  Navigator.pop(context);
                } else {
                  showSnackBar(context);
                }
              }
            },
            icon: const Icon(
              Icons.save,
              color: AppColors.thirdcolor
            ),
          )
        ],
        toolbarHeight: 80,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: AppColors.primaryColor,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 140,
                      color: const Color.fromARGB(255, 216, 216, 216),
                      child: image != null
                          ? Image.file(image!, fit: BoxFit.cover)
                          : const Center(
                              child: Icon(
                                Icons.image,
                                size: 50.0,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                 TextFormField(
                  style: TextStyle(color: AppColors.thirdcolor),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Subcategory name required';
                    }
                    if (value.length < 3) {
                      return 'Name is too short';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.thirdcolor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:  AppColors.thirdcolor,
                          ),
                        ),
                    label: Text('Subcategory name',style: TextStyle(color: AppColors.thirdcolor),),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print("Image Path: ${pickedFile.path}");

    setState(() {
      image = File(pickedFile.path);
    });
  }

  Future<void> onsave() async {
    final title = nameController.text.trim();
   
    if (title.isEmpty ) {
      return;
    }

    final data = DataModel3(
      name: title,
      image: image?.path ?? '',
      categoryId: widget.categoryId, 
    );

    addSubcategory(data,widget.categoryId);
    setState(() {
      image = null;
      nameController.clear();
    });
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromRGBO(11, 206, 131, 1),
        content: Text(
          'Photo required',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
 
}

