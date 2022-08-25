import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/helper.dart';
import '../../../helpers/api.dart';

class GasDetail extends StatefulWidget {
  const GasDetail({Key? key}) : super(key: key);

  @override
  State<GasDetail> createState() => _GasDetailState();
}

class _GasDetailState extends State<GasDetail> {
  dynamic pos = {};

  inFavorite(status) async {
    final response = await post('/services/mobile/api/pos-favorite', {
      "posId": Get.arguments,
      "status": status,
    });
    if (response != null) {
      getPos();
    }
  }

  getPos() async {
    final response = await get('/services/mobile/api/pos/${Get.arguments}', payload: {
      'pointX': '',
      'pointY': '',
    });
    setState(() {
      pos = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getPos();
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: pos['logoUrl'] != null && pos['logoUrl'] != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        mainUrl + pos['logoUrl'],
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
                                    pos['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Text(
                                  'Ceshback: 6%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pos['favorite'] != null && pos['favorite']
                                ? GestureDetector(
                                    onTap: () {
                                      inFavorite(false);
                                    },
                                    child: SvgPicture.asset('images/icons/star_active.svg'),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      inFavorite(true);
                                    },
                                    child: SvgPicture.asset('images/icons/star.svg'),
                                  )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Mustang zapravka siz va do’stlaringiz uchun  aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
                      style: TextStyle(color: black, fontSize: 16),
                    ),
                  ),
                  pos['galleryList'] != null
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (var i = 0; i < pos['galleryList'].length; i++)
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      mainUrl + pos['galleryList'][i],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 25),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: linkColor,
                            size: 32,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: linkColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            pos['address'] ?? '',
                            style: TextStyle(color: linkColor, fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: pos['phone'],
                      );
                      await launchUrl(launchUri);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.phone_outlined,
                              color: linkColor,
                              size: 32,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: linkColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              pos['phone'] != null ? formatPhone(pos['phone']) : '',
                              style: TextStyle(color: linkColor, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
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
                  pos['name'] ?? '',
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
