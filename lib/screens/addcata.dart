import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';

enum SampleItem { itemOne, itemtow }

class Addcata extends StatefulWidget {
  const Addcata({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

File? image;
final namecontroller = TextEditingController();
final descriptioncontroller = TextEditingController();

class _CategoriesState extends State<Addcata> {
  SampleItem selectedMenu = SampleItem.itemOne;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Widget buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      onChanged: (String value) {
        // Handle search input changes
        // You may want to filter your data based on the search input
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Add Categories',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        titleTextStyle: TextStyle(
          fontFamily: Appfont.primaryFont,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
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
              icon: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.primary,
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
          color: Theme.of(context).colorScheme.background,
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
                          color: Theme.of(context).colorScheme.primary,
                          child: image != null
                              ? Image.file(image!, fit: BoxFit.cover)
                              : Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
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
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.thirdcolor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          label: Text(
                            'Category name',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          border: const OutlineInputBorder()),
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
    final data = DataModel2(
      name: title,
      image: image?.path ?? '',
    );
    adddetails(data);

    setState(() {
      image = null;
      namecontroller.clear();
    });
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
