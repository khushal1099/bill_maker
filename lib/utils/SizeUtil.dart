import 'package:flutter/material.dart';

class SizeUtil {
  SizeUtil._();

  // static double screenWidth = 0;
  // static double screenHeight = 0;
  // static double aspectRatio = 0;

  static void init() {
    // var size = MediaQuery.of(Get.context!);
    // screenHeight = size.size.height;
    // screenWidth = size.size.width;
    // aspectRatio = screenWidth / 1366;
  }
}

extension Sizedbox on num {
  SizedBox get height {
    return SizedBox(height: toDouble());
  }

  SizedBox get width {
    return SizedBox(width: toDouble());
  }
}

extension TextExtension on String {
  Text titleText() {
    return Text(
      this,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.5,
      ),
    );
  }

  Text normalText() {
    return Text(
      this,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.5,
      ),
    );
  }
}
