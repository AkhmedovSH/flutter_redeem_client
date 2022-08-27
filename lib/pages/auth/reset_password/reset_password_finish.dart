import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../helpers/api.dart';
import '../../../helpers/helper.dart';

class ResetPasswordFinish extends StatefulWidget {
  const ResetPasswordFinish({Key? key}) : super(key: key);

  @override
  State<ResetPasswordFinish> createState() => _ResetPasswordFinishState();
}

class _ResetPasswordFinishState extends State<ResetPasswordFinish> {
  var maskFormatter = MaskTextInputFormatter(mask: '### ###', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  final _formKey = GlobalKey<FormState>();
  dynamic sendData = {
    'key': '',
    'newPassword': '',
  };
  bool showPassword = true;

  checkActivationCode() async {
    setState(() {
      sendData['key'] = maskFormatter.getUnmaskedText();
    });
    final response = await guestPost('/services/uaa/api/account/reset-password/finish', sendData);
    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') != null) {
        final user = jsonDecode(prefs.getString('user')!);
        user['password'] = sendData['newPassword'];
        prefs.setString('user', jsonEncode(user));
      }
      showSuccessToast('password_changed_successfully'.tr);
      Get.offAllNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
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
                    'examination'.tr,
                    style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'enter_the_code_we_sent_to_your_number'.tr,
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
                                  primary: purple,
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 4.0),
                              focusColor: purple,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: purple),
                              ),
                              labelText: 'code'.tr,
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                            style: const TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: purple,
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
                              prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.lock,
                                  )),
                              suffixIcon: showPassword
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility_off,
                                        // color: purple,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility,
                                        // color: purple,
                                      )),
                              contentPadding: const EdgeInsets.all(18.0),
                              focusColor: purple,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: purple),
                              ),
                              labelText: 'new_password'.tr,
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                            style: const TextStyle(color: Color(0xFF9C9C9C)),
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
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 32),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              pink,
              purple,
            ],
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              checkActivationCode();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            primary: Colors.transparent,
            elevation: 0.0,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            'confirm_password'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
