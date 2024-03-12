import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';

class Editcata extends StatefulWidget {
  final DataModel2 data;

  const Editcata({Key? key, required this.data}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

File? image;
late TextEditingController namecontroller;

class _CategoriesState extends State<Editcata> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.data.name);

    if (widget.data.image?.isNotEmpty == true) {
      image = File(widget.data.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Edit Categories'),
        titleTextStyle: const TextStyle(
          fontFamily: Appfont.primaryFont,
          color: AppColors.thirdcolor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
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
                color: AppColors.thirdcolor,
              ))
        ],
        toolbarHeight: 110,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                                    color: Color.fromRGBO(11, 206, 131, 1),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(color: AppColors.thirdcolor),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category name required';
                        }
                        if (value.length < 3) {
                          return 'name is too short';
                        }
                        return null;
                      },
                      controller: namecontroller,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.thirdcolor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.thirdcolor,
                            ),
                          ),
                          label: Text(
                            'Category name',
                            style: TextStyle(color: AppColors.thirdcolor),
                          ),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print("Image Path: ${pickedFile.path}");

    setState(() {
      image = File(pickedFile.path);
    });
  }

  Future<void> onsave() async {
    final title = namecontroller.text.trim();
    if (title.isEmpty) {
      return;
    }
    if (widget.data.id != null) {
      final id = widget.data.id!;
      final data = DataModel2(
        name: title,
        image: image?.path ?? '',
      );
      editdetails(id, data);
      print('data edited');
    }
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
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
