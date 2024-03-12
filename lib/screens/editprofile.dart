import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/login.dart';

class EditProfile extends StatefulWidget {
  final DataModel userdata;

  const EditProfile({Key? key, required this.userdata}) : super(key: key);

  @override
  State<EditProfile> createState() => _ProfileState();
}

class _ProfileState extends State<EditProfile> {
  File? image;
  late TextEditingController namecontroller;
  late TextEditingController mailcontroller;
  late TextEditingController passcontroller;

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.userdata.uname);
    mailcontroller = TextEditingController(text: widget.userdata.email);
    passcontroller = TextEditingController(text: widget.userdata.password);
    if (widget.userdata.image?.isNotEmpty == true) {
      image = File(widget.userdata.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Text('Edit Profile'),
        titleTextStyle:
            TextStyle(fontFamily: Appfont.primaryFont, fontSize: 18),
        centerTitle: true,
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
              onPressed: () {
                onedit();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.save_outlined,
              ))
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(65),
                        child: Container(
                          height: 110,
                          width: 110,
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundImage:
                                  image != null ? FileImage(image!) : null,
                              child: image == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      controller: namecontroller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          label: Text(
                            'Name',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      controller: mailcontroller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          label: Text('Email',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      controller: passcontroller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          label: Text('Password',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          border: OutlineInputBorder()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print('Picked File: $pickedFile');

    setState(() {
      // ignore: unnecessary_null_comparison
      if (pickedFile.path != null && pickedFile.path.isNotEmpty) {
        image = File(pickedFile.path);
      }
    });
  }

  Future<void> onedit() async {
    final name = namecontroller.text.trim();
    final mail = mailcontroller.text.trim();
    final pass = passcontroller.text.trim();
    print('Name: $name, Email: $mail, Password: $pass');

    if (widget.userdata.id != null) {
      final int id = widget.userdata.id!;
      print('User ID: $id');

      DataModel data = DataModel(
        id: id,
        uname: name,
        email: mail,
        password: pass,
        image: image?.path ?? '',
      );
      Username.setUsername(name);
      await editData(id, data);
     
      print('Data edited successfully');
    } else {
      print('ID is null');
    }
  }
}
