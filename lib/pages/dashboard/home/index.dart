import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers/helper.dart';

open() {}

class Index extends StatefulWidget {
  final Function openDrawer;
  final Function hideDrawer;

  const Index({Key? key, this.openDrawer = open, this.hideDrawer = open}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  dynamic poses = [];

  inFavorite(status) async {
    final response = await post('/services/mobile/api/pos-favorite', {
      "posId": Get.arguments,
      "status": status,
    });
    if (response != null) {
      getPoses();
    }
  }

  getPoses() async {
    final response = await get('/services/mobile/api/pos-search?&pointX&pointY&distance', payload: {
      'search': '',
      'pointX': '',
      'pointY': '',
      'distance': '',
    });

    setState(() {
      poses = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getPoses();
  }

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
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
            leading: Container(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      '80435',
                      style: TextStyle(
                        color: lightGrey,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Joriy oy: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: lightGrey,
                            ),
                          ),
                          Text(
                            '68',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: lightGrey,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/points');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 0.25),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(
                                  'Barchasi',
                                  style: TextStyle(
                                    color: lightGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: lightGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
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
                        Column(
                          children: [
                            for (var i = 0; i < poses.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/gas-detail', arguments: poses[i]['id']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFCED4D8),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            child: poses[i]['logoUrl'] != null && poses[i]['logoUrl'] != ''
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Image.network(
                                                      mainUrl + poses[i]['logoUrl'],
                                                      fit: BoxFit.fill,
                                                      width: 58,
                                                      height: 58,
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    width: 58,
                                                    height: 58,
                                                  ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.5,
                                                margin: const EdgeInsets.only(bottom: 8),
                                                child: Text(
                                                  poses[i]['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Text(
                                                'Cashback: 6%',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // poses[i]['favorite']
                                          //     ? GestureDetector(
                                          //         onTap: () {
                                          //           inFavorite(false);
                                          //         },
                                          //         child: SvgPicture.asset('images/icons/star_active.svg'),
                                          //       )
                                          //     : GestureDetector(
                                          //         onTap: () {
                                          //           inFavorite(true);
                                          //         },
                                          //         child: SvgPicture.asset('images/icons/star.svg'),
                                          //       ),
                                          // SvgPicture.asset('images/icons/star.svg'),
                                          // Container(
                                          //   margin: const EdgeInsets.only(bottom: 10),
                                          //   child: SvgPicture.asset('images/icons/star_active.svg'),
                                          // ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 5),
                                                child: SvgPicture.asset('images/icons/waves.svg'),
                                              ),
                                              Text(
                                                '${poses[i]['distance']} km',
                                                style: TextStyle(
                                                  color: grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.09,
          // left: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              'Umumumiy ballar',
              style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.09,
          child: GestureDetector(
            onTap: () {
              widget.openDrawer();
            },
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.all(8),
              decoration: iconBorder,
              child: SvgPicture.asset(
                'images/icons/burger_group.svg',
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.09,
          right: 0,
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: iconBorder,
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/notifications');
              },
              child: SvgPicture.asset(
                'images/icons/notification.svg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
