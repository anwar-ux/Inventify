import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'dbmodel.g.dart';

//userdata
@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? uname;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? password;
  @HiveField(4)
  String? image;

  DataModel(
      {this.id,
      @required this.uname,
      @required this.email,
      this.password,
      this.image});
}

//main cata
@HiveType(typeId: 1)
class DataModel2 {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? description;
  @HiveField(4)
  int? categoryId;

  DataModel2(
      {this.id,
      @required this.name,
      @required this.image,
      this.description,
      this.categoryId});
}
//sub cata

@HiveType(typeId: 2)
class DataModel3 {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? description;
  @HiveField(4)
  int? categoryId;
  @HiveField(5)
  int? subcategoryId;

  DataModel3({
    this.id,
    @required this.name,
    @required this.image,
    this.description,
    this.categoryId,
    this.subcategoryId,
  });
}

@HiveType(typeId: 3)
class DataModel4 {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? description;
  @HiveField(4)
  int? subcategoryId;
  @HiveField(5)
  int? purchaseprice;
  @HiveField(6)
  int? sellingprice;
  @HiveField(7)
  String? brand;
  @HiveField(8)
  int? stock;
  @HiveField(9)
  int? count;

  DataModel4({
    this.id,
    this.purchaseprice,
    this.sellingprice,
    @required this.name,
    @required this.image,
    this.description,
    this.brand,
    this.subcategoryId,
    this.stock,
    this.count,
  });
}

@HiveType(typeId: 4)
class Bill {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? customername;
  @HiveField(2)
  int? subcategoryId;
  @HiveField(3)
  List<String> sellingprice;
  @HiveField(4)
  String? phone;
  @HiveField(5)
  int? discountprice;
  @HiveField(6)
  int? totalprice;
  @HiveField(7)
  List<String> productname;
  @HiveField(8)
  String? productcategory;
  @HiveField(9)
  String? productsubcategory;
  @HiveField(10)
  List<String> count;
  @HiveField(11)
  String? date;
  @HiveField(12)
  String? time;
  @HiveField(13)
  int? totalproductsold;
  Bill(
      {required this.phone,
      required this.sellingprice,
      required this.totalprice,
      this.productcategory,
      this.productsubcategory,
      required this.productname,
      this.customername,
      this.discountprice,
      this.id,
      this.date,
      this.time,
      this.subcategoryId,
      required this.count,
      this.totalproductsold});
}
