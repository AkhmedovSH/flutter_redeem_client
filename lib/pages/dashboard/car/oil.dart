import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:control_car_client/helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

class Oil extends StatefulWidget {
  const Oil({Key? key}) : super(key: key);

  @override
  State<Oil> createState() => OilState();
}

class OilState extends State<Oil> {
  final _formKey = GlobalKey<FormState>();
  dynamic sendData = {
    "startDate": "2022-09-20",
    "km": "38000",
    "brand": "Lotus",
    "oilKm": "8000",
    "daykm": "60",
  };
  dynamic data = {
    "startDate": TextEditingController(),
    "km": TextEditingController(),
    "brand": TextEditingController(),
    "oilKm": TextEditingController(),
    "daykm": TextEditingController(),
  };

  getOil() async {
    final response = await get('/services/mobile/api/oil/${Get.arguments['id']}');
    setState(() {
      sendData = response;
      data['startDate'].text = response['startDate'];
      data['km'].text = response['km'].toString();
      data['brand'].text = response['brand'].toString();
      data['oilKm'].text = response['oilKm'].toString();
      data['daykm'].text = response['daykm'].toString();
    });
  }

  createOil() async {
    final response = await post('/services/mobile/api/oil', sendData);
    if (response != null) {
      if (response['success']) {
        Get.back(result: 1);
      }
    }
  }

  updateOil() async {
    final response = await put('/services/mobile/api/oil', sendData);
    if (response != null) {
      if (response['success']) {
        Get.back(result: 1);
      }
    }
  }

  @override
  void initState() {
    if (Get.arguments != null) {
      getOil();
    }
    setState(() {
      data['startDate'].text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
            margin: const EdgeInsets.only(bottom: 24, right: 24, left: 24, top: 30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Дата след. замены',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: grey,
                            ),
                          ),
                          Text(
                            '09 - дек. 2022',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Пробег для замены',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: grey,
                            ),
                          ),
                          Text(
                            '13000 км',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                'Дата прошлой замены',
                                style: TextStyle(
                                  color: grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                selectDate(context);
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
                                  controller: data['startDate'],
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
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                'Пробег при замене',
                                style: TextStyle(
                                  color: grey,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              width: MediaQuery.of(context).size.width * 0.37,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Majburiy maydon';
                                  }
                                  return null;
                                },
                                controller: data['km'],
                                onChanged: (value) {
                                  sendData['km'] = value;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  enabledBorder: inputBorder,
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
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Марка масла',
                        style: TextStyle(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        controller: data['brand'],
                        onChanged: (value) {
                          sendData['brand'] = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'На сколько км пробега рассчитано масло',
                        style: TextStyle(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        controller: data['oilKm'],
                        onChanged: (value) {
                          sendData['oilKm'] = value;
                        },
                        keyboardType: TextInputType.number,
                        scrollPadding: const EdgeInsets.only(bottom: 100),
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Ежедневный пробег',
                        style: TextStyle(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        controller: data['daykm'],
                        onChanged: (value) {
                          sendData['daykm'] = value;
                        },
                        scrollPadding: const EdgeInsets.only(bottom: 100),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
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
                  createOil();
                } else {
                  updateOil();
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
                  'Масло',
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

  selectDate(BuildContext context) async {
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
        data['startDate'].text = DateFormat('yyyy-MM-dd').format(picked);
        sendData['startDate'] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
