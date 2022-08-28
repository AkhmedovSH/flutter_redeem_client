import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helpers/helper.dart';
import 'package:control_car_client/helpers/api.dart';

open() {}

class Index extends StatefulWidget {
  final Function openDrawer;
  final Function hideDrawer;

  const Index({Key? key, this.openDrawer = open, this.hideDrawer = open}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  dynamic poses = [];
  dynamic filter = {
    'search': '',
    'pointX': '',
    'pointY': '',
    'distance': '',
  };
  dynamic user = {};
  dynamic unreadNotifications = 0;

  inFavorite(id, status) async {
    final response = await post('/services/mobile/api/pos-favorite', {
      "posId": id,
      "status": status,
    });
    if (response != null) {
      getPoses();
    }
  }

  getPermission() async {
    // if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
    //   print('has permission');
    // } else {
    //   print('else');
    // }
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    print(permission);
    if (permission != LocationPermission.deniedForever && permission != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          filter['pointX'] = position.latitude.toString();
          filter['pointY'] = position.longitude.toString();
        });
      }
      getPoses();
    }
  }

  getPoses() async {
    final response = await get('/services/mobile/api/pos-search', payload: filter);
    if (mounted) {
      setState(() {
        poses = response;
      });
    }
  }

  getUser() async {
    final response = await get('/services/mobile/api/account');
    if (mounted) {
      setState(() {
        user = response;
      });
    }
  }

  getUnreadNotification() async {
    final response = await get('/services/mobile/api/unread-notification');
    if (mounted) {
      setState(() {
        unreadNotifications = response['newNotification'];
      });
    }
  }

  Future refreshPage() async {
    await getUser();
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    getPoses();
    getPermission();
    getUser();
    getUnreadNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      primary: false,
      header: MaterialClassicHeader(color: green),
      onRefresh: refreshPage,
      enablePullDown: true,
      child: Stack(
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
                    margin: const EdgeInsets.only(bottom: 20, top: 50),
                    child: Center(
                      child: Text(
                        '${user['totalRewards'] != null ? user['totalRewards'].round() : ''}',
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
                              '${user['monthlyRewards'] != null ? user['monthlyRewards'].round() : ''}',
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
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    filter['search'] = '';
                                  });
                                  getPoses();
                                }
                                if (value.length >= 3) {
                                  setState(() {
                                    filter['search'] = value;
                                  });
                                  getPoses();
                                }
                              },
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
                                                        fit: BoxFit.contain,
                                                        width: 58,
                                                        height: 58,
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      width: 58,
                                                      height: 58,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: Image.asset(
                                                          'images/logo.png',
                                                          fit: BoxFit.contain,
                                                          width: 58,
                                                          height: 58,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.4,
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
                                                SizedBox(
                                                  child: Text(
                                                    'Cashback: ${(poses[i]['maxReward'] * 100).round() / 100} %',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
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
                                            poses[i]['favorite'] != null
                                                ? Container(
                                                    margin: const EdgeInsets.only(bottom: 15),
                                                    child: poses[i]['favorite']
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              inFavorite(poses[i]['id'], false);
                                                            },
                                                            child: SvgPicture.asset('images/icons/star_active.svg'),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              inFavorite(poses[i]['id'], true);
                                                            },
                                                            child: SvgPicture.asset('images/icons/star.svg'),
                                                          ),
                                                  )
                                                : Container(
                                                    margin: const EdgeInsets.only(bottom: 15),
                                                  ),
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
            top: MediaQuery.of(context).size.height * 0.095,
            // left: MediaQuery.of(context).size.width * 0.35,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Umumiy ballar',
                style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.095,
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
            top: MediaQuery.of(context).size.height * 0.095,
            right: 0,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/notifications');
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: iconBorder,
                    child: SvgPicture.asset(
                      'images/icons/notification.svg',
                    ),
                  ),
                ),
                unreadNotifications != null && unreadNotifications != ''
                    ? Positioned(
                        right: 5,
                        top: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: red,
                          ),
                          child: Center(
                              child: Text(
                            '$unreadNotifications',
                            style: TextStyle(color: white),
                          )),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
