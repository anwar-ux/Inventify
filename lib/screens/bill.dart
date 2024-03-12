import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/showdialog.dart';

class Billsection extends StatefulWidget {
  const Billsection({Key? key}) : super(key: key);

  @override
  BillsectionState createState() => BillsectionState();
}

class Listproduct {
  static List<DataModel4> listproduct = [];
}

class BillsectionState extends State<Billsection> {
  List<DataModel2> categories = [];
  List<DataModel3> subcategories = [];
  List<DataModel4> products = [];
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  var discountcontroller = TextEditingController();
  var pricecontroller = TextEditingController();
  int totalPrice = 0;
  int? productPrice;
  int? price;
  DateTime dateTime = DateTime.now();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode disFocusNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DataModel2? selectedCategory;
  DataModel3? selectedSubcategory;
  DataModel4? selectedProduct;

  @override
  void initState() {
    super.initState();
    getAllproduct();
    selectedCategory = null;
    selectedSubcategory = null;
    //selectedProduct = null;

    if (discountcontroller.text.isEmpty) {
      discountcontroller.text = '0';
    }
    Listproduct.listproduct.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Section'),
        titleTextStyle: const TextStyle(
          fontFamily: Appfont.primaryFont,
          color: AppColors.thirdcolor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onsave();

                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.save, color: AppColors.thirdcolor),
          )
        ],
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            nameFocusNode.unfocus();
            phoneFocusNode.unfocus();
            disFocusNode.unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: AppColors.primaryColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final data = Listproduct.listproduct[index];
                      productPrice = data.sellingprice;
                      calculateTotalPrice();

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Dismissible(
                          key: Key(data.id.toString()),
                          onDismissed: (direction) {
                            setState(() {
                              Listproduct.listproduct.removeAt(index);
                              calculateTotalPrice();
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${data.name!} ${data.brand} ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.thirdcolor,
                                ),
                              ),
                              Text(
                                ' ${data.sellingprice.toString()}  x ${data.count}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.thirdcolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: Listproduct.listproduct.length,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: nameFocusNode,
                          cursorColor: AppColors.thirdcolor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (RegExp(r'\d').hasMatch(value!)) {
                              return 'Numbers are not allowed';
                            }
                            if (RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return 'Special characters are not allowed';
                            }
                            return null;
                          },
                          controller: namecontroller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            label: Text(
                              'Customer name (Optional)',
                              style: TextStyle(color: AppColors.thirdcolor),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          focusNode: phoneFocusNode,
                          cursorColor: AppColors.thirdcolor,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone required';
                            }
                            if (value.length < 10 || value.length > 10) {
                              return 'Only 10 digits allowed';
                            }
                            return null;
                          },
                          controller: phonecontroller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            label: Text(
                              'Customer phone',
                              style: TextStyle(color: AppColors.thirdcolor),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(width: 20),
                        TextFormField(
                          focusNode: disFocusNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            try {
                              final discount = int.parse(value.toString());
                              if (price! <= discount) {
                                return 'change discount price';
                              }
                            } catch (e) {
                              return 'Invalid number';
                            }

                            return null;
                          },
                          cursorColor: AppColors.thirdcolor,
                          onChanged: (value) {
                            setState(() {
                              calculateTotalPrice();
                            });
                          },
                          keyboardType: TextInputType.number,
                          controller: discountcontroller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.thirdcolor,
                              ),
                            ),
                            label: Text(
                              'Discount price',
                              style: TextStyle(color: AppColors.thirdcolor),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 130,
                          child: Column(
                            children: [
                              const Divider(
                                color: AppColors.thirdcolor,
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total price',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.thirdcolor),
                                  ),
                                  Text(
                                    '₹ $totalPrice',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.thirdcolor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.thirdcolor,
        onPressed: _showProductSelectionDialog,
        child: const Icon(
          Icons.add,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  void _showProductSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProductSelectionDialog(
          onSave: (selectedProduct) {
            Listproduct.listproduct.add(selectedProduct);
            selectedCategory = null;
            selectedSubcategory = null;
            products = [];
            // Navigator.pop(context);
            calculateTotalPrice();
            price = totalPrice;
          },
        );
      },
    );
  }

  List<DataModel3> getSubcategoriesForCategory(DataModel2 category) {
    List<DataModel3> filteredSubcategories = subcategoryListNotifier.value
        .where((subCategory) => subCategory.categoryId == category.categoryId)
        .toList();

    return filteredSubcategories;
  }

  List<DataModel4> getProductsForSubcategory(DataModel3 subcategory) {
    List<DataModel4> filteredProducts = productsListNotifier.value
        .where((product) => product.subcategoryId == subcategory.subcategoryId)
        .toList();

    return filteredProducts;
  }

  void calculateTotalPrice() {
    totalPrice = 0;
    for (var product in Listproduct.listproduct) {
      totalPrice += (product.sellingprice! * product.count!);
    }
    try {
      if (discountcontroller.text.isNotEmpty) {
        final discount = int.parse(discountcontroller.text);
        totalPrice -= discount;
      }
    } catch (e) {
      print('Discount parsing error: $e');
    }
  }

  Future<void> onsave() async {
    final phone = phonecontroller.text.trim();
    final List<DataModel4> selectedProductsprice = Listproduct.listproduct;
    final total = totalPrice;
    final category = selectedCategory?.name;
    final subcategory = selectedSubcategory?.name;
    final List<DataModel4> selectedProducts = Listproduct.listproduct;
    final customername = namecontroller.text.trim();
    final discount = discountcontroller.text.trim();
    final List<DataModel4> selectedproductcount = Listproduct.listproduct;
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    String date = dateOnly.toLocal().toString().split(' ')[0];
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String time = '$hour : $minute';
    final List<String> productNames =
        selectedProducts.map((product) => product.name!).toList();
    final List<String> productprice = selectedProductsprice
        .map((product) => product.sellingprice.toString())
        .toList();
    final List<String> productcount = selectedproductcount
        .map((product) => product.count.toString())
        .toList();
    final List<int> countValues = productcount.map(int.parse).toList();
    final int sumProductCount =
        countValues.fold(0, (sum, value) => sum + value);

    final data = Bill(
        phone: phone,
        sellingprice: productprice,
        totalprice: total,
        customername: customername,
        discountprice: int.parse(discount),
        productcategory: category,
        productsubcategory: subcategory,
        productname: productNames,
        count: productcount,
        date: date,
        time: time,
        totalproductsold: sumProductCount);
    addbill(data);
    for (var product in selectedProducts) {
      final bool productExists =
          productsListNotifier.value.any((p) => p.id == product.id);
      if (productExists) {
        // Subtract the sold quantity from the existing stock
        final existingProduct =
            productsListNotifier.value.firstWhere((p) => p.id == product.id);
        print('Product: ${product.name}, Sold Stock: ${product.count}');
        print(
            'Existing Product: ${existingProduct.name}, Existing Stock: ${existingProduct.stock}');
        // Ensure stock is not null
        existingProduct.stock = (existingProduct.stock ?? 0);
        // Calculate the new stock value based on the difference
        int newStock = existingProduct.stock! - product.count!;
        // Ensure stock doesn't go below zero
        existingProduct.stock = newStock.clamp(0, double.infinity).toInt();
        print('Updated Stock: ${existingProduct.stock}');
        // Update the product in the list
        final int existingProductIndex =
            productsListNotifier.value.indexWhere((p) => p.id == product.id);
        productsListNotifier.value[existingProductIndex] = existingProduct;
        editproduct(existingProduct.id!, existingProduct);
      }
    }
  }
}
