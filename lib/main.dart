import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'helpers/helper.dart';

import 'pages/splash.dart';

import 'pages/auth/login.dart';
import 'pages/auth/register/register.dart';
import 'pages/auth/register/check_code.dart';

import 'pages/dashboard/dashboard.dart';
import 'pages/dashboard/home/points.dart';
import 'pages/dashboard/home/notifications.dart';
import 'pages/gas_detail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // translations: Messages(),
      // locale: const Locale('uz', 'UZ'),
      // fallbackLocale: const Locale('uz', 'UZ'),
      // supportedLocales: const [
      //   Locale('ru', 'RU'),
      //   Locale('uz', 'UZ'),
      // ],
      debugShowCheckedModeBanner: false,
      popGesture: true,
      defaultTransition: Transition.fade,
      theme: ThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: red,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: black,
              displayColor: black,
            ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          primary: red,
        )),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const Splash()),

        // Auth

        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/register', page: () => const Register()),
        GetPage(name: '/check-code', page: () => const CheckCode()),

        // Home
        GetPage(name: '/', page: () => const Dashboard()),
        GetPage(name: '/points', page: () => const Points()),
        GetPage(name: '/notifications', page: () => const Notifications()),
        GetPage(name: '/notifications', page: () => const Notifications()),
      ],
    );
  }
}
