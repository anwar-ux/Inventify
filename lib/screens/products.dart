import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/Editproduct.dart';
import 'package:inventify/screens/addproducts.dart';
import 'package:inventify/screens/productdetails.dart';

enum SampleItem { itemOne, itemTwo }

class Products extends StatefulWidget {
  final DataModel3 data;

  const Products({Key? key, required this.data}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class ProductList {
  static List<DataModel4> productList = []; // Global list of categories
}

class _ItemsState extends State<Products> {
  SampleItem selectedMenu = SampleItem.itemOne;
  DataModel4? selectedCategory;
  final FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getAllproduct();
  }

  TextEditingController searchController = TextEditingController();
  Widget buildSearchBar() {
    return TextField(
      focusNode: searchFocusNode,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      controller: searchController,
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
            List<DataModel4> filteredList = productsListNotifier.value
                .where((data) =>
                    data.name!.toLowerCase().contains(value.toLowerCase()) ||
                    data.brand!.toLowerCase().contains(value.toLowerCase()))
                .toList();
            // Update the value of the productsListNotifier
            productsListNotifier.value = filteredList;
          } else {
            // If the search field is empty, show all products
            productsListNotifier.value = ProductList.productList;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: productsListNotifier,
      builder:
          (BuildContext context, List<DataModel4> datalist, Widget? child) {
        // Filter subcategories based on the selected category
        final filteredproducts = datalist
            .where((products) =>
                products.subcategoryId == widget.data.subcategoryId)
            .toList();
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              if (widget.data.subcategoryId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addproduct(
                      subcategoryId: widget.data.subcategoryId!,
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
            title: Text(widget.data.name ?? ''),
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
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(45.0),
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.background,
              child: filteredproducts.isEmpty
                  ? Center(
                      child: Text(
                        'No products available',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, indext) {
                        final data = filteredproducts[indext];
                        if (!ProductList.productList.contains(data)) {
                          ProductList.productList.add(data);
                        }
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ProductDetail(data: data);
                              },
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 125,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 14),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.name!,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                            PopupMenuButton<SampleItem>(
                                              icon: Icon(
                                                Icons.more_horiz,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              initialValue: selectedMenu,
                                              onSelected: (SampleItem item) {
                                                if (item ==
                                                    SampleItem.itemOne) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Editproduct(
                                                              subcategoryId: widget
                                                                  .data
                                                                  .subcategoryId!,
                                                              data: data),
                                                    ),
                                                  );
                                                  print(data.id);
                                                } else if (item ==
                                                    SampleItem.itemTwo) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
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
                                                                
                                                                deleteproduct(
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
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
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
                                                  <PopupMenuEntry<SampleItem>>[
                                                const PopupMenuItem<SampleItem>(
                                                  value: SampleItem.itemOne,
                                                  child: Text('Edit'),
                                                ),
                                                const PopupMenuItem<SampleItem>(
                                                  value: SampleItem.itemTwo,
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          data.brand!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        // Text('Available Stock 12'),
                                        // SizedBox(
                                        //   height: 2,
                                        // ),
                                        Text(
                                          'Available stock: ${data.stock.toString()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            'Selling Rate: ₹${data.sellingprice.toString()}',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: filteredproducts.length,
                    ),
            ),
          ),
        );
      },
    );
  }
}
