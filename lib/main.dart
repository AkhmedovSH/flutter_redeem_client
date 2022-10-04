import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:control_car_client/helpers/translations.dart';

import 'helpers/helper.dart';

import 'pages/splash.dart';

import 'pages/auth/login.dart';
import 'pages/auth/register/register.dart';
import 'pages/auth/register/check_code.dart';
import 'pages/auth/reset_password/reset_password_finish.dart';
import 'pages/auth/reset_password/reset_password_init.dart';

import 'pages/dashboard/dashboard.dart';
import 'pages/dashboard/home/points.dart';
import 'pages/dashboard/home/notifications.dart';
import 'pages/dashboard/home/notification_detail.dart';
import 'pages/dashboard/gas/gas_detail.dart';
import 'package:control_car_client/pages/dashboard/gas/receipt.dart';

import 'pages/dashboard/car/oil.dart';
import 'pages/dashboard/car/methane.dart';
import 'pages/dashboard/car/inspection.dart';
import 'pages/dashboard/car/insurance.dart';
import 'pages/dashboard/car/license.dart';
import 'pages/dashboard/car/toning.dart';

import 'pages/dashboard/profile/profile_settings.dart';
import 'pages/dashboard/profile/support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      translations: Messages(),
      locale: const Locale('uz-latn-UZ', ''),
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
            backgroundColor: red,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: black,
              displayColor: black,
            ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          backgroundColor: red,
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
        GetPage(name: '/notification-detail', page: () => const NotificationDetail()),
        GetPage(name: '/gas-detail', page: () => const GasDetail()),
        GetPage(name: '/receipt', page: () => const Receipt()),

        // Car

        GetPage(name: '/oil', page: () => const Oil()),
        GetPage(name: '/methane', page: () => const Methane()),
        GetPage(name: '/inspection', page: () => const Inspection()),
        GetPage(name: '/insurance', page: () => const Insurance()),
        GetPage(name: '/license', page: () => const License()),
        GetPage(name: '/toning', page: () => const Toning()),

        // Profile
        GetPage(name: '/profile-setting', page: () => const ProfileSetting()),
        GetPage(name: '/reset-password-init', page: () => const ResetPasswordInit()),
        GetPage(name: '/reset-password-finish', page: () => const ResetPasswordFinish()),
        GetPage(name: '/support', page: () => const Support()),
      ],
    );
  }
}
