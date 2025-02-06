import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice_generator/Utils/AppAssets.dart';
import 'package:invoice_generator/Utils/SizeUtil.dart';
import 'package:invoice_generator/screens/CreateBillScreen.dart';

class BillListingScreen extends StatefulWidget {
  const BillListingScreen({super.key});

  @override
  State<BillListingScreen> createState() => _BillListingScreenState();
}

class _BillListingScreenState extends State<BillListingScreen> {


  @override
  void initState() {
    super.initState();
    SizeUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
    );
  }
}
