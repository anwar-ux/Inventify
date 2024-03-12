import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/login.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final namecontroller = TextEditingController();
  final mailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode mailFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();
  final FocusNode confirmPassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          nameFocusNode.unfocus();
          mailFocusNode.unfocus();
          passFocusNode.unfocus();
          confirmPassFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            color:   Theme.of(context).colorScheme.background,
            child: Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text('SignUp Now',
                          style: TextStyle(
                              fontSize: 35, color:   Theme.of(context).colorScheme.primary,),),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        focusNode: nameFocusNode,
                        style:  TextStyle(color:   Theme.of(context).colorScheme.primary,),
                        controller: namecontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'name required';
                          }
                          if (RegExp(r'\d').hasMatch(value)) {
                            return 'Numbers are not allowed';
                          }
                          if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          if (value.length < 3) {
                            return 'name is too short';
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(color:   Theme.of(context).colorScheme.primary,)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: mailFocusNode,
                        style:  TextStyle(color:   Theme.of(context).colorScheme.primary,),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                        controller: mailcontroller,
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:  Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(color:  Theme.of(context).colorScheme.primary,)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: passFocusNode,
                        style:  TextStyle(color:   Theme.of(context).colorScheme.primary),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password required';
                          }
                          if (value.length < 8) {
                            return 'password atleast 8 characters';
                          }
                          return null;
                        },
                        controller: passcontroller,
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color:   Theme.of(context).colorScheme.primary,)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        cursorOpacityAnimates: false,
                        focusNode: confirmPassFocusNode,
                        style:  TextStyle(color:   Theme.of(context).colorScheme.primary,),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'confirm password required';
                          }
                          if (value != passcontroller.text) {
                            return 'Wrong password';
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:   Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(color:  Theme.of(context).colorScheme.primary,)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(0),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Set the border color here
                            )),
                            minimumSize: MaterialStateProperty.all(
                                const Size(350.0, 55.0)),
                            backgroundColor:  MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            onSignupclicked();
                            if (formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                            return;
                          },
                          child:  Text(
                            'Sign up',
                            style: TextStyle(color:   Theme.of(context).colorScheme.background,),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSignupclicked() async {
    final name = namecontroller.text.trim();
    final mail = mailcontroller.text.trim();
    final pass = passcontroller.text.trim();
    if (name.isEmpty || pass.isEmpty || mail.isEmpty) {
      return;
    }
    final data = DataModel(
      uname: name,
      email: mail,
      password: pass,
      image: '',
    );
    adddata(data);
  }
}
