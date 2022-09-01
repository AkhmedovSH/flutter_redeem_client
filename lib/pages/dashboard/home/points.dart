import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:control_car_client/components/simple_app_bar.dart';
import 'package:get/get.dart';

import '../../../helpers/helper.dart';

class Points extends StatefulWidget {
  const Points({Key? key}) : super(key: key);

  @override
  State<Points> createState() => _PointsState();
}

class _PointsState extends State<Points> {
  dynamic poses = [];

  getPoses() async {
    final response = await get('/services/mobile/api/get-balance');
    print(response);
    setState(() {
      poses = response;
    });
  }

  inFavorite(id, status) async {
    final response = await post('/services/mobile/api/pos-favorite', {
      "posId": id,
      "status": status,
    });
    if (response != null) {
      getPoses();
    }
  }

  @override
  void initState() {
    super.initState();
    getPoses();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: SimpleAppBar(
        appBar: AppBar(),
        title: 'Barcha ballar',
        leading: true,
        bgcolor: Colors.transparent,
        appBarColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = 0; i < poses.length; i++)
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/gas-detail', arguments: poses[i]['id']);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.3),
                      border: Border(
                        bottom: BorderSide(
                          color: white,
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
                                    poses[i]['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Ceshback: ${(poses[i]['maxReward'] * 100).round() / 100} %',
                                  style: const TextStyle(
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
                            // SvgPicture.asset('images/icons/star.svg'),
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
                            Text(
                              '${poses[i]['balance'] ?? ''} b.',
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
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
    );
  }
}
