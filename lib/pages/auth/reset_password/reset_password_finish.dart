import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../helpers/api.dart';
import '../../../helpers/helper.dart';

class ResetPasswordFinish extends StatefulWidget {
  const ResetPasswordFinish({Key? key}) : super(key: key);

  @override
  State<ResetPasswordFinish> createState() => _ResetPasswordFinishState();
}

class _ResetPasswordFinishState extends State<ResetPasswordFinish> with TickerProviderStateMixin {
  var maskFormatter = MaskTextInputFormatter(mask: '### ###', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  final _formKey = GlobalKey<FormState>();
  AnimationController? animationController;
  dynamic sendData = {
    'key': '',
    'newPassword': '',
  };
  bool showPassword = true;
  bool loading = false;

  checkActivationCode() async {
    setState(() {
      sendData['key'] = maskFormatter.getUnmaskedText();
      loading = true;
    });
    final response = await guestPost('/services/uaa/api/account/reset-password/finish', sendData);
    setState(() {
      loading = false;
    });
    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') != null) {
        final user = jsonDecode(prefs.getString('user')!);
        user['password'] = sendData['newPassword'];
        prefs.setString('user', jsonEncode(user));
      }
      showSuccessToast('Parol muvaffaqiyatli almashtirildi');
      Get.offAllNamed('/login');
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
                        '',
                        style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Raqamingizga yuborilgan kodni yozing',
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Majburiy maydon';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    if (value.length < 7) {
                                      sendData['key'] = value;
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
                                  hintText: 'SMS kodni yozing',
                                  hintStyle: TextStyle(color: grey),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ThemeData().colorScheme.copyWith(
                                      primary: green,
                                    ),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Majburiy maydon';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    sendData['newPassword'] = value;
                                  });
                                },
                                obscureText: showPassword,
                                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 1.5),
                                decoration: InputDecoration(
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorder,
                                  focusedErrorBorder: inputBorderError,
                                  errorBorder: inputBorderError,
                                  filled: true,
                                  fillColor: white,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: showPassword
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: black,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: black,
                                          ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                  hintText: 'Yangi parolingizni yozing',
                                  hintStyle: TextStyle(color: grey),
                                ),
                              ),
                            ),
                          ),
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
