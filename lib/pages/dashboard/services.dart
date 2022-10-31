import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:control_car_client/helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

import 'package:control_car_client/components/simple_app_bar.dart';

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
  dynamic oil = {'percent': 0.0};
  dynamic methane = {'percent': 0.0};
  dynamic insurance = {'percent': 0.0};
  dynamic license = {'percent': 0.0};
  dynamic inspection = {'percent': 0.0};
  dynamic toning = {'percent': 0.0};

  getPercent(date) {
    dynamic currentDay = DateTime.now();
    final beginDate = DateTime(
      int.parse(date['beginDate'].substring(0, 4)),
      int.parse(date['beginDate'].substring(5, 7)),
      int.parse(date['beginDate'].substring(8, 10)),  
    );
    final endDate = DateTime(
      int.parse(date['endDate'].substring(0, 4)),
      int.parse(date['endDate'].substring(5, 7)),
      int.parse(date['endDate'].substring(8, 10)),
    );
    print(endDate.difference(beginDate).inDays);
    print(currentDay.difference(beginDate).inDays);
    if (currentDay.difference(beginDate).inDays < 0 || currentDay.difference(beginDate).inDays == 0) {
      return 0.0;
    }
    if (currentDay.difference(beginDate).inDays > 0) {
      dynamic hundred = endDate.difference(beginDate).inDays;
      dynamic other = currentDay.difference(beginDate).inDays;
      dynamic percent = (double.parse(((other) / hundred).toStringAsFixed(1)));
      if (percent < 0) {
        return 1.0;
      }
      return percent < 1.0 ? percent : 1.0;
    }
    return 0.0;
  }

  getOil() async {
    final response = await get('/services/mobile/api/oil');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        oil = response;
      });
    }
  }

  getMethane() async {
    final response = await get('/services/mobile/api/methane');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        methane = response;
      });
    }
  }

  getInsurance() async {
    final response = await get('/services/mobile/api/insurance');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        insurance = response;
      });
    }
  }

  getLicense() async {
    final response = await get('/services/mobile/api/license');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        license = response;
      });
    }
  }

  getInspection() async {
    final response = await get('/services/mobile/api/inspection');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        inspection = response;
      });
    }
  }

  getToning() async {
    final response = await get('/services/mobile/api/toning');
    if (response != null) {
      if (response['beginDate'] != null) {
        response['percent'] = getPercent(response);
      } else {
        response['percent'] = 0.0;
      }
      setState(() {
        toning = response;
      });
    }
  }

  getData() async {
    getOil();
    getMethane();
    getInsurance();
    getLicense();
    getInspection();
    getToning();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      appBar: AppBar(),
      title: 'Avtomobil',
      leading: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // const SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   margin: const EdgeInsets.only(top: 20),
            //   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            //   decoration: BoxDecoration(
            //     color: white,
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         width: 38,
            //         height: 38,
            //         padding: const EdgeInsets.all(4),
            //         margin: const EdgeInsets.only(bottom: 10),
            //         decoration: BoxDecoration(
            //           color: const Color(0xFFE8E8E8),
            //           borderRadius: BorderRadius.circular(50),
            //         ),
            //         child: const Icon(
            //           Icons.videocam_rounded,
            //           size: 20,
            //           color: Color(0xFF939393),
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(bottom: 5),
            //         child: const Text(
            //           'Штрафы',
            //           style: TextStyle(
            //             color: Color(0xFF747474),
            //             fontSize: 18,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(bottom: 10),
            //         child: const Text(
            //           'Все хорошо',
            //           style: TextStyle(
            //             color: Color(0xFFA9A9A9),
            //             fontSize: 22,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         margin: const EdgeInsets.only(bottom: 10),
            //         child: const Text(
            //           'нет штрафов',
            //           style: TextStyle(
            //             color: Color(0xFFB6B6B6),
            //             fontSize: 16,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      dynamic result;
                      if (methane['id'] == null) {
                        result = await Get.toNamed('/methane');
                      } else {
                        result = await Get.toNamed('/methane', arguments: {
                          'id': methane['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getMethane();
                      }
                    },
                    child: Container(
                      height: 170,
                      margin: const EdgeInsets.only(top: 10, right: 5),
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
                              Icons.tire_repair,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Gaz balon',
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
                              '${methane['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: methane['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: methane['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: methane['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${methane['endDate'] ?? ''}',
                            style: TextStyle(
                              color: methane['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
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
                  child: GestureDetector(
                    onTap: () async {
                      dynamic result;
                      if (inspection['id'] == null) {
                        result = await Get.toNamed('/inspection');
                      } else {
                        result = await Get.toNamed('/inspection', arguments: {
                          'id': inspection['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getInspection();
                      }
                    },
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
                              Icons.engineering,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Texnik ko\'rik',
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
                              '${inspection['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: inspection['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: inspection['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: inspection['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${inspection['endDate'] ?? ''}',
                            style: TextStyle(
                              color: inspection['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
                    onTap: () async {
                      dynamic result;
                      if (oil['id'] == null) {
                        result = await Get.toNamed('/oil');
                      } else {
                        result = await Get.toNamed('/oil', arguments: {
                          'id': oil['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getOil();
                      }
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
                              Icons.oil_barrel,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Moy',
                              style: TextStyle(
                                color: Color(0xFF747474),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${oil['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: oil['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: oil['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: oil['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${oil['endDate'] ?? ''}',
                            style: TextStyle(
                              color: oil['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
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
                  child: GestureDetector(
                    onTap: () async {
                      dynamic result;
                      if (toning['id'] == null) {
                        result = await Get.toNamed('/toning');
                      } else {
                        result = await Get.toNamed('/toning', arguments: {
                          'id': toning['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getToning();
                      }
                    },
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
                              Icons.brightness_6,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Tonirovka',
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
                              '${toning['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: toning['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: toning['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: toning['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${toning['endDate'] ?? ''}',
                            style: TextStyle(
                              color: toning['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
                    onTap: () async {
                      dynamic result;
                      if (insurance['id'] == null) {
                        result = await Get.toNamed('/insurance');
                      } else {
                        result = await Get.toNamed('/insurance', arguments: {
                          'id': insurance['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getInsurance();
                      }
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
                              Icons.car_crash,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Sug\'urta',
                              style: TextStyle(
                                color: Color(0xFF747474),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${insurance['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: insurance['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: insurance['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: insurance['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${insurance['endDate'] ?? ''}',
                            style: TextStyle(
                              color: insurance['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
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
                  child: GestureDetector(
                    onTap: () async {
                      dynamic result;
                      if (license['id'] == null) {
                        result = await Get.toNamed('/license');
                      } else {
                        result = await Get.toNamed('/license', arguments: {
                          'id': license['id'],
                        });
                      }
                      if (result != null && result == 1) {
                        getLicense();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, left: 5),
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
                              Icons.groups,
                              size: 20,
                              color: Color(0xFF939393),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              'Ishonchnoma',
                              style: TextStyle(
                                color: Color(0xFF747474),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${license['expDay'] ?? "0"} kun',
                              style: TextStyle(
                                color: license['percent'] > 0.8 ? danger : const Color(0xFF222222),
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
                              percent: license['percent'] ?? 0,
                              barRadius: const Radius.circular(20),
                              backgroundColor: const Color(0xFFE8E8E8),
                              progressColor: license['percent'] > 0.8 ? danger : green,
                            ),
                          ),
                          Text(
                            '${license['endDate'] ?? ''}',
                            style: TextStyle(
                              color: license['percent'] > 0.8 ? danger : const Color(0xFF7F7F7F),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
