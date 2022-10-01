import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:control_car_client/helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

class License extends StatefulWidget {
  const License({Key? key}) : super(key: key);

  @override
  State<License> createState() => LicenseState();
}

class LicenseState extends State<License> {
  final _formKey = GlobalKey<FormState>();
  dynamic sendData = {
    "beginDate": "",
    "endDate": "",
  };
  dynamic data = {
    "beginDate": TextEditingController(),
    "endDate": TextEditingController(),
  };

  getLicense() async {
    final response = await get('/services/mobile/api/license/${Get.arguments['id']}');
    setState(() {
      sendData = response;
      data['beginDate'].text = response['beginDate'].toString();
      data['endDate'].text = response['endDate'].toString();
    });
  }

  create() async {
    final response = await post('/services/mobile/api/license', sendData);
    if (response != null) {
      if (response['success']) {
        Get.back(result: 1);
      }
    }
  }

  update() async {
    final response = await put('/services/mobile/api/license', sendData);
    if (response != null) {
      if (response['success']) {
        Get.back(result: 1);
      }
    }
  }

  @override
  void initState() {
    if (Get.arguments != null) {
      getLicense();
    }
    setState(() {
      sendData['beginDate'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      sendData['endDate'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      data['beginDate'].text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      data['endDate'].text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
    super.initState();
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
          body: Container(
            margin: const EdgeInsets.only(bottom: 24, right: 24, left: 24, top: 50),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Yaroqlilik',
                        style: TextStyle(
                          color: grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                selectDate(context, 'beginDate');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: MediaQuery.of(context).size.width * 0.43,
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Color.fromARGB(255, 216, 216, 216),
                                //     width: 1,
                                //   ),
                                //   borderRadius: BorderRadius.circular(8),
                                // ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Majburiy maydon';
                                    }
                                    return null;
                                  },
                                  controller: data['beginDate'],
                                  decoration: InputDecoration(
                                    enabled: false,
                                    enabledBorder: inputBorder,
                                    disabledBorder: inputBorder,
                                    focusedBorder: inputBorder,
                                    focusedErrorBorder: inputBorderError,
                                    errorBorder: inputBorderError,
                                    filled: true,
                                    fillColor: white,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: '',
                                    hintStyle: TextStyle(color: grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                selectDate(context, 'endDate');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                width: MediaQuery.of(context).size.width * 0.43,
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Color.fromARGB(255, 216, 216, 216),
                                //     width: 1,
                                //   ),
                                //   borderRadius: BorderRadius.circular(8),
                                // ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Majburiy maydon';
                                    }
                                    return null;
                                  },
                                  controller: data['endDate'],
                                  decoration: InputDecoration(
                                    enabled: false,
                                    enabledBorder: inputBorder,
                                    disabledBorder: inputBorder,
                                    focusedBorder: inputBorder,
                                    focusedErrorBorder: inputBorderError,
                                    errorBorder: inputBorderError,
                                    filled: true,
                                    fillColor: white,
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: '',
                                    hintStyle: TextStyle(color: grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (Get.arguments == null) {
                  create();
                } else {
                  update();
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 32),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Saqlash',
                style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.095,
          // left: 24,
          child: Container(
            height: 48,
            color: white,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.topCenter,
              child: DefaultTextStyle(
                style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
                child: Text(
                  'Vakolatnoma',
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
                  color: const Color(0xFFF2F2F5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF151517),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();

  selectDate(BuildContext context, dateName) async {
    DateTime date = DateTime.now();
    final year = DateFormat('yyyy').format(date);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(int.parse(year) + 50),
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        data[dateName].text = DateFormat('yyyy-MM-dd').format(picked);
        sendData[dateName] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
