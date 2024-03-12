import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/additem.dart';
import 'package:inventify/screens/editsubcata.dart';
import 'package:inventify/screens/products.dart';

enum SampleItem { itemOne, itemTwo }

class Items extends StatefulWidget {
  final DataModel2 data;

  const Items({Key? key, required this.data}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class SubCategoriesList {
  static List<DataModel3> subcategories = [];
}

class _ItemsState extends State<Items> {
  SampleItem selectedMenu = SampleItem.itemOne;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getAllSubcategory();
    for (final data in subcategoryListNotifier.value) {
      if (!SubCategoriesList.subcategories.contains(data)) {
        SubCategoriesList.subcategories.add(data);
      }
    }
  }

  Widget buildSearchBar() {
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
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
            List<DataModel3> filteredList = subcategoryListNotifier.value
                .where((data) =>
                    data.name!.toLowerCase().contains(value.toLowerCase()))
                .toList();
            // Update the value of the productsListNotifier
            subcategoryListNotifier.value = filteredList;
          } else {
            subcategoryListNotifier.value = SubCategoriesList.subcategories;
          }
        });
      },
    );
  }

  Future<int?> fetchSubcategoryCount(int categoryId) async {
    try {
      // Filter subcategories based on the provided categoryId
      List<DataModel4> filteredSubcategories = productsListNotifier.value
          .where((subCategory) => subCategory.subcategoryId == categoryId)
          .toList();
      int count = filteredSubcategories.length;
      return count;
    } catch (e) {
      // Handle error (e.g., log, return null, or throw an exception)
      print("Error fetching subcategories count: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (widget.data != null && widget.data.categoryId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubcategory(
                    categoryId: widget.data.categoryId!,
                  ),
                ),
              );
            } else {
              print('Error: widget.data or widget.data.categoryId is null');
            }
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.data.name ?? '',
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
          toolbarHeight: 100,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Theme.of(context).colorScheme.primary,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildSearchBar(),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            searchFocusNode.unfocus();
          },
          child: ValueListenableBuilder(
            valueListenable: subcategoryListNotifier,
            builder: (BuildContext context, List<DataModel3> datalist,
                Widget? child) {
              //Filter subcategories based on the selected category
              final filteredSubcategories = datalist
                  .where((subCategory) =>
                      subCategory.categoryId == widget.data.categoryId)
                  .toList();
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                child: filteredSubcategories.isEmpty
                    ? Center(
                        child: Text(
                          'No Subcategory available',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          final data = filteredSubcategories[index];
                          if (!SubCategoriesList.subcategories.contains(data)) {
                            SubCategoriesList.subcategories.add(data);
                          }

                          return FutureBuilder<int?>(
                            future:
                                fetchSubcategoryCount(data.subcategoryId ?? 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Handle loading state
                                return Transform.scale(
                                  scale: 0.7,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 0.5,
                                  ));
                              } else if (snapshot.hasError) {
                                // Handle error state
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Handle success state
                                int? productcount = snapshot.data;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Products(data: data),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14, top: 14),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              height: 105,
                                              width: 165,
                                              color: Colors.black,
                                              child: Image.file(
                                                File(data.image!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      data.name!,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22),
                                                    ),
                                                    PopupMenuButton<SampleItem>(
                                                      icon: Icon(
                                                        Icons.more_horiz,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      initialValue:
                                                          selectedMenu,
                                                      onSelected:
                                                          (SampleItem item) {
                                                        if (item ==
                                                            SampleItem
                                                                .itemOne) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EditSubcategory(
                                                                        categoryId:
                                                                            data
                                                                                .categoryId!,
                                                                        data:
                                                                            data)),
                                                          );
                                                          print(data.id);
                                                        } else if (item ==
                                                            SampleItem
                                                                .itemTwo) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
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
                                                                      SubCategoriesList
                                                                          .subcategories
                                                                          .removeAt(
                                                                              data.id!);
                                                                      if (data.id !=
                                                                          null) {
                                                                        deleteSubcategory(
                                                                            data.id!);
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        print(
                                                                            "Data.id is null");
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Yes'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry<
                                                              SampleItem>>[
                                                        const PopupMenuItem<
                                                            SampleItem>(
                                                          value: SampleItem
                                                              .itemOne,
                                                          child: Text('Edit'),
                                                        ),
                                                        const PopupMenuItem<
                                                            SampleItem>(
                                                          value: SampleItem
                                                              .itemTwo,
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'All brands',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Available products ${productcount ?? 0}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
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
                            },
                          );
                        },
                        itemCount: filteredSubcategories.length,
                      ),
              );
            },
          ),
        ));
  }
}
