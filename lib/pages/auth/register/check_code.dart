import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../location_notification_service.dart';

import 'package:control_car_client/helpers/api.dart';
import 'package:control_car_client/helpers/helper.dart';

class CheckCode extends StatefulWidget {
  const CheckCode({Key? key}) : super(key: key);

  @override
  State<CheckCode> createState() => _CheckCodeState();
}

class _CheckCodeState extends State<CheckCode> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '# # # # # #', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  dynamic sendData = {
    'phone': '',
    "name": "",
    "carNumber": "",
    "carTypeId": 1,
    "password": "",
    "activationCode": '',
  };

  checkActivationCode() async {
    setState(() {
      sendData['activationCode'] = maskFormatter.getUnmaskedText();
    });
    final response = await guestPost('/services/mobile/api/activate', sendData);
    if (response == null || !response['success']) {
      // showErrorToast('error'.tr);
      return;
    }
    setState(() {
      sendData['username'] = sendData['phone'];
    });
    var loginData = {
      'username': sendData['phone'],
      'password': sendData['password'],
      'isRemember': false,
    };
    final login = await guestPost('/auth/login', loginData);
    if (login != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', login['access_token'].toString());
      prefs.setString('user', jsonEncode(sendData));
      var account = await get('/services/uaa/api/account');
      var checkAccess = false;
      for (var i = 0; i < account['authorities'].length; i++) {
        if (account['authorities'][i] == 'ROLE_LOYALTY_USER') {
          checkAccess = true;
        }
      }
      if (checkAccess) {
        LocalNotificationService.initialize(context);
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            Get.offAllNamed('/notifications');
          }
        });
        FirebaseMessaging.onMessage.listen((message) {
          if (message.notification != null) {
            //Get.toNamed('/dashboard');
          }
          LocalNotificationService.display(message);
        });
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          Get.offAllNamed('/notifications');
        });
        var firebaseToken = await FirebaseMessaging.instance.getToken();
        // await put('/services/mobile/api/firebase-token', {'token': firebaseToken});
        Get.offAllNamed('/');
      }
    }

    if (response['success']) {
      Get.offAllNamed('/confirm-finger-print');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sendData = Get.arguments;
      sendData['activationCode'] = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: white,
        ),
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'SMS kodni kiriting',
                    style: TextStyle(
                      color: black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    'Biz 6 raqamli sms kodni quyidagi telefon raqamiga jo’natdik +998 99 765 76 56',
                    style: TextStyle(
                      color: grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: purple,
                                ),
                          ),
                          child: TextFormField(
                            inputFormatters: [maskFormatter],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required_field'.tr;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value.length < 7) {
                                  sendData['activationCode'] = value;
                                }
                              });
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
                              hintText: 'To’liq ismingizni yozing',
                              hintStyle: TextStyle(
                                color: grey,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                            style: TextStyle(
                              color: black,
                              fontSize: 28,
                              letterSpacing: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 16),
                      child: Text(
                        'Iltimos 2 daqiqa kuting:  ',
                        style: TextStyle(
                          color: grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 16),
                      child: Text(
                        '1:32',
                        style: TextStyle(
                          color: black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF2995A3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Qayta yuborish',
                    style: TextStyle(
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            checkActivationCode();
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
            'Davom etish',
            style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
