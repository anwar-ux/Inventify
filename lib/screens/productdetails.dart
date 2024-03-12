import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:inventify/db/dbmodel.dart';

class ProductDetail extends StatelessWidget {
  final DataModel4 data;

  const ProductDetail({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight, // Set height to cover the entire screen
      decoration: const BoxDecoration(
        color: AppColors.secondaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 235,
                      width: double.infinity,
                      color: Colors.black,
                      child: Image.file(
                        File(data.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Brand: ${data.brand ?? ''}',
                    style: const TextStyle(
                      color: AppColors.thirdcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Purchase Rate: ₹${data.purchaseprice.toString()}',
                    style: const TextStyle(
                      color: AppColors.thirdcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Selling Rate: ₹${data.sellingprice.toString()}',
                    style: const TextStyle(
                      color: AppColors.thirdcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                   Text(
                    'Available Stock: ${data.stock.toString()}',
                    style: const TextStyle(
                      color: AppColors.thirdcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ), const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.description!,
                    style: const TextStyle(
                      color: AppColors.thirdcolor,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
