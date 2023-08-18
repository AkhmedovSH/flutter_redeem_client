import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../helpers/helper.dart';
import '../../../../../helpers/api.dart';

class GasDetail extends StatefulWidget {
  const GasDetail({Key? key}) : super(key: key);

  @override
  State<GasDetail> createState() => _GasDetailState();
}

class _GasDetailState extends State<GasDetail> {
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];
  final List results = [];
  bool loading = false;

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

  getPos({id}) async {
    setState(() {
      loading = true;
    });
    final response = await get(
      '/services/mobile/api/pos/${id ?? Get.arguments}',
      payload: {'pointX': '', 'pointY': ''},
      guest: true,
    );
    response['workingDays'] = getCurrentDay(response['workingDays']);
    pos = response;
    loading = false;
    setState(() {});
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
          body: !loading
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      pos['promotionImageUrl'] != null && pos['promotionImageUrl'] != ""
                          ? GestureDetector(
                              onTap: () async {
                                final uri = Uri.parse('https://cabinet.redeem.uz/#/promotion/${pos['promotionId']}');
                                await launchUrl(uri);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20, top: 50),
                                height: 225,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  mainUrl + pos['promotionImageUrl'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        margin: pos['promotionImageUrl'] == null || pos['promotionImageUrl'] == ""
                            ? const EdgeInsets.only(bottom: 24, right: 24, left: 24, top: 50)
                            : const EdgeInsets.only(bottom: 24, right: 24, left: 24),
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
                                            : SizedBox(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: Image.asset(
                                                    'images/logo.png',
                                                    fit: BoxFit.fill,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),
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
                                          Text(
                                            'Cashback: ${pos['maxReward'] ?? ''} %',
                                            style: const TextStyle(
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
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 15),
                                        child: pos['favorite'] != null && pos['favorite']
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
                                              ),
                                      ),
                                      Text('${pos['balance'] != null ? pos['balance'].round() : ''} b.'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            pos['status'] != null
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.only(bottom: 5),
                                    width: MediaQuery.of(context).size.width,
                                    // decoration: BoxDecoration(
                                    //   border: Border(bottom: BorderSide(color: borderColor, width: 1)),
                                    // ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Hozirgi status',
                                            style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${pos['status']}',
                                              style: TextStyle(
                                                color: black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            pos['nextStatus'] != null
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.only(bottom: 5),
                                    width: MediaQuery.of(context).size.width,
                                    // decoration: BoxDecoration(
                                    //   border: Border(bottom: BorderSide(color: borderColor, width: 1)),
                                    // ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Keyingi status',
                                            style: TextStyle(
                                              color: black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${pos['nextStatus']}',
                                              style: TextStyle(
                                                color: black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            pos['workingDays'] != null
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 30, top: 10),
                                    child: Column(
                                      children: [
                                        for (var i = 0; i < pos['workingDays'].length; i++)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            padding: const EdgeInsets.only(bottom: 5),
                                            width: MediaQuery.of(context).size.width,
                                            // decoration: BoxDecoration(
                                            //   border: Border(bottom: BorderSide(color: borderColor, width: 1)),
                                            // ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 12),
                                                  child: Icon(
                                                    Icons.access_time,
                                                    color: pos['workingDays'][i]['currentDay'] ? green : black.withOpacity(0.3),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${pos['workingDays'][i]['dayName']}'.tr + ' ',
                                                    style: TextStyle(color: black),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      '${pos['workingDays'][i]['workingStartTime']} - ${pos['workingDays'][i]['workingEndTime']}',
                                                      style: TextStyle(color: black),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  )
                                : Container(),
                            pos['galleryList'] != null
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        for (var i = 0; i < pos['galleryList'].length; i++)
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                return DetailScreen(
                                                  imageUrl: mainUrl + pos['galleryList'][i],
                                                );
                                              }));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 20),
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Hero(
                                                  tag: mainUrl + pos['galleryList'][i],
                                                  child: Image.network(
                                                    mainUrl + pos['galleryList'][i],
                                                  ),
                                                ),
                                                // child: PhotoView(
                                                //   imageProvider: NetworkImage(
                                                //     mainUrl + pos['galleryList'][i],
                                                //     // fit: BoxFit.fill,
                                                //   ),
                                                //   // loadingBuilder: (context, event) => Container(
                                                //   //   child: CircularProgressIndicator(color: green),
                                                //   // ),
                                                //   heroAttributes: const PhotoViewHeroAttributes(
                                                //     tag: "someTag",
                                                //     transitionOnUserGestures: true,
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30, top: 20),
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: YandexMap(
                                  mapObjects: mapObjects,
                                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  onMapCreated: (YandexMapController yandexMapController) async {
                                    controller = yandexMapController;
                                    final placemark = PlacemarkMapObject(
                                      mapId: const MapObjectId('Pos'),
                                      point: Point(
                                        latitude: double.parse(pos['gpsPointX'].toString()),
                                        longitude: double.parse(pos['gpsPointY'].toString()),
                                      ),
                                      opacity: 0.9,
                                      icon: PlacemarkIcon.single(
                                        PlacemarkIconStyle(
                                          image: BitmapDescriptor.fromAssetImage('images/placemark.png'),
                                        ),
                                      ),
                                    );
                                    // mapObjects.removeWhere((el) => el.mapId == targetMapObjectId);
                                    mapObjects.add(placemark);
                                    await controller.moveCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: Point(
                                            latitude: pos['gpsPointX'],
                                            longitude: pos['gpsPointY'],
                                          ),
                                          zoom: 11,
                                        ),
                                      ),
                                      animation: const MapAnimation(type: MapAnimationType.linear, duration: 0),
                                    );
                                    setState(() {});
                                  },
                                ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Izohlar',
                                  style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(color: green.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          // padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: green,
                                            border: Border.all(color: white, width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Icon(
                                            Icons.star_border_purple500_sharp,
                                            color: white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.33,
                                          child: Center(
                                            child: Text(
                                              '${pos['rating']} (${pos['reviewsCount']} reviews)',
                                              style: TextStyle(color: black, fontSize: 12, fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 20),
                              child: GestureDetector(
                                onTap: () {
                                  showReviewDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: gradient,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.message_rounded,
                                          color: white,
                                        ),
                                      ),
                                      Text(
                                        'izoh qoldiring',
                                        style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            pos['reviewList'] != null
                                ? Column(
                                    children: [
                                      for (var i = 0; i < pos['reviewList'].length; i++)
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: black.withOpacity(0.1),
                                              ),
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          margin: const EdgeInsets.only(bottom: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(right: 10),
                                                          child: pos['reviewList'][i]['userImage'] != null
                                                              ? ClipRRect(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  child: Image.network(
                                                                    mainUrl + pos['reviewList'][i]['userImage'],
                                                                    width: 40,
                                                                    height: 40,
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                    color: const Color.fromARGB(255, 177, 177, 177),
                                                                    borderRadius: BorderRadius.circular(50),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons.person,
                                                                    color: white,
                                                                  ),
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * 0.44,
                                                          child: Text(
                                                            pos['reviewList'][i]['userFullName'] ?? '',
                                                            style: TextStyle(
                                                              color: black,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                      children: [
                                                        for (var j = 0; j < 5; j++)
                                                          Icon(
                                                            Icons.star,
                                                            color: j < pos['reviewList'][i]['rating'] ? Colors.amber : Colors.amber.withOpacity(0.5),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  pos['reviewList'][i]['title'],
                                                  style: TextStyle(
                                                    color: black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                pos['reviewList'][i]['message'],
                                                style: TextStyle(
                                                  color: black.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: SpinKitRing(
                    color: green,
                  ),
                ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.095,
          // left: 24,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: white,
            height: 48,
            child: Align(
              alignment: Alignment.topCenter,
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
          top: MediaQuery.of(context).size.height * 0.08,
          right: 12,
          child: GestureDetector(
            onTap: () {
              Get.toNamed('/receipt', arguments: {'id': Get.arguments});
            },
            child: const SizedBox(
              // margin: const EdgeInsets.only(left: 12),
              // padding: const EdgeInsets.only(left: 8),
              width: 48,
              height: 48,
              // decoration: BoxDecoration(
              //   color: white,
              //   border: Border.all(
              //     color: const Color(0xFF859EAD),
              //     width: 1,
              //   ),
              //   borderRadius: BorderRadius.circular(35),
              // ),
              child: Center(
                child: Icon(
                  Icons.history,
                  color: Color(0xFF3D708F),
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  dynamic commentData = {
    'title': '',
    'message': '',
    'rating': 3,
    'posId': '',
  };

  setComment() async {
    setState(() {
      commentData['posId'] = pos['id'].toString();
    });
    final response = await post('/services/mobile/api/pos-reviews', commentData);
    if (response != null) {
      getPos(id: pos['id']);
      Get.back();
    }
  }

  showReviewDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, dialogSetState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
            title: const Text(
              'Izoh',
              style: TextStyle(color: Colors.black),
              // textAlign: TextAlign.center,
            ),
            scrollable: true,
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          commentData['title'] = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          focusedErrorBorder: inputBorderError,
                          errorBorder: inputBorderError,
                          filled: true,
                          fillColor: white,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Sarlavha',
                          hintStyle: TextStyle(color: grey),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: TextFormField(
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Majburiy maydon';
                        //   }
                        //   return null;
                        // },
                        maxLines: 5, //or null
                        onChanged: (value) {
                          setState(() {
                            commentData['message'] = value;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          focusedErrorBorder: inputBorderError,
                          errorBorder: inputBorderError,
                          filled: true,
                          fillColor: white,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Tavsif...',
                          hintStyle: TextStyle(color: grey),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          glowColor: Colors.yellow.withOpacity(0.5),
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              commentData['rating'] = rating.round();
                            });
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setComment();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Saqlash',
                          style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String? imageUrl;
  const DetailScreen({Key? key, this.imageUrl = ''}) : super(key: key);
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: widget.imageUrl!,
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 4,
              backgroundDecoration: BoxDecoration(
                color: white,
              ),
              imageProvider: NetworkImage(
                widget.imageUrl!,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
