import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  dynamic receipt = [];
  bool loading = false;
  dynamic filter = {
    'chequeDate': "",
  };

  getReceipts() async {
    setState(() {
      loading = true;
    });
    final response = await get('/services/mobile/api/cheque-by-pos-pageList/${Get.arguments['id']}', payload: filter);
    if (response != null) {
      setState(() {
        receipt = response;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getReceipts();
  }

  buildCard(item, {color}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        formatDateMonth(item['chequeDate'] ?? ''),
                        style: const TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        item['totalAmount'].round().toString() + ' so\'m',
                        style: const TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                item['bonus'].round().toString() + ' b.',
                style: TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  // overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 16,
          child: SizedBox(
            child: SvgPicture.asset(
              'images/icons/vertical_line.svg',
              color: item['debt'] ? const Color(0xFFF28F1E) : const Color(0XFF8DBAD5),
            ),
          ),
        ),
        // Positioned(
        //   right: 16,
        //   bottom: 16,
        //   child: Text(
        //     item['time'] != null ? formatDateHour(item['time']) : '',
        //     style: const TextStyle(
        //       color: Color(0xFF666666),
        //       fontSize: 12,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
            leading: Container(),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24, right: 24, left: 24, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < receipt.length; i++)
                    SizedBox(
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              child: buildCard({
                                'chequeDate': receipt[i]['chequeDate'],
                                'totalAmount': receipt[i]['totalAmount'],
                                'bonus': receipt[i]['bonus'],
                                'debt': receipt[i]['debt'],
                              }),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.095,
          // left: 24,
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            color: white,
            child: Align(
              alignment: Alignment.topCenter,
              child: DefaultTextStyle(
                style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
                child: Text(
                  'Cheklar',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: black,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          left: 24,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              // margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.only(left: 8),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(
                  color: const Color(0xFF859EAD),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF3D708F),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          right: 12,
          child: GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: const SizedBox(
              // margin: const EdgeInsets.only(left: 12),
              width: 48,
              height: 48,
              // decoration: BoxDecoration(
              //   color: white,
              //   border: Border.all(
              //     color: const Color(0xFF859EAD),
              //     width: 1,
              //   ),
              //   borderRadius: BorderRadius.circular(35),
              // ),
              child: Center(
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: Color(0xFF3D708F),
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();

  selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final year = DateFormat('yyyy').format(date);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(int.parse(year) + 1),
      cancelText: 'Bekor qilish',
      // locale: const Locale("fr", "FR"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: green,
            colorScheme: ColorScheme.light(primary: green),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) {
      setState(() {
        filter['chequeDate'] = '';
        getReceipts();
      });
    }
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        filter['chequeDate'] = DateFormat('yyyy-MM-dd').format(picked);
        getReceipts();
      });
    }
  }
}
