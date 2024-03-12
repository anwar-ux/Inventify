import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/editcata.dart';
import 'package:inventify/screens/items.dart';

enum SampleItem { itemOne, itemTwo }

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class CategoriesList {
  static List<DataModel2> categories = [];
}

late int? subcount;

class _CategoriesState extends State<Categories> {
  DataModel2? selectedCategory;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getAlldetails();
  }

  Widget buildSearchBar(List<DataModel2> value2) {
    return TextField(
      focusNode: searchFocusNode,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onChanged: (String value) {
        setState(() {
          if (value.isNotEmpty) {
            // Filter the complete list of products
            List<DataModel2> filteredList = dataListNotifier2.value
                .where((data) =>
                    data.name!.toLowerCase().contains(value.toLowerCase()))
                .toList();
            // Update the value of the productsListNotifier
            dataListNotifier2.value = filteredList;
          } else {
            dataListNotifier2.value = CategoriesList.categories;
          }
        });
      },
    );
  }

  Future<int?> fetchSubcategoryCount(int categoryId2) async {
    try {
      List<DataModel3> filteredSubcategories = subcategoryListNotifier.value
          .where((subCategory) => subCategory.categoryId == categoryId2)
          .toList();
      int count = filteredSubcategories.length;
      return count;
    } catch (e) {
      print("Error fetching subcategories count: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataListNotifier2,
      builder: (BuildContext ctx, List<DataModel2> updatedList, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INVENTIFY',
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            titleTextStyle: TextStyle(
              fontFamily: Appfont.primaryFont,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            toolbarHeight: 100,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: buildSearchBar(updatedList),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              searchFocusNode.unfocus();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              child: updatedList.isEmpty
                  ? Center(
                      child: Text(
                        'No Category available\n    (Add from profile)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 13, right: 13, left: 13),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 185,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          final data = updatedList[index];

                          if (!CategoriesList.categories.contains(data)) {
                            CategoriesList.categories.add(data);
                          }

                          return FutureBuilder<int?>(
                            future: fetchSubcategoryCount(data.categoryId ?? 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    strokeWidth: 0.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int? subcount = snapshot.data;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = data;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Items(
                                          data: data,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(
                                              data.image!,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              data.name!,
                                              style: const TextStyle(
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: AppColors.thirdcolor,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '($subcount)',
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.thirdcolor),
                                                ),
                                                PopupMenuButton<SampleItem>(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                  ),
                                                  onSelected:
                                                      (SampleItem item) {
                                                    if (item ==
                                                        SampleItem.itemOne) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Editcata(
                                                            data: data,
                                                          ),
                                                        ),
                                                      );
                                                    } else if (item ==
                                                        SampleItem.itemTwo) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Delete Confirmation'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (data.id !=
                                                                      null) {
                                                                    CategoriesList
                                                                        .categories
                                                                        .removeAt(
                                                                            data.id!);
                                                                    delete2(data
                                                                        .id!);
                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    print(
                                                                        "Data.id is null");
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry<
                                                              SampleItem>>[
                                                    const PopupMenuItem<
                                                        SampleItem>(
                                                      value: SampleItem.itemOne,
                                                      child: Text('Edit'),
                                                    ),
                                                    const PopupMenuItem<
                                                        SampleItem>(
                                                      value: SampleItem.itemTwo,
                                                      child: Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        itemCount: updatedList.length,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
