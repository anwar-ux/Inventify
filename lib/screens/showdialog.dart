import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/category.dart';

class ProductSelectionDialog extends StatefulWidget {
  final Function(DataModel4)? onSave;

  const ProductSelectionDialog({Key? key, this.onSave}) : super(key: key);

  @override
  _ProductSelectionDialogState createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  String categorySearchText = '';
  String subcategorySearchText = '';
  String productSearchText = '';

  DataModel2? selectedCategory;
  DataModel3? selectedSubcategory;
  DataModel4? selectedProduct;
  TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.thirdcolor,
      ),
      backgroundColor: AppColors.thirdcolor,
      title: const Text(
        'Select Products',
        style: TextStyle(color: AppColors.secondaryColor),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(
                      color: AppColors.secondaryColor,
                    ),
                    onChanged: (value) {
                      setState(() {
                        categorySearchText = value;
                        if (value.isEmpty) {
                          selectedCategory = null;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search Category',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryColor,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<DataModel2>(
                    iconEnabledColor: AppColors.secondaryColor,
                    dropdownColor: AppColors.thirdcolor,
                    iconDisabledColor: AppColors.thirdcolor,
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubcategory = null;
                        selectedProduct = null;
                      });
                    },
                    items: CategoriesList.categories
                        .where((category) => category.name!
                            .toLowerCase()
                            .contains(categorySearchText.toLowerCase()))
                        .map((category) {
                      return DropdownMenuItem<DataModel2>(
                        value: category,
                        child: Text(
                          category.name!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // Subcategory Selection
              if (selectedCategory != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Subcategory',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                        color: AppColors.secondaryColor,
                      ),
                      onChanged: (value) {
                        setState(() {
                          subcategorySearchText = value;
                          if (value.isEmpty) {
                            selectedSubcategory = null;
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search Subcategory',
                        hintStyle: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.thirdcolor,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<DataModel3>(
                      iconEnabledColor: AppColors.secondaryColor,
                      dropdownColor: AppColors.thirdcolor,
                      iconDisabledColor: AppColors.thirdcolor,
                      value: selectedSubcategory,
                      onChanged: (value) {
                        setState(() {
                          selectedSubcategory = value;
                          selectedProduct = null;
                        });
                      },
                      items: getSubcategoriesForCategory(selectedCategory!)
                          .where((subcategory) => subcategory.name!
                              .toLowerCase()
                              .contains(
                                  subcategorySearchText.toLowerCase()))
                          .map((subcategory) {
                        return DropdownMenuItem<DataModel3>(
                          value: subcategory,
                          child: Text(
                            subcategory.name!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              // Product Selection
              if (selectedSubcategory != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Select Product',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(
                        color: AppColors.secondaryColor,
                      ),
                      onChanged: (value) {
                        setState(() {
                          productSearchText = value;
                          if (value.isEmpty) {
                            selectedProduct = null;
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                        hintText: 'Search Product',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.thirdcolor,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<DataModel4>(
                      iconEnabledColor: AppColors.secondaryColor,
                      dropdownColor: AppColors.thirdcolor,
                      iconDisabledColor: AppColors.thirdcolor,
                      value: selectedProduct,
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                        });
                      },
                      items: getProductsForSubcategory(
                        selectedSubcategory!,
                      )
                          .where((product) => product.name!
                              .toLowerCase()
                              .contains(
                                  productSearchText.toLowerCase()))
                          .map((product) {
                        return DropdownMenuItem<DataModel4>(
                          value: product,
                          child: Text(
                            product.name!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

              // Save Button
              const SizedBox(height: 15),
              if (selectedProduct != null)
                Form(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Add count';
                      }
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue == null) {
                        return 'Please enter a valid number';
                      }
                      if (selectedProduct!.stock == null) {
                        return 'Stock information is missing';
                      }
                      if (parsedValue > selectedProduct!.stock!) {
                        return 'Not enough stock';
                      }
                      if (parsedValue == 0) {
                        return 'Change count to save';
                      }
                      return null;
                    },
                    controller: countController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: AppColors.secondaryColor,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      hintText: 'count',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.secondaryColor),
                ),
                onPressed: () {
                  if (widget.onSave != null) {
                    selectedProduct!.count =
                        int.parse(countController.text);
                    widget.onSave!(selectedProduct!);
                  }
                  selectedCategory = null;
                  selectedSubcategory = null;
                  selectedProduct = null;
                  countController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: AppColors.thirdcolor),
                ),
              ),
            ],
          ),
        ),
      ),
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
}
