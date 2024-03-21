import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/allbills.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventify/screens/revenue.dart';
import 'package:inventify/screens/stockinfo.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int totalsoldproduct = 0;
  Map<String, int> sortedProductMap = {};
  List<Color> pieColors = [];
  String mostSoldProductName = '';
  int mostSoldProductcount = 0;
  Map<String, int> sortedtotal = {};
  int alltotalPrice = 0;
  int todayRevenue = 0; // Added variable for today's revenue
  final ScrollController _controller = ScrollController();
  int currentIndex = 0;
  bool reverse = false;
  @override
  void initState() {
    super.initState();
    Hive.openBox<Bill>('bill_db');
    loadData();
    setState(() {});
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        if (currentIndex < sortedProductMap.length - 1 && !reverse) {
          currentIndex++;
        } else if (currentIndex > 0 && reverse) {
          currentIndex--;
        } else {
          reverse = !reverse;
          currentIndex = reverse ? sortedProductMap.length - 1 : 0;
        }
        _controller.animateTo(
          currentIndex * 330.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> loadData() async {
    await getAllbill();
    await getAllproduct();
    await totalProductsSold();
    await sortedProductCounts();
    await getTotalPrice();
    await getTotalPriceByDay();
    generatePieSections();
    await getTodayRevenue(); // Calculate today's revenue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INVENTIFY'),
        titleTextStyle: TextStyle(
          fontFamily: Appfont.primaryFont,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RevenueScreen(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    // Today's Revenue
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Today\'s Revenue: ₹$todayRevenue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Total revenue of the shop ₹${alltotalPrice.toString()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 165,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.15,
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Most Sold Product',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$mostSoldProductName ($mostSoldProductcount)',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Total Products Sold',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$totalsoldproduct',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Total Customers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  '${billListNotifier.value.length}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Billlist(),
                            ),
                          );
                        },
                        child:ValueListenableBuilder<List<Bill>>(
  valueListenable: billListNotifier,
  builder: (context, billList, _) {
    if (billList.isEmpty) {
      return Container(); // Empty container when there are no bills
    } else {
      // Retrieve the last bill in the list
      final lastBill = billList.last;
      
      // Example: accessing customer phone number and product details
      final customerPhoneNumber = lastBill.phone;
      final productDetails = lastBill.totalprice;

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.3,
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recent Bill',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Customer Phone:\n   $customerPhoneNumber',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Total price: $productDetails',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  },
)


                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StockDetailsPage()));
                    },
                    child: Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check Stock Availability',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.event_available_rounded,
                              color: Theme.of(context).colorScheme.background,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Top 5 Most Selling Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                child: Row(
                  children: List.generate(
                    sortedProductMap.length,
                    (index) {
                      // Display the top 5 sold products horizontally
                      if (index < 5) {
                        var productName =
                            sortedProductMap.keys.elementAt(index);
                        var productCount =
                            sortedProductMap.values.elementAt(index);

                        // Find the product in the product list notifier
                        var product = productsListNotifier.value.firstWhere(
                          (product) => product.name == productName,
                        );

                        // Get the image string if the product exists
                        String productImageString = product.image!;

                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: 320,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Container(
                                    height:
                                        200, // Height of the product container
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: productImageString != null
                                          ? DecorationImage(
                                              image: FileImage(
                                                  File(productImageString)),
                                              fit: BoxFit.cover,
                                            )
                                          : null, // Use default image if product image string is not available
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                              height:
                                                  10), // Spacer for product image
                                          // Display product name
                                          Text(
                                            productName,
                                            style: const TextStyle(
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          // Display product count
                                          Text(
                                            '$productCount',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      } else {
                        return const SizedBox(); // Empty container for additional items
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> generatePieSections() {
    List<PieChartSectionData> sections = [];
    int index = 0;

    // Iterate through the sorted product map and take only the top 5 entries
    sortedProductMap.entries.take(5).forEach((entry) {
      double normalizedValue =
          entry.value / totalsoldproduct; // Normalize the value
      pieColors
          .add(generateRandomColor()); // Add a random color for each section
      sections.add(
        PieChartSectionData(
          color: pieColors.last,
          value: normalizedValue,
          title: entry.key,
          radius: 55, // Adjust the radius as needed
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.thirdcolor,
          ),
        ),
      );

      // Set the mostSoldProductName to the first product name
      setState(() {
        if (index == 0) {
          mostSoldProductName = entry.key;
          mostSoldProductcount = entry.value;
        }
      });
      index++;
    });

    // Add an "Other" section for remaining products if any
    if (sortedProductMap.length > 5) {
      double otherValue =
          1.0 - sections.fold(0.0, (sum, section) => sum + section.value);
      // ignore: unused_local_variable
      int otherCount = (otherValue * totalsoldproduct).toInt();
      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: otherValue,
          title: 'Other',
          radius: 62, // Adjust the radius as needed
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.thirdcolor,
          ),
        ),
      );
    }

    return sections;
  }

  Color generateRandomColor() {
    // Generate random color with lighter tones
    int red = Random().nextInt(128) + 128; // 128 to 255
    int green = Random().nextInt(128) + 128; // 128 to 255
    int blue = Random().nextInt(128) + 128; // 128 to 255

    return Color.fromARGB(255, red, green, blue);
  }

  Future<int> totalProductsSold() async {
    final List<Bill> soldProducts = billListNotifier.value;
    totalsoldproduct = soldProducts.fold(0, (sum, product) {
      for (int i = 0; i < product.count.length; i++) {
        sum += int.parse(product.count[i]);
      }
      return sum;
    });
    print('Total Products Sold: $totalsoldproduct');
    return totalsoldproduct;
  }

  Future<Map<String, int>> sortedProductCounts() async {
    final List<Bill> products = billListNotifier.value;
    Map<String, int> productCountMap = {};

    for (Bill product in products) {
      for (int i = 0; i < product.productname.length; i++) {
        String productName = product.productname[i];
        int productCount = int.parse(product.count[i]);
        productCountMap[productName] =
            (productCountMap[productName] ?? 0) + productCount;
      }
    }

    sortedProductMap = SplayTreeMap<String, int>.from(productCountMap, (a, b) {
      return productCountMap[b]!.compareTo(productCountMap[a]!);
    });
    print(sortedProductMap);
    return sortedProductMap;
  }

  Future<int> getTotalPrice() async {
    final List<Bill> products = billListNotifier.value;
    int total = 0;

    for (Bill product in products) {
      int totalPrice = product.totalprice ?? 0;
      alltotalPrice = total += totalPrice;
    }
    print('Total Price: $total');
    return total;
  }

  Future<Map<DateTime, int>> getTotalPriceByDay() async {
    final List<Bill> products = billListNotifier.value;
    Map<DateTime, int> dailyTotalMap = {};

    for (Bill product in products) {
      // Assuming product.date is a String representing the date
      String dateString =
          product.date ?? ''; // Make sure to handle null values appropriately
      DateTime date = DateTime.tryParse(dateString) ??
          DateTime.now(); // Parse the date string

      int totalPrice = product.totalprice ?? 0;
      dailyTotalMap[date] = (dailyTotalMap[date] ?? 0) + totalPrice;
    }

    // Sorting the map by date
    Map<DateTime, int> sortedDailyTotal = Map.fromEntries(
      dailyTotalMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    print('Total Price by Day: $sortedDailyTotal');
    return sortedDailyTotal;
  }

  Future<int> getTodayRevenue() async {
    final List<Bill> products = billListNotifier.value;
    DateTime today = DateTime.now();
    int totalRevenue = 0;

    for (Bill product in products) {
      // Assuming product.date is a String representing the date
      String dateString = product.date ?? '';
      DateTime date = DateTime.tryParse(dateString) ?? DateTime.now();

      if (date.year == today.year &&
          date.month == today.month &&
          date.day == today.day) {
        totalRevenue += product.totalprice ?? 0;
      }
    }

    setState(() {
      todayRevenue = totalRevenue;
    });

    print('Today\'s Revenue: $totalRevenue');
    return totalRevenue;
  }
}
