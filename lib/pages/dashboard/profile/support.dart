import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:animate_icons/animate_icons.dart';

import 'package:control_car_client/helpers/helper.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  dynamic support = [
    {
      'title': 'Lorem ipsum dolor sit amet',
      'show': false,
      'controller': AnimateIconController(),
      'childText':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
    },
    {
      'title': 'Lorem ipsum dolor sit amet',
      'show': false,
      'controller': AnimateIconController(),
      'childText':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
    },
    {
      'title': 'Lorem ipsum dolor sit amet',
      'show': false,
      'controller': AnimateIconController(),
      'childText':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
    },
    {
      'title': 'Lorem ipsum dolor sit amet',
      'show': false,
      'controller': AnimateIconController(),
      'childText':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
    },
  ];

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
              margin: const EdgeInsets.only(bottom: 24, right: 24, left: 24, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: TextFormField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9CA4AB),
                          ),
                          hintText: 'izlash...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA4AB),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFE3E9ED),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFE3E9ED),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (var i = 0; i < support.length; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (support[i]['show']) {
                                    setState(() {
                                      support[i]['show'] = false;
                                    });
                                    support[i]['controller'].animateToStart();
                                  } else {
                                    setState(() {
                                      support[i]['show'] = true;
                                    });
                                    support[i]['controller'].animateToEnd();
                                  }
                                },
                                child: Text(
                                  support[i]['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              AnimateIcons(
                                startIcon: Icons.keyboard_arrow_down_rounded,
                                endIcon: Icons.expand_less_rounded,
                                size: 24,
                                controller: support[i]['controller'],
                                startTooltip: 'Icons.add_circle',
                                endTooltip: 'Icons.add_circle_outline',
                                onStartIconPress: () {
                                  setState(() {
                                    support[i]['show'] = true;
                                  });
                                  return true;
                                },
                                onEndIconPress: () {
                                  setState(() {
                                    support[i]['show'] = false;
                                  });
                                  return true;
                                },
                                duration: const Duration(milliseconds: 200),
                                startIconColor: black,
                                endIconColor: black,
                                clockwise: false,
                              ),
                            ],
                          ),
                          AnimatedContainer(
                            height: support[i]['show'] ? 90 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              support[i]['childText'],
                              style: const TextStyle(
                                color: Color(0xFF9CA4AB),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
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
                  'Yordam',
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
