import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:control_car_client/helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';
import 'package:get/get.dart';

class Oil extends StatefulWidget {
  const Oil({Key? key}) : super(key: key);

  @override
  State<Oil> createState() => OoilState();
}

class OoilState extends State<Oil> {
  dynamic sendData = {};
  dynamic data = {};

  getOil() async {
    final response = await get('url');
    setState(() {
      sendData = response;
    });
  }

  @override
  void initState() {
    if (Get.arguments != null) {
      getOil();
    }

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
              child: Column(
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
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Majburiy maydon';
                                }
                                return null;
                              },
                              // controller: data['nameController'],
                              onChanged: (value) {
                                sendData['name'] = value;
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
                              // controller: data['nameController'],
                              onChanged: (value) {
                                sendData['name'] = value;
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
                        ],
                      ),
                    ],
                  ),
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
}
