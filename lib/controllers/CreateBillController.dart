import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:invoice_generator/models/InvoiceModel.dart';
import 'package:invoice_generator/models/ProductModel.dart';

class CreateBillController extends GetxController {
  RxList<String> suggestionPartyNameList = <String>[
    'John',
    'Joy',
    'Jio',
  ].obs;
  RxList<String> searchedPartyNameList = <String>[].obs;
  RxBool isShowList = false.obs;
  RxBool isSelectDate = false.obs;
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<DateTime> currentMonth = DateTime.now().obs;
  RxList<String> billList = <String>[].obs;
  RxList<ProductModel> rows = <ProductModel>[].obs;

  RxString cashType = 'Credit'.obs;
  RxString partyName = ''.obs;
  RxString invoiceType = 'GST'.obs;
  RxString taxOrBillOfSupply = 'Text Invoice'.obs;

  Rx<TextEditingController> date = TextEditingController().obs;

  RxList<InvoiceModel> invoiceItemList = <InvoiceModel>[].obs;
}
