import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/login.dart';
import 'package:inventify/screens/bill.dart';
import 'package:inventify/screens/category.dart';
import 'package:inventify/screens/editprofile.dart';
import 'package:inventify/screens/items.dart';
import 'package:inventify/screens/privacypolicy.dart';
import 'package:inventify/screens/products.dart';
import 'package:inventify/screens/termofuse.dart';
import 'package:inventify/theme/theme.dart';
import 'package:provider/provider.dart';
import './addcata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlldetails();
    getAllSubcategory();
    getAllproduct();
    getAlldata();
    initDataList2();
    initsubcatogery();
    initproducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Text('Profile'),
        titleTextStyle: TextStyle(
          fontFamily: Appfont.primaryFont,
          fontSize: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Correct usage with listen: false
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              icon: Icon(
                Icons.color_lens,
                color: Theme.of(context).colorScheme.primary,
              )),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content:
                        const Text('If you want to logout from this account'),
                    titleTextStyle: const TextStyle(
                      color: Color.fromARGB(255, 238, 43, 43),
                      fontSize: 20,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          singout(context);
                        },
                        child: const Text(
                          'YES',
                          style: TextStyle(
                            fontFamily:
                                'poppins', // Specify the 'poppins' font family
                            fontSize: 15,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'NO',
                          style: TextStyle(fontFamily: 'poppins', fontSize: 15),
                        ),
                      )
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: dataListNotifier,
                builder: (BuildContext context, List<DataModel> datalist,
                    Widget? child) {
                  if (datalist.isEmpty) {
                    return const LinearProgressIndicator();
                  }
                  String targetUsername = Username.username;
                  DataModel? userData = datalist.firstWhere(
                    (data) => data.uname == targetUsername,
                  );
                  DataModel data = userData;
                  print(data.id);

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: Container(
                              width: 105,
                              height: 105,
                              color: Theme.of(context).colorScheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  backgroundImage: (data.image != null &&
                                          data.image!.isNotEmpty)
                                      ? FileImage(File(data.image!))
                                      : null,
                                  child: (data.image == null ||
                                          data.image!.isEmpty)
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
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.uname!,
                                    style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    data.email!,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                userdata: data,
                                              )));
                                },
                                child: Text(
                                  'Edit profile',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 15, top: 0),
                title: Text(
                  'Important',
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Billsection()));
                },
                leading: Icon(
                  Icons.update,
                  color: Theme.of(context).colorScheme.primary,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 15, top: 0, right: 15),
                title: Text(
                  'Bill Section',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary),
              ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Addcata())),
                leading: Icon(
                  Icons.add_card,
                  color: Theme.of(context).colorScheme.primary,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 15, top: 0, right: 15),
                title: Text(
                  'Add categories',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Privacypolicy()));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.privacy_tip_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 0, right: 15),
                  title: Text(
                    'Privacy policy',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  TermsOfUseScreen()));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.receipt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 0, right: 15),
                  title: Text(
                    'Terms of Use',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.primary),
              const Text('version 1.0.0',style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }

  singout(BuildContext context) async {
    final shared = await SharedPreferences.getInstance();
    await shared.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  Future<void> initDataList2() async {
    // Assuming dataListNotifier2 is a ValueNotifier<List<DataModel2>>
    List<DataModel2> dataList2 = dataListNotifier2.value;

    // Update CategoriesList.categories with unique items from dataList2
    for (DataModel2 data in dataList2) {
      if (!CategoriesList.categories
          .any((existingData) => existingData.id == data.id)) {
        CategoriesList.categories.add(data);
      }
    }
  }

  Future<void> initsubcatogery() async {
    // Assuming dataListNotifier2 is a ValueNotifier<List<DataModel2>>
    List<DataModel3> dataList2 = subcategoryListNotifier.value;

    // Update CategoriesList.categories with unique items from dataList2
    for (DataModel3 data in dataList2) {
      if (!CategoriesList.categories
          .any((existingData) => existingData.id == data.id)) {
        SubCategoriesList.subcategories.add(data);
      }
    }
  }

  Future<void> initproducts() async {
    // Assuming dataListNotifier2 is a ValueNotifier<List<DataModel2>>
    List<DataModel4> dataList2 = productsListNotifier.value;

    // Update CategoriesList.categories with unique items from dataList2
    for (DataModel4 data in dataList2) {
      if (!CategoriesList.categories
          .any((existingData) => existingData.id == data.id)) {
        ProductList.productList.add(data);
      }
    }
  }
}
