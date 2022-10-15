import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../location_notification_service.dart';

import 'package:control_car_client/helpers/api.dart';
import 'package:control_car_client/helpers/helper.dart';

class CheckCode extends StatefulWidget {
  const CheckCode({Key? key}) : super(key: key);

  @override
  State<CheckCode> createState() => _CheckCodeState();
}

class _CheckCodeState extends State<CheckCode> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(
    mask: '# # # # # #',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  AnimationController? animationController;

  dynamic sendData = {
    'phone': '',
    "name": "",
    "carNumber": "",
    "carTypeId": 1,
    "password": "",
    "activationCode": '',
  };
  bool loading = false;

  checkActivationCode() async {
    setState(() {
      sendData['activationCode'] = maskFormatter.getUnmaskedText();
      loading = true;
    });
    final response = await guestPost('/services/mobile/api/activate', sendData);
    if (response == null || !response['success']) {
      // showErrorToast('error'.tr);
      setState(() {
        loading = false;
      });
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
        await put('/services/mobile/api/firebase-token', {'token': firebaseToken});
        Get.offAllNamed('/');
      }
    }
    setState(() {
      loading = false;
    });
  }

  checkDeleteActivationCode() async {
    setState(() {
      sendData['activationCode'] = maskFormatter.getUnmaskedText();
      loading = true;
    });
    final response = await post('/services/mobile/api/accept-delete', {
      'activationCode': sendData['activationCode'],
    });
    setState(() {
      loading = false;
    });
    if (response != null && response['success']) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('access_token');
      prefs.remove('user');
      Get.offAllNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sendData = Get.arguments;
      sendData['activationCode'] = '';
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    });
  }

  @override
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                        'SMS kodni yozing',
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
                        'Biz 6 raqamli sms kodni quyidagi telefon raqamiga jo’natdik ${formatPhone(sendData['phone'])}',
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
                                      primary: green,
                                    ),
                              ),
                              child: TextFormField(
                                inputFormatters: [maskFormatter],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Majburiy maydon';
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
                                  hintText: 'Sms kod',
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 50, bottom: 16),
                    //       child: Text(
                    //         'Iltimos 2 daqiqa kuting:  ',
                    //         style: TextStyle(
                    //           color: grey,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 50, bottom: 16),
                    //       child: Text(
                    //         '1:32',
                    //         style: TextStyle(
                    //           color: black,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     border: Border(
                    //       bottom: BorderSide(
                    //         color: Color(0xFF2995A3),
                    //         width: 1,
                    //       ),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     'Qayta yuborish',
                    //     style: TextStyle(
                    //       color: linkColor,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (Get.arguments['value'] != null && Get.arguments['value'] == 1) {
                  checkDeleteActivationCode();
                } else {
                  checkActivationCode();
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
                Get.arguments != null && Get.arguments['value'] != 1 ? 'Ro\'yxatdan o\'tish' : 'Profilni o\'chirish',
                style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        loading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.4),
                child: SpinKitThreeBounce(
                  color: green,
                  size: 35.0,
                  controller: animationController,
                ),
              )
            : Container()
      ],
    );
  }
}
