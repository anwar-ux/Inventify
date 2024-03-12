import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/db/db.dart';

class Addproduct extends StatefulWidget {
  final int subcategoryId;
  const Addproduct({Key? key, required this.subcategoryId}) : super(key: key);

  @override
  _AddSubcategoryState createState() => _AddSubcategoryState();
}

class _AddSubcategoryState extends State<Addproduct> {
  File? image;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final purchaserateController = TextEditingController();
  final sellingrateController = TextEditingController();
  final brandController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            title: const Text('Add product'),
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
                ),
              )
            ],
            toolbarHeight: 120,
            pinned: true,
            floating: false,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
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
                              color: AppColors.thirdcolor,
                            ),
                          ),
                          label: Text(
                            'Product name',
                            style: TextStyle(color: AppColors.thirdcolor),
                          ),
                          border: OutlineInputBorder(),
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
                            return 'Brand required';
                          }
                          return null;
                        },
                        controller: brandController,
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
                          label: Text('Brand',
                              style: TextStyle(color: AppColors.thirdcolor)),
                          border: OutlineInputBorder(),
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
                            return 'Description required';
                          }
                          if (value.length >= 80) {
                            return '80 characters only allowed';
                          }
                          return null;
                        },
                        controller: descriptionController,
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
                          label: Text('Description',
                              style: TextStyle(color: AppColors.thirdcolor)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.thirdcolor),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Rate required';
                          }
                          return null;
                        },
                        controller: purchaserateController,
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
                          label: Text('Purchase Rate',
                              style: TextStyle(color: AppColors.thirdcolor)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: AppColors.thirdcolor),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Rate required';
                          }
                          return null;
                        },
                        controller: sellingrateController,
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
                          label: Text('Selling Rate',
                              style: TextStyle(color: AppColors.thirdcolor)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
    final title = nameController.text.trim();
    final dis = descriptionController.text.trim();
    final pRate = purchaserateController.text.trim();
    final sRate = sellingrateController.text.trim();
    final brand = brandController.text.trim();
    if (title.isEmpty || dis.isEmpty) {
      return;
    }

    final data = DataModel4(
      name: title,
      brand: brand,
      image: image?.path ?? '',
      description: dis,
      purchaseprice: int.parse(pRate),
      sellingprice: int.parse(sRate),
      subcategoryId: widget.subcategoryId,
      stock: 0,
    );

    addproduct(data, widget.subcategoryId);
    setState(() {
      image = null;
      nameController.clear();
      descriptionController.clear();
      purchaserateController.clear();
      sellingrateController.clear();
      brandController.clear();
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
