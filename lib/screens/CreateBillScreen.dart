import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/Customs/AppTextFormField.dart';
import 'package:invoice_generator/Customs/CalendarWidget.dart';
import 'package:invoice_generator/Utils/AppColor.dart';
import 'package:invoice_generator/Utils/SizeUtil.dart';
import 'package:invoice_generator/controllers/CreateBillController.dart';
import 'package:invoice_generator/models/InvoiceModel.dart';
import 'package:invoice_generator/models/ProductModel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  CreateBillController createBillController = Get.put(CreateBillController());
  TextEditingController partyNameController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController billAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      addRow(i);
    }
  }

  double calculateAmount() {
    double amount = 0.0;

    createBillController.rows.forEach(
      (element) {
        amount += (element.productPrice ?? 0) * (element.productQty ?? 1);
      },
    );

    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Bill',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              var height = constraints.maxHeight;
              var width = constraints.maxWidth;
              return Column(
                children: [
                  billDetailWidget(height),
                  billItemsDetailWidget(height, width),
                  billAmountDetailWidget(height, width),
                ],
              );
            },
          ),
          Obx(
            () => Positioned(
              top: createBillController.isShowList.value ? 110 : -300,
              left: 130,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  itemCount:
                      createBillController.suggestionPartyNameList.length,
                  itemBuilder: (context, index) {
                    var data =
                        createBillController.suggestionPartyNameList[index];
                    return InkWell(
                      onTap: () {
                        createBillController.isShowList.value = false;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: AlignmentDirectional.centerStart,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
                        ),
                        child: data.normalText(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => Positioned(
              top: createBillController.isSelectDate.value ? 35 : -1000,
              right: 50,
              child: Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CalendarWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pdfView() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Text('Hello');
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    await OpenFile.open(file.path);
  }

  void addRow(int index) {
    createBillController.rows.add(
      ProductModel(
        productNo: index + 1,
        productName: '',
        productQty: 0,
        productPrice: 0.0,
        totalProductPrice: 0.0,
        nameController: TextEditingController(),
        qtyController: TextEditingController(),
        priceController: TextEditingController(),
        totalPriceController: TextEditingController(),
      ),
    );

    setState(() {});
  }

  void calculatePrice(int index) {
    int qty = createBillController.rows[index].productQty ?? 1;
    double rate = createBillController.rows[index].productPrice ?? 0.0;

    createBillController.rows[index].totalProductPrice = qty * rate;
    setState(() {});
  }

  bool allRowsValid() {
    for (var row in createBillController.rows) {
      if (row.productName.toString().isEmpty ||
          row.productQty.toString().isEmpty ||
          row.productPrice.toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  Widget billDetailWidget(double height) {
    return Container(
      height: height * 0.2,
      color: Colors.yellow.shade100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.yellow.shade100,
              child: Column(
                children: [
                  Row(
                    children: [
                      'Cash / Debit'.titleText(),
                      25.width,
                      Obx(
                        () => Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            customDropDown(
                              height: 30,
                              width: 100,
                              dropDownValue:
                                  createBillController.cashType.value,
                              itemList: [
                                DropdownMenuItem(
                                  value: 'Credit',
                                  child: 'Credit'.normalText(),
                                ),
                                DropdownMenuItem(
                                  value: 'Debit',
                                  child: 'Debit'.normalText(),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  createBillController.cashType.value = value;
                                }
                              },
                            ),
                            Positioned(
                              left: 10,
                              child: createBillController.cashType.value
                                  .normalText(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  25.height,
                  Row(
                    children: [
                      'Party Name'.titleText(),
                      AppTextFormField(
                        controller: partyNameController,
                        width: 200,
                        onChanged: (value) {
                          List<String> result = [];
                          if (value.isNull) {
                            result =
                                createBillController.suggestionPartyNameList;
                          } else {
                            result = createBillController
                                .suggestionPartyNameList
                                .where(
                              (element) {
                                return element
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                              },
                            ).toList();
                          }
                          createBillController.searchedPartyNameList.value =
                              result;
                          if (createBillController
                                  .searchedPartyNameList.isEmpty ||
                              value.isEmpty) {
                            createBillController.isShowList.value = false;
                          } else {
                            createBillController.isShowList.value = true;
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.yellow,
              child: Column(
                children: [
                  Row(
                    children: [
                      'Invoice Type'.titleText(),
                      25.width,
                      Obx(
                        () => Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            customDropDown(
                              height: 30,
                              width: 100,
                              dropDownValue:
                                  createBillController.cashType.value,
                              itemList: [
                                DropdownMenuItem(
                                  value: 'GST',
                                  child: 'GST'.normalText(),
                                ),
                                DropdownMenuItem(
                                  value: 'IGST',
                                  child: 'IGST'.normalText(),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  createBillController.invoiceType.value =
                                      value;
                                }
                              },
                            ),
                            Positioned(
                              left: 10,
                              child: createBillController.invoiceType.value
                                  .normalText(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  25.height,
                  Row(
                    children: [
                      'Tax/Bill of Supply'.titleText(),
                      25.width,
                      Obx(
                        () => Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            customDropDown(
                              height: 30,
                              width: 150,
                              dropDownValue:
                                  createBillController.taxOrBillOfSupply.value,
                              itemList: [
                                DropdownMenuItem(
                                  value: 'Text Invoice',
                                  child: 'Text Invoice'.normalText(),
                                ),
                                DropdownMenuItem(
                                  value: 'Bill of Supply',
                                  child: 'Bill of Supply'.normalText(),
                                ),
                                DropdownMenuItem(
                                  value: 'Other',
                                  child: 'Other'.normalText(),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  createBillController.taxOrBillOfSupply.value =
                                      value;
                                }
                              },
                            ),
                            Positioned(
                              left: 10,
                              child: createBillController
                                  .taxOrBillOfSupply.value
                                  .normalText(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              color: Colors.green,
              child: Column(
                children: [
                  Row(
                    children: [
                      'Bill Date'.titleText(),
                      25.width,
                      InkWell(
                        onTap: () {
                          createBillController.isSelectDate.value =
                              !createBillController.isSelectDate.value;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 30,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => DateFormat('dd-MM-yyyy')
                                      .format(createBillController
                                          .currentDate.value)
                                      .toString()
                                      .normalText(),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  25.height,
                  Row(
                    children: [
                      'Bill No'.titleText(),
                      25.width,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 30,
                        // width: 100,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(),
                        ),
                        child: Obx(
                          () => '${createBillController.billList.length + 1}'
                              .normalText(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget billItemsDetailWidget(double height, double width) {
    return SizedBox(
      height: height * 0.50,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              color: Colors.yellow.shade100,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: AppColor.borderColor))),
                    child: Text('No'),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: AppColor.borderColor))),
                      child: Text('Product Name'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColor.borderColor),
                        ),
                      ),
                      child: Text('Qty'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColor.borderColor),
                        ),
                      ),
                      child: Text('Rate'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColor.borderColor),
                        ),
                      ),
                      child: Text('Price'),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: createBillController.rows.length,
                  itemBuilder: (context, index) {
                    var data = createBillController.rows[index];
                    return Row(
                      children: [
                        // Item No
                        SizedBox(
                          width: 60,
                          child: inputField(
                            isEnable: false,
                            controller: TextEditingController(
                                text: data.productNo.toString()),
                            onChanged: (value) {
                              data.productNo = int.tryParse(value) ?? 0;
                            },
                          ),
                        ),

                        // Product Name
                        Expanded(
                          flex: 4,
                          child: inputField(
                            controller: data.nameController,
                            onChanged: (value) {
                              data.productName = value;
                            },
                          ),
                        ),

                        // Qty
                        Expanded(
                          flex: 1,
                          child: inputField(
                            controller: data.qtyController,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              data.productQty = int.tryParse(value) ?? 1;

                              if (data.priceController != null &&
                                  data.priceController!.text.isNotEmpty) {
                                data.totalPriceController
                                    ?.text = ((double.tryParse(
                                                data.priceController?.text ??
                                                    '') ??
                                            0) *
                                        (double.tryParse(
                                                data.qtyController?.text ??
                                                    '') ??
                                            1))
                                    .toString();
                              }

                              if (discountAmountController.text.isNotEmpty) {
                                billAmountController.text = (calculateAmount() -
                                        double.parse(
                                            discountAmountController.text))
                                    .toString();
                              } else {
                                billAmountController.text =
                                    (calculateAmount() - 0).toString();
                              }
                              setState(() {});
                            },
                          ),
                        ),

                        // Rate
                        Expanded(
                          flex: 1,
                          child: inputField(
                            controller: data.priceController,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              data.productPrice = double.tryParse(value) ?? 0;

                              if (data.qtyController != null &&
                                  data.qtyController!.text.isNotEmpty) {
                                data.totalPriceController
                                    ?.text = ((double.tryParse(
                                                data.priceController?.text ??
                                                    '') ??
                                            0) *
                                        (double.tryParse(
                                                data.qtyController?.text ??
                                                    '') ??
                                            1))
                                    .toString();
                              }

                              if (discountAmountController.text.isNotEmpty) {
                                billAmountController.text = (calculateAmount() -
                                        double.parse(
                                            discountAmountController.text))
                                    .toString();
                              } else {
                                billAmountController.text =
                                    (calculateAmount() - 0).toString();
                              }
                              setState(() {});
                            },
                          ),
                        ),

                        // Price (Read-only)
                        Expanded(
                          flex: 1,
                          child: inputField(
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: data.totalPriceController,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                List<ProductModel> itemsList = [];
                for (var data in createBillController.rows) {
                  ProductModel model = ProductModel(
                    productNo: data.productNo,
                    productName: data.nameController?.text,
                    productQty: int.tryParse(data.qtyController!.text),
                    productPrice: double.tryParse(data.priceController!.text),
                    totalProductPrice: data.totalProductPrice,
                  );

                  if (model.productName!.isNotEmpty) {
                    itemsList.add(model);
                  }
                }

                InvoiceModel model = InvoiceModel(
                  cashType: createBillController.cashType.value,
                  partyName: partyNameController.text,
                  invoiceType: createBillController.invoiceType.value,
                  taxOrBillOfSupply:
                      createBillController.taxOrBillOfSupply.value,
                  billDate: createBillController.currentDate.value.toString(),
                  billNo: (createBillController.billList.length + 1).toString(),
                  billItems: itemsList,
                  amount: double.tryParse(totalAmountController.text),
                  discount: double.tryParse(discountAmountController.text),
                  totalBillAmount: double.tryParse(billAmountController.text),
                );

                createBillController.invoiceItemList.add(model);

                createBillController.invoiceItemList.value.forEach(
                  (element) {
                    print([
                      element.partyName,
                      element.cashType,
                      element.invoiceType,
                      element.taxOrBillOfSupply,
                      element.billDate,
                      element.billNo,
                      element.billItems?.length,
                      element.amount,
                      element.discount ?? 0.0,
                      element.totalBillAmount,
                    ]);
                  },
                );
              },
              child: Text('Get Values'),
            )
          ],
        ),
      ),
    );
  }

  Widget billAmountDetailWidget(double height, double width) {
    totalAmountController.text = calculateAmount().toString();

    return SizedBox(
      height: height * 0.30,
      width: width,
      child: Padding(
        padding: EdgeInsets.only(top: 50, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                'Amount'.titleText(),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColor.borderColor)),
                  child: TextFormField(
                    controller: totalAmountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black.withOpacity(0.6),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 13),
                        constraints: BoxConstraints(maxHeight: 35)),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        billAmountController.text =
                            (calculateAmount() - double.parse(value))
                                .toString();
                      } else {
                        billAmountController.text =
                            (calculateAmount() - 0).toString();
                      }
                    },
                  ),
                ),
              ],
            ),
            15.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                'Discount'.titleText(),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColor.borderColor)),
                  child: TextFormField(
                    controller: discountAmountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black.withOpacity(0.6),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 13),
                        constraints: BoxConstraints(maxHeight: 35)),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        billAmountController.text =
                            (calculateAmount() - double.parse(value))
                                .toString();
                      } else {
                        billAmountController.text =
                            (calculateAmount() - 0).toString();
                      }
                    },
                  ),
                ),
              ],
            ),
            15.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                'Total Bill Amount'.titleText(),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColor.borderColor)),
                  child: TextFormField(
                    controller: billAmountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black.withOpacity(0.6),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 13),
                        constraints: BoxConstraints(maxHeight: 35)),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            15.height,
            InkWell(
              onTap: () {
                pdfView();
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue,
                ),
                child: Center(
                  child: 'Save'.titleText(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(
      {TextEditingController? controller,
      ValueChanged<String>? onChanged,
      bool isEnable = true,
      List<TextInputFormatter>? inputFormatter}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.borderColor, width: 1.0),
          // Bottom border
          right: BorderSide(
              color: AppColor.borderColor, width: 1.0), // Right border
        ),
      ),
      child: TextFormField(
        enabled: isEnable,
        inputFormatters: inputFormatter,
        controller: controller ?? TextEditingController(),
        keyboardType: TextInputType.number,
        cursorColor: Colors.black.withOpacity(0.6),
        style: TextStyle(color: Colors.black.withOpacity(0.8)),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 13),
            constraints: BoxConstraints(maxHeight: 35)),
        onChanged: onChanged,
      ),
    );
  }

  Widget customDropDown(
      {double? height = 30,
      double? width = 100,
      List<DropdownMenuItem>? itemList,
      String? dropDownValue,
      void Function(dynamic value)? onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(width: 1, color: Colors.black)),
      child: Center(
        child: DropdownButton2(
          // value: dropDownValue,
          isExpanded: true,
          underline: SizedBox(),
          isDense: true,
          iconStyleData: IconStyleData(
            icon: Container(
              height: 30,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.black.withOpacity(
                  0.7,
                ),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: onChanged,
          items: itemList,
        ),
      ),
    );
  }
}
