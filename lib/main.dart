// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/login.dart';
import 'package:inventify/splash/splash.dart';
import 'package:inventify/theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Hive adapters for your data models
  Hive.registerAdapter<DataModel>(DataModelAdapter());
  Hive.registerAdapter<DataModel2>(DataModel2Adapter());
  Hive.registerAdapter<DataModel3>(DataModel3Adapter());
  Hive.registerAdapter<DataModel4>(DataModel4Adapter());
  Hive.registerAdapter<Bill>(BillAdapter());

  // Load the saved username
  await Username.loadUsername();

  try {
    // Open Hive boxes for your data models and bill
    await Hive.openBox<DataModel>('Inventify_db');
    await Hive.openBox<DataModel2>('Inventify_db2');
    await Hive.openBox<DataModel3>('Subcategories_db');
    await Hive.openBox<DataModel4>('Products_db');
    await Hive.openBox<Bill>('bill_db');
  } catch (e) {
    print('Error opening Hive boxes: $e');
  }

  // Create the main app and start it with the saved theme
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        ThemeProvider themeProvider = ThemeProvider();
        themeProvider.loadSavedTheme(); // Load the saved theme
        return themeProvider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themedata,
      debugShowCheckedModeBanner: false,
      home: const splash(),
    );
  }
}
