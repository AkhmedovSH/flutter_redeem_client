import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../helpers/helper.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  dynamic notifications = [];
  bool loading = false;

  getNotifications() async {
    setState(() {
      loading = true;
    });
    final response = await get('/services/mobile/api/get-notification');
    setState(() {
      notifications = response;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  buildCard(imageUrl, item, {color}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                width: 48,
                height: 48,
                // decoration: BoxDecoration(
                //   color: const Color(0XFFE1ECFB),
                //   borderRadius: BorderRadius.circular(50),
                // ),
                child: imageUrl != null && imageUrl != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          mainUrl + imageUrl,
                          fit: BoxFit.contain,
                        ),
                      )
                    : SizedBox(
                        width: 58,
                        height: 58,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                // child: SvgPicture.asset(
                //   icon,
                //   height: 20,
                //   width: 20,
                //   fit: BoxFit.scaleDown,
                // ),
              ),
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              item['text'],
                              style: TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: item['readStatus'] ? FontWeight.w400 : FontWeight.w600,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 16,
          child: SizedBox(
            child: SvgPicture.asset(
              'images/icons/vertical_line.svg',
              color: item['readStatus'] ? const Color(0XFF8DBAD5) : const Color(0xFFF28F1E),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Text(
            item['time'] != null ? formatDateHour(item['time']) : '',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

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
                  notifications.length > 0 && loading
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text(
                              'Eslatmalar yo\'q',
                              style: TextStyle(
                                color: black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  for (var i = 0; i < notifications.length; i++)
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(23, 26, 28, 0),
                                      Color.fromARGB(143, 155, 163, 1),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  notifications[i]['createdDate'] != null ? formatDateMonth(notifications[i]['createdDate']) : '',
                                  style: const TextStyle(
                                    color: Color(0xFF414141),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(143, 155, 163, 1),
                                      Color.fromRGBO(23, 26, 28, 0),
                                    ],
                                    begin: FractionalOffset(0.0, 0.0),
                                    end: FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await Get.toNamed('/notification-detail', arguments: notifications[i]['id']);
                              getNotifications();
                            },
                            child: Container(
                              child: buildCard(notifications[i]['imageUrl'], {
                                'title': notifications[i]['title'],
                                'text': notifications[i]['message'],
                                'time': notifications[i]['createdDate'],
                                'readStatus': notifications[i]['readStatus'],
                              }),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.095,
          // left: 24,
          child: Container(
            height: 48,
            width: MediaQuery.of(context).size.width,
            color: white,
            child: Align(
              alignment: Alignment.topCenter,
              child: DefaultTextStyle(
                style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
                child: Text(
                  'Eslatmalar',
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
        ),
      ],
    );
  }
}
