import 'package:flutter/material.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';

class StockDetailsPage extends StatefulWidget {
  const StockDetailsPage({Key? key}) : super(key: key);

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  List<DataModel4> products = [];
  List<DataModel4> mostAvailableStock = [];
  List<DataModel4> stockGoingOut = [];
  List<DataModel4> stockZero = [];

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  Future<void> getAllProducts() async {
    // Assume productsListNotifier.value returns a list of products
    products = productsListNotifier.value;
    categorizeProducts();
  }

  void categorizeProducts() {
    // Reset lists
    mostAvailableStock = [];
    stockGoingOut = [];
    stockZero = [];

    // Categorize products
    for (var product in products) {
      if (product.stock == null || product.stock == 0) {
        stockZero.add(product);
      } else if (product.stock! >= 5) {
        mostAvailableStock.add(product);
      } else {
        stockGoingOut.add(product);
      }
    }

    setState(() {});
  }

  Widget buildProductCard(List<DataModel4> productList, String cardTitle,Color titlecolor) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingInternal(cardTitle, titlecolor),
          SizedBox(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return ListTile(
                  title: Text('Product Name: ${product.name}',style: TextStyle(color: Theme.of(context).colorScheme.background,),),
                  subtitle: Text('Stock: ${product.stock}',style: TextStyle(color: Theme.of(context).colorScheme.background,)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Details'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        toolbarHeight: 70,
        actionsIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Column(
        children: [
          //  Head Stock Out
          Expanded(
            child: buildProductCard(
              stockZero,
              'Stock Out',
              Colors.red
            ),
          ),
          // Stock Going Out Card
          Expanded(
            child: buildProductCard(
              stockGoingOut,
              'Stock Going Out',
              const Color.fromARGB(255, 227, 208, 33)
            ),
          ),
 // Most Available Stock Card
          Expanded(
            child: buildProductCard(
              mostAvailableStock,
              'Most Available Stock',
              Colors.green,
              
            ),
          ),
          
        ],
      ),
    );
  }
}

class CardHeading extends StatelessWidget {
  final String heading;
  final Color headingColor;

  const CardHeading({required this.heading, required this.headingColor});

  @override
  Widget build(BuildContext context) {
    return buildHeadingInternal(heading, headingColor);
  }
   
}
Widget buildHeadingInternal(String heading, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }