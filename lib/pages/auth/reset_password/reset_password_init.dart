import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../helpers/helper.dart';
import '../../../helpers/api.dart';

class ResetPasswordInit extends StatefulWidget {
  const ResetPasswordInit({Key? key}) : super(key: key);

  @override
  State<ResetPasswordInit> createState() => _ResetPasswordInitState();
}

class _ResetPasswordInitState extends State<ResetPasswordInit> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  AnimationController? animationController;
  dynamic sendData = {
    'phone': '',
    'password': '',
    'confirmPassword': '',
  };
  dynamic data = {
    'phone': TextEditingController(text: ''),
    'password': '',
    'confirmPassword': '',
  };
  bool loading = false;

  resetPasswordInit() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      final user = jsonDecode(prefs.getString('user')!);
      setState(() {
        sendData['password'] = user['password'];
      });
    }
    // else {
    //   showErrorToast('user_is_not_found'.tr);
    // }
    setState(() {
      sendData['phone'] = '998' + maskFormatter.getUnmaskedText();
    });
    final response = await guestPost('/services/uaa/api/account/reset-password-loyalty/init', sendData);
    if (response != null) {
      if (response['success']) {
        Get.toNamed('/reset-password-finish');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    });
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
                  ))),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Parolni esdan chiqardingizmi' '?',
                        style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Parolni tiklash uchun telefon raqamingizni kiriting',
                        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
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
                                controller: data['phone'],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Majburiy maydon';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  if (value == '') {
                                    setState(() {
                                      data['phone'].text = '+998 ';
                                      data['phone'].selection = TextSelection.fromPosition(TextPosition(offset: data['phone'].text.length));
                                    });
                                  }
                                  setState(() {
                                    sendData['phone'] = value;
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
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
                                    padding: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: black,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '+998',
                                      style: TextStyle(color: black, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 16,
                                  ),
                                  hintText: 'Telefon raqamingizni yozing',
                                  hintStyle: TextStyle(color: grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 70,
                          )
                        ],
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
                resetPasswordInit();
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
                'Tizimga kirish',
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
