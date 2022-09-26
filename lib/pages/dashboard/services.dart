import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:control_car_client/helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  dynamic items = [
    {'name': 'Sug’urta', 'icon': 'images/icons/sugutra.svg', 'active': false},
    {'name': 'Texnik ko’rik', 'icon': 'images/icons/texnik_korik.svg', 'active': false},
    {'name': 'Moy almashtirish', 'icon': 'images/icons/moy_almashtirish.svg', 'active': false},
    {'name': 'Tonirovka', 'icon': 'images/icons/tanirovka.svg', 'active': false},
    {'name': 'Gaz balon', 'icon': 'images/icons/gas_balon.svg', 'active': false}
  ];
  dynamic oil = {};

  getOil() async {
    final response = await get('/services/mobile/api/oil');
    print(response);
    setState(() {
      oil = response;
    });
  }

  @override
  void initState() {
    getOil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My auto',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFEEEEEE),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      ),
      body: Container(
        color: const Color(0xFFEEEEEE),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.videocam_rounded,
                          size: 20,
                          color: Color(0xFF939393),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          'Штрафы',
                          style: TextStyle(
                            color: Color(0xFF747474),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Все хорошо',
                          style: TextStyle(
                            color: Color(0xFFA9A9A9),
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'нет штрафов',
                          style: TextStyle(
                            color: Color(0xFFB6B6B6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, right: 5),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        height: 170,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.badge_outlined,
                                size: 20,
                                color: Color(0xFF939393),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Страховка',
                                style: TextStyle(
                                  color: Color(0xFF747474),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'OSAGO',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '78 дней',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 170,
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.speed_rounded,
                                size: 20,
                                color: Color(0xFF939393),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Тех. осмотр',
                                style: TextStyle(
                                  color: Color(0xFF747474),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'Технический осмотр не найден',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 212, 71, 118),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, right: 5),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        height: 170,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.badge_outlined,
                                size: 20,
                                color: Color(0xFF939393),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Доверенность',
                                style: TextStyle(
                                  color: Color(0xFF747474),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                '442 дней',
                                style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: LinearPercentIndicator(
                                padding: const EdgeInsets.all(0),
                                lineHeight: 7.0,
                                percent: 0.5,
                                barRadius: const Radius.circular(20),
                                backgroundColor: const Color(0xFFE8E8E8),
                                progressColor: green,
                              ),
                            ),
                            const Text(
                              '10 - дек. 2023',
                              style: TextStyle(
                                color: Color(0xFF7F7F7F),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 170,
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.tonality,
                                size: 20,
                                color: Color(0xFF939393),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Тонировка',
                                style: TextStyle(
                                  color: Color(0xFF747474),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                'Истекло',
                                style: TextStyle(
                                  color: danger,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: LinearPercentIndicator(
                                padding: const EdgeInsets.all(0),
                                lineHeight: 7.0,
                                percent: 1,
                                barRadius: const Radius.circular(20),
                                backgroundColor: const Color(0xFFE8E8E8),
                                progressColor: danger,
                              ),
                            ),
                            const Text(
                              '23 - сент. 2022',
                              style: TextStyle(
                                color: Color.fromARGB(255, 212, 71, 118),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/oil');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, right: 5),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          height: 170,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.local_gas_station_rounded,
                                  size: 20,
                                  color: Color(0xFF939393),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  'Масло',
                                  style: TextStyle(
                                    color: Color(0xFF747474),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  '76 дней',
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: LinearPercentIndicator(
                                  padding: const EdgeInsets.all(0),
                                  lineHeight: 7.0,
                                  percent: 0.05,
                                  barRadius: const Radius.circular(20),
                                  backgroundColor: const Color(0xFFE8E8E8),
                                  progressColor: green,
                                ),
                              ),
                              const Text(
                                '09 - дек. 2023',
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 170,
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.local_gas_station_rounded,
                                size: 20,
                                color: Color(0xFF939393),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Газ',
                                style: TextStyle(
                                  color: Color(0xFF747474),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: const Text(
                                '361 дней',
                                style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: LinearPercentIndicator(
                                padding: const EdgeInsets.all(0),
                                lineHeight: 7.0,
                                percent: 0,
                                barRadius: const Radius.circular(20),
                                backgroundColor: const Color(0xFFE8E8E8),
                                progressColor: danger,
                              ),
                            ),
                            const Text(
                              '20 - сент. 2023',
                              style: TextStyle(
                                color: Color(0xFF7F7F7F),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
    // return SimpleAppBar(
    //   appBar: AppBar(),
    //   title: 'Xizmatlar',
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         for (var i = 0; i < items.length; i++)
    //           Container(
    //             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    //             margin: const EdgeInsets.only(bottom: 8),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Container(
    //                       margin: const EdgeInsets.only(right: 12),
    //                       padding: const EdgeInsets.all(12),
    //                       width: 40,
    //                       height: 40,
    //                       decoration: BoxDecoration(
    //                         color: const Color(0XFFE1ECFB),
    //                         borderRadius: BorderRadius.circular(50),
    //                       ),
    //                       child: SvgPicture.asset(
    //                         items[i]['icon'],
    //                         fit: BoxFit.fill,
    //                       ),
    //                     ),
    //                     Text(
    //                       items[i]['name'],
    //                       style: TextStyle(
    //                         color: black,
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.w500,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   child: const Icon(
    //                     Icons.arrow_forward_ios,
    //                     color: Color(0xFFA1A1A1),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
