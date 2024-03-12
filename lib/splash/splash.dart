import 'package:flutter/material.dart';
import 'package:inventify/login.dart';
import 'package:inventify/screens/bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

const saveKey = 'isLoggedIn';

// ignore: camel_case_types
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => splashState();
}

// ignore: camel_case_types
class splashState extends State<splash> {
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'INVENTIFY',
                style: TextStyle(fontSize: 30, fontFamily: 'JosefinSans'),
              ),
              Image(
                image: AssetImage("assets/Animation - 1709639361763.gif"),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> gotologin() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<void> checkUser() async {
    final shared = await SharedPreferences.getInstance();
    final userlogged = shared.getBool(saveKey);
    if (userlogged == null || userlogged == false) {
      gotologin();
    } else {
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Bottom()));
    }
  }
}
