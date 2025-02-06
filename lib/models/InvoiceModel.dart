import 'dart:convert';
import 'package:invoice_generator/models/ProductModel.dart';

InvoiceModel invoiceModelFromJson(String str) => InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  String? cashType;
  String? partyName;
  String? invoiceType;
  String? taxOrBillOfSupply;
  String? billDate;
  String? billNo;
  List<ProductModel>? billItems;
  double? amount;
  double? discount;
  double? totalBillAmount;

  InvoiceModel({
    this.cashType,
    this.partyName,
    this.invoiceType,
    this.taxOrBillOfSupply,
    this.billDate,
    this.billNo,
    this.billItems,
    this.amount,
    this.discount,
    this.totalBillAmount,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    cashType: json["CashType"],
    partyName: json["PartyName"],
    invoiceType: json["InvoiceType"],
    taxOrBillOfSupply: json["TaxOrBillOfSupply"],
    billDate: json["BillDate"],
    billNo: json["BillNo"],
    billItems: json["BillItems"] == null ? [] : List<ProductModel>.from(json["BillItems"]!.map((x) => x)),
    amount: json["Amount"],
    discount: json["Discount"],
    totalBillAmount: json["TotalBillAmount"],
  );

  Map<String, dynamic> toJson() => {
    "CashType": cashType,
    "PartyName": partyName,
    "InvoiceType": invoiceType,
    "TaxOrBillOfSupply": taxOrBillOfSupply,
    "BillDate": billDate,
    "BillNo": billNo,
    "BillItems": billItems == null ? [] : List<ProductModel>.from(billItems!.map((x) => x)),
    "Amount": amount,
    "Discount": discount,
    "TotalBillAmount": totalBillAmount,
  };
}
