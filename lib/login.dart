import 'package:flutter/material.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/screens/bottom.dart';
import 'package:inventify/signup.dart';
import 'package:inventify/splash/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

const String usernameKey = 'username';

class Username {
  static String storedusername = '';

  static String get username => storedusername;

  static Future<void> setUsername(String value) async {
    storedusername = value;
    print('Username set: $value');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(usernameKey, value);
  }

  static Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedusername = prefs.getString(usernameKey) ?? '';
    print('Username loaded: $storedusername');
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode nameFocusNode = FocusNode();

  final FocusNode passFocusNode = FocusNode();

  final namecontroller = TextEditingController();

  final passcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Username.loadUsername();
    getAlldata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          nameFocusNode.unfocus();
          passFocusNode.unfocus();
        },
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login Now',
                      style: TextStyle(
                        fontSize: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: namecontroller,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusNode: nameFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'name required';
                        }
                        if (RegExp(r'\d').hasMatch(value)) {
                          return 'Numbers are not allowed';
                        }
                        if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Special characters are not allowed';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passcontroller,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password required';
                        }
                        // if (RegExp(r'\d').hasMatch(value)) {
                        //   return 'Numbers are not allowed';
                        // }
                        // if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        //   return 'Special characters are not allowed';
                        // }
                        return null;
                      },
                      focusNode: passFocusNode,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(0),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Set the border color here
                          )),
                          minimumSize: MaterialStateProperty.all(
                              const Size(350.0, 55.0)),
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            bool usernameExists = dataListNotifier.value.any(
                              (data) => data.uname == namecontroller.text,
                            );

                            if (usernameExists) {
                              bool passwordCorrect = dataListNotifier.value.any(
                                (data) => data.password == passcontroller.text,
                              );

                              if (passwordCorrect) {
                                // Username and password are correct
                                // Add your logic here
                                changingSharedValue();
                                Username.setUsername(namecontroller.text);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Bottom(),
                                  ),
                                );
                              } else {
                                // Password is incorrect
                                // Add your logic here
                                showSnackBar(context, 'INCORECT PASSWORD');
                              }
                            } else {
                              // Username doesn't exist
                              // Add your logic here
                              showSnackBar(context, 'INVALID USER');
                            }
                          }
                          return;
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have a account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Text(
                            ' SignUp',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          msg,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> changingSharedValue() async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool(saveKey, true);
  }
}
