import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoice_generator/Utils/SizeUtil.dart';
import 'package:invoice_generator/controllers/CreateBillController.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CreateBillController controller = Get.put(CreateBillController());
  List<String> dayNameList = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  PageController pageController = PageController(initialPage: 900000);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      height: 400,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    pageController.previousPage(
                        duration: Duration(microseconds: 1),
                        curve: Curves.linear);
                  },
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Obx(() => DateFormat('MMMM yyyy')
                    .format(controller.currentMonth.value)
                    .toString()
                    .titleText()),
                InkWell(
                  onTap: () {
                    pageController.nextPage(
                        duration: Duration(microseconds: 1),
                        curve: Curves.linear);
                  },
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayNameList.map(
                  (e) {
                return e.titleText();
              },
            ).toList(),
          ),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (value) {
                DateTime date = DateTime.now();
                date = DateTime(date.year, (date.month + value - 900000), 1);
                controller.currentMonth.value = date;
              },
              itemBuilder: (context, index) {
                DateTime now = DateTime.now();
                DateTime date =
                DateTime(now.year, now.month + index - 900000, 1);

                return calendarDayWidget(date);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget calendarDayWidget(DateTime date) {
    var list = getDateList(date);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1.22),
      itemCount: list.length,
      itemBuilder: (context, index) {
        DateTime data = list[index];
        Color? color;

        if (controller.currentDate.value == data) {
          color = Colors.yellow;
        }
        if (data.day == DateTime.now().day) {
          color = Colors.grey.withOpacity(0.4);
        }
        return Obx(
              () => Center(
            child: InkWell(
              onTap: () {
                controller.isSelectDate.value = false;
                controller.currentDate.value = data;

              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    data.day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: controller.currentMonth.value.month == data.month
                          ? Colors.black
                          : Colors.black38,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DateTime> getDateList(DateTime date) {
    List<DateTime> list = [];

    while (date.weekday != DateTime.sunday) {
      date = date.add(const Duration(days: -1));
    }

    for (int i = 0; i < 42; i++) {
      list.add(date.add(Duration(days: i)));
    }

    return list;
  }
}