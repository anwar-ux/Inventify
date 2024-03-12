// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inventify/db/dbmodel.dart';

//user data
ValueNotifier<List<DataModel>> dataListNotifier =
    ValueNotifier<List<DataModel>>([]);

class IDGeneratoruser {
  static const String _counterBoxKey = 'counterBoxKey';
  static late Box<int> _counterBox;

  // Initialize the counter using the stored value or default to 0
  static int _counter = _counterBox.get('counter') ?? 0;

  static Future<void> initialize() async {
    // Open the counter box
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
  }

  static int generateUniqueID() {
    final generatedID = _counter++;

    // Store the updated counter in the box
    _counterBox.put('counter', _counter);

    return generatedID;
  }
}

Future<void> adddata(DataModel value) async {
  try {
    await IDGeneratoruser.initialize();

    final allDB = await Hive.openBox<DataModel>('Inventify_db');

    final id =IDGeneratoruser.generateUniqueID();

    value.id = id;

    final addedId = await allDB.add(value);

    if (addedId != null) {
      dataListNotifier.value = [...dataListNotifier.value, value];
      dataListNotifier.notifyListeners();
    } else {
      print('Error: Added ID is null.');
    }
  } catch (e) {
    print('Error adding data: $e');
  }
}

Future<void> getAlldata() async {
  try {
    // Initialize Hive
    WidgetsFlutterBinding.ensureInitialized();

    // Open the Hive box
    final allDB = await Hive.openBox<DataModel>('Inventify_db');

    // Retrieve data from the box
    final dataList = List<DataModel>.from(allDB.values);

    if (dataList.isNotEmpty && dataList.every((data) => data.id != null)) {
      dataListNotifier.value = [...dataList];
      dataListNotifier.notifyListeners();
      print("Data loaded successfully");
    } else {
      print('No valid data found');
    }
  } catch (e) {
    print('Error getting data: $e');
  }
}

Future<void> delete(int id) async {
  final allDB = await Hive.openBox<DataModel>('Inventify_db');
  allDB.delete(id);
  await allDB.close();
}

Future<void> editData(int id, DataModel updatedData) async {
  try {
    final allDB = await Hive.openBox<DataModel>('Inventify_db');
    final existingData = allDB.get(id);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.uname = updatedData.uname;
      existingData.email = updatedData.email;
      existingData.password = updatedData.password;
      existingData.image = updatedData.image;

      await allDB.put(id, existingData);

      int index = dataListNotifier.value.indexWhere((data) => data.id == id);
      if (index != -1) {
        dataListNotifier.value[index] = existingData;
        dataListNotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

//cata

ValueNotifier<List<DataModel2>> dataListNotifier2 =
    ValueNotifier<List<DataModel2>>([]);

class IDGenerator {
  static const String _counterBoxKey = 'counterBoxKey';
  static late Box<int> _counterBox;

  // Initialize the counter using the stored value or default to 0
  static int _counter = _counterBox.get('counter') ?? 0;

  static Future<void> initialize() async {
    // Open the counter box
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
  }

  static int generateUniqueID() {
    final generatedID = _counter++;

    // Store the updated counter in the box
    _counterBox.put('counter', _counter);

    return generatedID;
  }
}

Future<void> adddetails(DataModel2 value) async {
  try {
    // Initialize the IDGenerator once at the application startup
    await IDGenerator.initialize();

    final allDB2 = await Hive.openBox<DataModel2>('Inventify_db2');

    // Generate a unique ID using the updated IDGenerator
    int id2 = IDGenerator.generateUniqueID();

    value.id = id2; // Set the id2 property
    print('Generated ID: $id2');

    final categoryId = DateTime.now().millisecondsSinceEpoch;
    value.categoryId = categoryId;

    final addedId = await allDB2.add(value);

    if (addedId != null) {
      print('Generated Category ID: $categoryId');
      dataListNotifier2.value = [...dataListNotifier2.value, value];
      dataListNotifier2.notifyListeners();
    } else {
      print('Error: Added ID is null.');
    }
  } catch (e) {
    print('Error adding data: $e');
  }
}

Future<void> getAlldetails() async {
  try {
    // Initialize Hive
    WidgetsFlutterBinding.ensureInitialized();

    // Open the Hive box
    final allDB = await Hive.openBox<DataModel2>('Inventify_db2');

    // Retrieve data from the box
    final dataList = List<DataModel2>.from(allDB.values);

    if (dataList.isNotEmpty && dataList.every((data) => data.id != null)) {
      dataListNotifier2.value = [...dataList];
      dataListNotifier2.notifyListeners();
      print("Data loaded successfully");
    } else {
      print('No valid data found');
    }
  } catch (e) {
    print('Error getting data: $e');
  }
}

Future<void> editdetails(int id2, DataModel2 updatedData) async {
  try {
    final allDB2 = await Hive.openBox<DataModel2>('Inventify_db2');
    final existingData = allDB2.get(id2);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.name = updatedData.name;
      existingData.description = updatedData.description;
      existingData.image = updatedData.image;

      await allDB2.put(id2, existingData);

      // Update dataListNotifier2 after editing
      int index = dataListNotifier2.value.indexWhere((data) => data.id == id2);
      if (index != -1) {
        dataListNotifier2.value[index] = existingData;
        dataListNotifier2.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

Future<void> delete2(int id2) async {
  try {
    final allDB2 = await Hive.openBox<DataModel2>('Inventify_db2');

    // Delete data using the correct ID
    await allDB2.delete(id2);

    // Update dataListNotifier2 after deleting
    dataListNotifier2.value =
        dataListNotifier2.value.where((data) => data.id != id2).toList();
    dataListNotifier2.notifyListeners();
  } catch (e) {
    print('Error deleting item: $e');
  }
}

//SUB

ValueNotifier<List<DataModel3>> subcategoryListNotifier = ValueNotifier([]);

class IDGenerator2 {
  static const String _counterBoxKey = 'counterBoxKey2';
  static late Box<int> _counterBox;

  // Initialize the counter using the stored value or default to 0
  static int _counter = _counterBox.get('counter') ?? 0;

  static Future<void> initialize() async {
    // Open the counter box
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
  }

  static int generateUniqueID() {
    final generatedID = _counter++;

    // Store the updated counter in the box
    _counterBox.put('counter', _counter);

    return generatedID;
  }
}

Future<void> addSubcategory(DataModel3 value, int categoryId) async {
  try {
    // Initialize IDGenerator2 once at the application startup
    await IDGenerator2.initialize();

    final subcategoryBox = await Hive.openBox<DataModel3>('Subcategories_db');
    int id = IDGenerator2.generateUniqueID();
    print('Generated ID: $id');
    value.id = id;

    final subcategoryId = DateTime.now().microsecondsSinceEpoch;
    value.subcategoryId = subcategoryId;

    final addedId = await subcategoryBox.add(value);

    if (addedId != null) {
      value.categoryId = categoryId;
      subcategoryListNotifier.value = [...subcategoryListNotifier.value, value];
      subcategoryListNotifier.notifyListeners();
    } else {
      print('Error: Generated ID is null.');
    }
  } catch (e) {
    print('Error adding subcategory: $e');
  }
}

Future<void> getAllSubcategory() async {
  try {
    // Initialize Hive
    WidgetsFlutterBinding.ensureInitialized();

    // Open the Hive box
    final allDB = await Hive.openBox<DataModel3>('Subcategories_db');

    // Retrieve data from the box
    final dataList = List<DataModel3>.from(allDB.values);

    if (dataList.isNotEmpty && dataList.every((data) => data.id != null)) {
      subcategoryListNotifier.value = [...dataList];
      subcategoryListNotifier.notifyListeners();
      print("Data loaded successfully");
    } else {
      print('No valid data found');
    }
  } catch (e) {
    print('Error getting data: $e');
  }
}

Future<void> deleteSubcategory(int id) async {
  try {
    final subcategoryBox = await Hive.openBox<DataModel3>('Subcategories_db');
    await subcategoryBox.delete(id);
    // Close the box after deletion
    await subcategoryBox.close();
    subcategoryListNotifier.value =
        subcategoryListNotifier.value.where((data) => data.id != id).toList();
    subcategoryListNotifier.notifyListeners();
  } catch (e) {
    print('Error deleting subcategory: $e');
  }
}

Future<void> editSubcategory(int id2, DataModel3 updatedData) async {
  try {
    final allDB2 = await Hive.openBox<DataModel3>('Subcategories_db');
    final existingData = allDB2.get(id2);
    print('hai');
    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.name = updatedData.name;
      existingData.description = updatedData.description;
      existingData.image = updatedData.image;

      await allDB2.put(id2, existingData);
      print('hello');
      // Update dataListNotifier2 after editing
      int index = dataListNotifier2.value.indexWhere((data) => data.id == id2);
      if (index != -1) {
        subcategoryListNotifier.value[index] = existingData;
        subcategoryListNotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

//product

ValueNotifier<List<DataModel4>> productsListNotifier = ValueNotifier([]);

class IDGenerator3 {
  static const String _counterBoxKey = 'counterBoxKey3';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

Future<void> addproduct(DataModel4 value, int subcategoryId) async {
  try {
    await IDGenerator3.initialize();
    final productBox = await Hive.openBox<DataModel4>(
        'Products_db'); // Use a different name for the box
    int id = IDGenerator3.generateUniqueID();

    value.id = id;
    value.subcategoryId = subcategoryId;
    final addedid = productBox.add(value);
    print('Generated ID: $id');

    if (addedid != null) {
      productsListNotifier.value = [...productsListNotifier.value, value];
      subcategoryListNotifier.notifyListeners();
    } else {
      print('Error: Generated ID is null.');
    }
  } catch (e) {
    print('Error adding subcategory: $e');
  }
}

Future<void> getAllproduct() async {
  try {
    final productBox =
        await Hive.openBox<DataModel4>('Products_db'); // Use the same box name
    final subcategoryList = List<DataModel4>.from(productBox.values);

    productsListNotifier.value = [...subcategoryList];
    productsListNotifier.notifyListeners();
  } catch (e) {
    print('Error opening subcategory Hive box: $e');
  }
}

Future<void> deleteproduct(int id) async {
  try {
    final productBox = await Hive.openBox<DataModel4>('Products_db');
    await productBox.delete(id);
    await productBox.close();
    getAllproduct();
  } catch (e) {
    print('Error deleting subcategory: $e');
  }
}

Future<void> editproduct(int id2, DataModel4 updatedData) async {
  try {
    final productBox = await Hive.openBox<DataModel4>('Products_db');
    print(id2);
    final existingData = productBox.get(id2);

    if (existingData != null) {
      print('Updated Data Before Editing: $existingData');
      print('Updated Data: $updatedData');

      existingData.name = updatedData.name;
      existingData.description = updatedData.description;
      existingData.image = updatedData.image;
      existingData.brand = updatedData.brand;
      existingData.purchaseprice = updatedData.purchaseprice;
      existingData.sellingprice = updatedData.sellingprice;
      existingData.stock = updatedData.stock;
      await productBox.put(id2, existingData);
      print('hello');
      // Update dataListNotifier2 after editing
      int index =
          productsListNotifier.value.indexWhere((data) => data.id == id2);
      if (index != -1) {
        productsListNotifier.value[index] = existingData;
        productsListNotifier.notifyListeners();
      }
    }
  } catch (e) {
    print('Error editing data: $e');
  }
}

ValueNotifier<List<Bill>> billListNotifier = ValueNotifier([]);

class IDGeneratorbill {
  static const String _counterBoxKey = 'counterBoxKey4';
  static late Box<int> _counterBox;
  static int _counter = 0;

  static Future<void> initialize() async {
    _counterBox = await Hive.openBox<int>(_counterBoxKey);
    _counter = _counterBox.get('counter') ?? 0;
  }

  static int generateUniqueID() {
    final generatedID = _counter++;
    _counterBox.put('counter', _counter);
    return generatedID;
  }
}

Future<void> addbill(Bill value) async {
  try {
    await IDGeneratorbill.initialize();
    final productBox =
        await Hive.openBox<Bill>('bill_db'); // Use a different name for the box
    int id = IDGeneratorbill.generateUniqueID();

    value.id = id;
    final addedid = productBox.add(value);
    print('Generated ID: $id');

    if (addedid != null) {
      billListNotifier.value = [...billListNotifier.value, value];
      billListNotifier.notifyListeners();
    } else {
      print('Error: Generated ID is null.');
    }
  } catch (e) {
    print('Error adding subcategory: $e');
  }
}

Future<void> deletebill(int id) async {
  try {
    final billBox = await Hive.openBox<Bill>('bill_db');
    await billBox.delete(id);
    // Close the box after deletion
    await billBox.close();
    // Fetch the updated list after deletion
    getAllbill();
  } catch (e) {
    print('Error deleting subcategory: $e');
  }
}

Future<void> getAllbill() async {
  try {
    final billBox =
        await Hive.openBox<Bill>('bill_db'); // Use the same box name
    final billList = List<Bill>.from(billBox.values);

    billListNotifier.value = [...billList];
    billListNotifier.notifyListeners();
  } catch (e) {
    print('Error opening subcategory Hive box: $e');
  }
}
