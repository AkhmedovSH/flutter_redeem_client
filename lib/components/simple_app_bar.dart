import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../helpers/helper.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBar? appBar;
  final Widget? body;
  final bool? leading;
  final Color? bgcolor;
  final Color? appBarColor;
  const SimpleAppBar({
    Key? key,
    this.title,
    @required this.appBar,
    this.leading = false,
    @required this.body,
    this.bgcolor = Colors.white,
    this.appBarColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/home_bg.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            gradient: gradient,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(),
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SafeArea(
              child: body!,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          // left: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              title!,
              style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ),
        leading!
            ? Positioned(
                top: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 18),
                        padding: const EdgeInsets.only(left: 8),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(
                            color: const Color(0xFF859EAD),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF3D708F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar!.preferredSize.height);
}
