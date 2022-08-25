import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:control_car_client/helpers/helper.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  dynamic sendData = {
    'password': '',
    'newPassword': '',
  };
  bool showPassword = true;
  bool showNewPassword = true;

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
              margin: const EdgeInsets.only(right: 24, left: 24, top: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Yangi parollingizni yarating',
                          style: TextStyle(
                            color: black,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        child: Text(
                          'Yangi parolingizni kiriting',
                          style: TextStyle(
                            color: grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Yangi parol',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
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
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(color: grey),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Parolni tasdiqlash',
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
                        obscureText: showNewPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
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
                                showNewPassword = !showNewPassword;
                              });
                            },
                            icon: showNewPassword
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
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(color: grey),
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
              onTap: () {},
              child: Text(
                'Davom etish',
                style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.095,
          // left: 24,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: DefaultTextStyle(
                style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
                child: Text(
                  'Xavfsizlik',
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
      ],
    );
  }
}
