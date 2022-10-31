import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/api.dart';
import 'package:control_car_client/helpers/helper.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic systemOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light);
  dynamic vesrion = '';
  dynamic url = 'https://play.google.com/store/apps/details?id=uz.redeem.client';
  bool isRequired = false;
  bool ios = false;

  @override
  void initState() {
    super.initState();
    checkVersion();
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      setState(() {
        ios = true;
      });
    }
    // startTimer();
  }

  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    var playMarketVersion = await guestGet('/services/admin/api/get-version?name=uz.redeem.client');
    if (playMarketVersion == null) {
      startTimer();
      return;
    }

    if (playMarketVersion['version'] != localVersion) {
      if (playMarketVersion['required']) {
        setState(() {
          isRequired = true;
        });
      }
      await showUpdateDialog();
      if (isRequired) {
        SystemNavigator.pop();
      } else {
        startTimer();
      }
    } else {
      startTimer();
    }
  }

  startTimer({milliseconds = 2000}) {
    var _duration = Duration(milliseconds: milliseconds);
    return Timer(_duration, navigate);
  }

  void navigate() async {
    Get.offAllNamed('/');
    // if (ios) {
    //   Get.offAllNamed('/');
    // } else {
    //   Get.offAllNamed('/login');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // bool lightMode =
    //     MediaQuery.of(context).platformBrightness == Brightness.light;
    return Container(
      color: green,
      // decoration: BoxDecoration(
      // gradient: gradient,
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: systemOverlayStyle,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'images/logo_1.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
                // child: SvgPicture.asset(
                //   'images/icons/logo_1.svg',
                //   color: white,
                //   width: MediaQuery.of(context).size.width * 0.8,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showUpdateDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            title: const Text(
              'Ilovani yangilash' ' "redeem"',
              style: TextStyle(color: Colors.black),
              // textAlign: TextAlign.center,
            ),
            scrollable: true,
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    isRequired
                        ? 'Ilovadan foydalanishni davom ettirish uchun eng so\'nggi versiyani o\'rnatishingiz kerak'
                            '"redeem".'
                        : 'Ilovaning so\'nggi versiyasini o\'rnatishni tavsiya qilamiz'
                            '"redeem".'
                            'Yangilanishlarni yuklab olayotganda siz undan foydalanishingiz mumkin'
                            '.',
                    style: const TextStyle(color: Colors.black, height: 1.2),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isRequired
                            ? Container()
                            : Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: danger,
                                  ),
                                  child: Text(
                                    'YO\'Q, RAHMAT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                        ElevatedButton(
                          onPressed: () {
                            if (ios) {
                              final uri = Uri.parse('https://apps.apple.com/app/id6443604263');
                              launchUrl(uri);
                            } else {
                              StoreRedirect.redirect(
                                androidAppId: "uz.redeem.client",
                                iOSAppId: "6443604263",
                              );
                            }
                            // launchUrl(url);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ios ? Colors.transparent : const Color(0xFF00865F),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'YANGILANISH',
                            style: TextStyle(
                              color: ios ? const Color(0xFF4889EE) : white,
                              fontWeight: ios ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      ios ? 'images/appstore_logo_3.png' : 'images/google_play.png',
                      height: ios ? 45 : 25,
                      width: 100,
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
