import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_generator/Utils/AppAssets.dart';
import 'package:invoice_generator/Utils/SizeUtil.dart';
import 'package:invoice_generator/controllers/CreateBillController.dart';
import 'package:invoice_generator/screens/CreateBillScreen.dart';

class BillListingScreen extends StatefulWidget {
  const BillListingScreen({super.key});

  @override
  State<BillListingScreen> createState() => _BillListingScreenState();
}

class _BillListingScreenState extends State<BillListingScreen> {
  CreateBillController controller = Get.put(CreateBillController());

  @override
  void initState() {
    super.initState();
    SizeUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            child: Center(
              child: Text(
                "SHIV ENTERPRISE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return Stack(
                  children: [
                    controller.invoiceItemList.value.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => const CreateBillScreen());
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppAssets.addPage,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Create Bill',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: Center(
                                        child: "Bill no".titleText(),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 30,
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: "Party Name".titleText(),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 30,
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: "Bill Date".titleText(),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 30,
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: "Bill Amount".titleText(),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      controller.invoiceItemList.value.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        controller.invoiceItemList.value[index];

                                    return Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: index ==
                                                (controller.invoiceItemList
                                                        .length -
                                                    1)
                                            ? Border(
                                                top: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              )
                                            : Border(
                                                top: BorderSide(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: Center(
                                              child: data.billNo?.titleText() ??
                                                  SizedBox(),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 40,
                                            width: 1,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child:
                                                data.partyName?.titleText() ??
                                                    SizedBox(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 40,
                                            width: 1,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: data.billDate?.titleText() ??
                                                SizedBox(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            height: 40,
                                            width: 1,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: data.totalBillAmount
                                                .toString()
                                                .titleText(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                    if (controller.invoiceItemList.value.isNotEmpty)
                      Positioned(
                        bottom: 15,
                        right: 15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              onTap: () {
                                Get.to(() => const CreateBillScreen());
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Image.asset(
                                    AppAssets.addPage,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Create Bill',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
