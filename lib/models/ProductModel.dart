// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? productNo;
  String? productName;
  int? productQty;
  double? productPrice;
  double? totalProductPrice;
  TextEditingController? nameController;
  TextEditingController? qtyController;
  TextEditingController? priceController;
  TextEditingController? totalPriceController;

  ProductModel({
    this.productNo,
    this.productName,
    this.productQty,
    this.productPrice,
    this.totalProductPrice,
    this.nameController,
    this.qtyController,
    this.priceController,
    this.totalPriceController,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productNo: json["ProductNo"],
        productName: json["ProductName"],
        productQty: json["ProductQty"],
        productPrice: json["ProductPrice"],
        totalProductPrice: json["TotalProductPrice"],
        nameController: json['nameController'],
        qtyController: json['qtyController'],
        priceController: json['priceController'],
        totalPriceController: json['totalPriceController'],
      );

  Map<String, dynamic> toJson() => {
        "ProductNo": productNo,
        "ProductName": productName,
        "ProductQty": productQty,
        "ProductPrice": productPrice,
        "TotalProductPrice": totalProductPrice,
        "nameController": nameController,
        "qtyController": qtyController,
        "priceController": priceController,
        "totalPriceController": totalPriceController,
      };
}
