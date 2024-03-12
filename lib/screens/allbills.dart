import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/db.dart';
import 'package:inventify/db/dbmodel.dart';

class Billlist extends StatefulWidget {
  final DateTime? selectedDate;

  const Billlist({Key? key, this.selectedDate}) : super(key: key);

  @override
  _BilllistState createState() => _BilllistState();
}

class _BilllistState extends State<Billlist> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: billListNotifier,
      builder: (BuildContext ctx, List<Bill> updatedList, Widget? child) {
        // Filter bills based on the selected date
        List<Bill> filteredList = widget.selectedDate != null
    ? updatedList.where((bill) {
        DateTime billDate =
            DateTime.tryParse(bill.date ?? '') ?? DateTime.now();
        return isSameDay(billDate, widget.selectedDate!);
      }).toList()
    : updatedList;

// Sort the filtered list by month and year
// Sort the filtered list by month and year
filteredList.sort((a, b) {
  DateTime dateA = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
  DateTime dateB = DateTime.tryParse(b.date ?? '') ?? DateTime.now();

  if (dateA.year != dateB.year) {
    return dateA.year.compareTo(dateB.year);
  } else if (dateA.month != dateB.month) {
    return dateA.month.compareTo(dateB.month);
  } else {
    return dateA.day.compareTo(dateB.day);
  }
});


        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bills'),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
            titleTextStyle:  TextStyle(
              fontFamily: Appfont.primaryFont,
              color:  Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.background,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color:  Theme.of(context).colorScheme.background,
              child: filteredList.isEmpty
                  ?  Center(
                      child: Text(
                        'No Bills available',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 13,
                        right: 13,
                        left: 13,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final data = filteredList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Dismissible(
                              key: Key(data.id.toString()),
                              background: buildSwipeBackground(),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Confirmation'),
                                      content: const Text(
                                        'Are you sure you want to delete this?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            if (data.id != null) {
                                              deletebill(data.id!);
                                              setState(() {
                                                updatedList.removeAt(index);
                                              });
                                              Navigator.pop(context, true);
                                            } else {
                                              print("Data.id is null");
                                              Navigator.pop(context, false);
                                            }
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                // Handle dismiss
                                setState(() {
                                  // Handle the deletion logic here if needed
                                });
                              },
                              child: GestureDetector(
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
                                            'Customer',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.background,
                                              fontSize: 18,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'PlayfairDisplay',
                                            ),
                                          ),
                                           Divider(
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (data.customername != null)
                                                Row(
                                                  children: [
                                                     Icon(Icons
                                                        .person_2_outlined,
                                                        color:  Theme.of(context).colorScheme.background,),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      data.customername
                                                          .toString(),
                                                      style:  TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context).colorScheme.background,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              if (data.date != null)
                                                Row(
                                                  children: [
                                                     Icon(
                                                      Icons.date_range_outlined,
                                                      size: 17,
                                                      color:  Theme.of(context).colorScheme.background,
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(data.date.toString(),
                                                    style: TextStyle(color:  Theme.of(context).colorScheme.background,),),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                   Icon(
                                                      Icons.phone_outlined,
                                                      color:  Theme.of(context).colorScheme.background,),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    data.phone.toString(),
                                                    style:  TextStyle(
                                                      fontSize: 16,
                                                      color:  Theme.of(context).colorScheme.background,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(data.time.toString(),style: TextStyle(color:  Theme.of(context).colorScheme.background,),),
                                            ],
                                          ),
                                           Divider(
                                            color:  Theme.of(context).colorScheme.background,
                                          ),
                                           Text(
                                            'Products :',
                                            style: TextStyle(
                                              color:  Theme.of(context).colorScheme.background,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'PlayfairDisplay',
                                              fontSize: 16,
                                            ),
                                          ),
                                           Divider(
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                          for (int i = 0;
                                              i < data.productname.length;
                                              i++)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.productname[i],
                                                    style:  TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 18,
                                                      color:  Theme.of(context).colorScheme.background,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${data.count[i]} x ${data.sellingprice[i]} '
                                                        .toString(),
                                                    style:  TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 16,
                                                      color:  Theme.of(context).colorScheme.background,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const Divider(
                                            color: AppColors.secondaryColor,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                               Text(
                                                'Discount price:',
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'PlayfairDisplay',
                                                  color:  Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                              Text(
                                                '- ${data.discountprice.toString()} ',
                                                style:  TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color:  Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                               Text(
                                                'Total price: ',
                                                style: TextStyle(
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'PlayfairDisplay',
                                                  fontSize: 18,
                                                  color:  Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                              Text(
                                                data.totalprice.toString(),
                                                style:  TextStyle(
                                                  color: Theme.of(context).colorScheme.background,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
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
        );
      },
    );
  }

  // Helper function to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget buildSwipeBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(16.0),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
