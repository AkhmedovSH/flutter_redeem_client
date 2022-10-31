import 'dart:convert';

import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:app_settings/app_settings.dart';

import '../location_notification_service.dart';

import '../../helpers/helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  AnimationController? animationController;
  static dynamic auth = LocalAuthentication();

  dynamic sendData = {
    'username': '',
    'password': '',
    'isRemember': false,
    'signWithFingerPrint': false,
  };
  dynamic data = {
    'username': TextEditingController(text: ''),
    'password': TextEditingController(),
    'isRemember': false,
    'signWithFingerPrint': false,
  };
  bool showPassword = true;
  bool loading = false;

  login() async {
    setState(() {
      loading = true;
    });
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
        try {
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
        } catch (e) {
          print(e);
          Get.offAllNamed('/');
        }
      } else {
        // у вас нету доступа
      }
    }
    setState(() {
      loading = false;
    });
  }

  checkIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      final user = jsonDecode(prefs.getString('user')!);
      if (user['isRemember'] != null) {
        if (user['isRemember']) {
          setState(() {
            sendData['isRemember'] = user['isRemember'];
            sendData['username'] = user['username'];
            sendData['password'] = user['password'];
            sendData['signWithFingerPrint'] = user['signWithFingerPrint'] ?? false;
            data['username'].text = maskFormatter.maskText(user['username'].substring(3, user['username'].length));
            data['password'].text = user['password'];
          });
        }
      }
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  getFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      final user = jsonDecode(prefs.getString('user')!);
      print(user);
      if (user['signWithFingerPrint'] != null) {
        data['signWithFingerPrint'] = user['signWithFingerPrint'];
      }
    }
    if (prefs.getString('access_token') != null && data['signWithFingerPrint'] == true) {
      final isAvailable = await hasBiometrics();
      if (!isAvailable) return false;
      try {
        final isDeviceSupported = await auth.isDeviceSupported();
        if (!isDeviceSupported) {
          AppSettings.openSecuritySettings();
          return;
        }
        final result = await auth.authenticate(
          localizedReason: 'Ro\'yxatdan o\'tish uchun barmoq izingizni skanerlang',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
          authMessages: <AuthMessages>[
            const AndroidAuthMessages(
              signInTitle: 'Barmoq izi bilan kirish',
              cancelButton: 'Boshqa usuldan foydalaning...',
              goToSettingsButton: '',
              biometricHint: '',
            ),
            const IOSAuthMessages(
              lockOut: 'test',
              cancelButton: 'Boshqa usuldan foydalaning...',
              goToSettingsButton: 'Sozlamalar',
              goToSettingsDescription: 'Barmoq izi bilan kirish',
              localizedFallbackTitle: '',
            ),
          ],
        );
        if (result) {
          final user = jsonDecode(prefs.getString('user')!);
          setState(() {
            loading = true;
          });
          final response = await guestPost('/auth/login', user);
          prefs.setString('access_token', response['access_token'].toString());
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
          setState(() {
            loading = false;
          });
        }
      } on PlatformException catch (e) {
        print(e);
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsRemember();
    getFingerprint();
    setState(() {
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
            leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/');
              },
              icon: Icon(
                Icons.arrow_back,
                color: black,
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
                      margin: const EdgeInsets.only(bottom: 50),
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
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        inputFormatters: [maskFormatter],
                        controller: data['username'],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
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
                          hintText: 'Telefon raqamingizni yozing',
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
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        obscureText: showPassword,
                        controller: data['password'],
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
                          hintText: 'Parolingizni yozing',
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sendData['isRemember'] = !sendData['isRemember'];
                                });
                              },
                              child: const Text(
                                'Eslab qolish',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/reset-password-init');
                          },
                          child: Container(
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
                            'Ro\'yxatdan o\'tish',
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
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                login();
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
