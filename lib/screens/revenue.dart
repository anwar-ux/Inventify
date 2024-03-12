import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';
import 'package:inventify/screens/allbills.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueDetails {
  late DateTime date;
  late int totalRevenue;

  RevenueDetails({required this.date, required this.totalRevenue});
}

List<FlSpot> generateLineChartData(List<RevenueDetails> revenueDetailsList) {
  return List.generate(
    revenueDetailsList.length,
    (index) => FlSpot(
      index.toDouble(),
      revenueDetailsList[index].totalRevenue.toDouble(),
    ),
  );
}

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  List<RevenueDetails> revenueDetailsList = [];
  bool sortByDay = true; // Default to sorting by day

  @override
  void initState() {
    super.initState();
    getAllRevenues();
  }

  Future<void> getAllRevenues() async {
    final List<Bill> bills = billListNotifier.value;

    Map<DateTime, int> revenueMap = {};

    for (Bill bill in bills) {
      DateTime date = DateTime.tryParse(bill.date ?? '') ?? DateTime.now();
      int totalRevenue = bill.totalprice ?? 0;

      if (sortByDay) {
        // Sort by day
        revenueMap[date] = (revenueMap[date] ?? 0) + totalRevenue;
      } else {
        // Sort by month
        DateTime monthStart = DateTime(date.year, date.month, 1);
        revenueMap[monthStart] = (revenueMap[monthStart] ?? 0) + totalRevenue;
      }
    }

    setState(() {
      revenueDetailsList = revenueMap.entries
          .map((entry) =>
              RevenueDetails(date: entry.key, totalRevenue: entry.value))
          .toList();

      // Print the details of each RevenueDetails instance
      for (var revenueDetails in revenueDetailsList) {
        print(
            'Date: ${revenueDetails.date}, Total Revenue: ${revenueDetails.totalRevenue}');
      }
    });
  }

  void openSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by Day'),
                onTap: () {
                  setState(() {
                    sortByDay = true;
                    getAllRevenues();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Month'),
                onTap: () {
                  setState(() {
                    sortByDay = false;
                    getAllRevenues();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Revenues'),
            SizedBox(
              height: 3,
            ),
          ],
        ),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              openSortOptions(context);
            },
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            height: 200,
            margin: const EdgeInsets.all(14),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: revenueDetailsList.length.toDouble() - 1,
                minY: 0,
                maxY: revenueDetailsList.isEmpty
                    ? 0
                    : revenueDetailsList
                        .map((e) => e.totalRevenue.toDouble())
                        .reduce(
                            (max, element) => max > element ? max : element),
                lineBarsData: [
                  LineChartBarData(
                    spots: generateLineChartData(revenueDetailsList),
                    isCurved: true,
                    colors: [
                      const Color(0xff4af699),
                    ],
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: true, colors: [
                      const Color(0xff4af699).withOpacity(0.5),
                      const Color(0xff4af699).withOpacity(0.1),
                    ]),
                    aboveBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          // Add the rest of your list here
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: revenueDetailsList.isEmpty
                  ? Center(
                      child: Text('No Revenue details available',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15,
                          )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 13,
                        right: 13,
                        left: 13,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: revenueDetailsList.length,
                        itemBuilder: (context, index) {
                          final revenueDetails = revenueDetailsList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Billlist(
                                      selectedDate: revenueDetails.date,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Date: ${DateFormat('dd-MM-yyy').format(revenueDetails.date)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'PlayfairDisplay',
                                          ),
                                        ),
                                        Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                        Text(
                                          'Total Revenue: ₹${revenueDetails.totalRevenue}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
