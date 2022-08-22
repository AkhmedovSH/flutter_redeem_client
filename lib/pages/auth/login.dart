import 'dart:convert';

import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../helpers/helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  dynamic sendData = {
    'username': '',
    'password': '',
    'isRemember': false,
  };
  dynamic data = {
    'username': TextEditingController(text: ''),
    'password': TextEditingController(),
    'isRemember': false,
  };
  bool showPassword = true;

  login() async {
    final prefs = await SharedPreferences.getInstance();
    if (maskFormatter.getUnmaskedText().isNotEmpty) {
      setState(() {
        sendData['username'] = '998' + maskFormatter.getUnmaskedText();
      });
    }
    final response = await guestPost('/auth/login', sendData);
    if (response != null) {
      prefs.setString('access_token', response['access_token'].toString());
      prefs.setString('user', jsonEncode(sendData));
      var account = await get('/services/uaa/api/account');
      var checkAccess = false;
      for (var i = 0; i < account['authorities'].length; i++) {
        if (account['authorities'][i] == 'ROLE_LOYALTY_USER') {
          checkAccess = true;
        }
      }
      if (checkAccess) {
        Get.offAllNamed('/');
      } else {
        // у вас нету доступа
      }
    }
  }

  checkIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      final user = jsonDecode(prefs.getString('user')!);
      if (user['isRemember']) {
        setState(() {
          sendData['isRemember'] = user['isRemember'];
          sendData['username'] = user['username'];
          sendData['password'] = user['password'];
          data['username'].text = maskFormatter.maskText(user['username'].substring(3, user['username'].length));
          data['password'].text = user['password'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsRemember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          'Tizimga kirish',
          style: TextStyle(
            color: black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 24, left: 24, top: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Salom, Xush kelibsiz! 👋',
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
                    'Quyidagi formalarni to’ldirib Tizimga kiring',
                    style: TextStyle(
                      color: grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Telefon',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    controller: data['username'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required_field'.tr;
                      }
                      return null;
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
                      hintText: 'Telefon raqamingizni kiriting',
                      hintStyle: TextStyle(color: grey),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Parol',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    obscureText: showPassword,
                    controller: data['password'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required_field'.tr;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      sendData['password'] = value;
                    },
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
                      hintText: 'Parolingizni kiriting',
                      hintStyle: TextStyle(color: grey),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sendData['isRemember'] = !sendData['isRemember'];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: black, width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: sendData['isRemember']
                                ? Icon(
                                    Icons.check,
                                    color: black,
                                    size: 16,
                                  )
                                : Container(),
                          ),
                        ),
                        const Text(
                          'Meni eslab qol',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: linkColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Parolni unutdingizmi?',
                        style: TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/register');
                  },
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 32),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            login();
          },
          child: Text(
            'Tizimga kirish',
            style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
