import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../helpers/helper.dart';

import 'home/index.dart';
import 'home/drawer.dart';
import 'google_map_page.dart';
import 'favorite.dart';
import 'services.dart';
// import './qr_bonuse.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  AnimationController? animationController;

  int currentIndex = 0;
  dynamic uuid = '';
  dynamic levelClock = 300;
  dynamic phone = '';
  bool showQr = false;

  setShowQr({change = true}) async {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: levelClock));
    final response = await get('/services/mobile/api/get-uuid');
    print(response);
    if (response['reason'] == 'error.user.not.found') {
      showErrorToast('Xato');
      return;
    }
    if (change) {
      setState(() {
        uuid = response['reason'];
        levelClock = response['seconds'];
        showQr = !showQr;
      });
    } else {
      setState(() {
        uuid = response['reason'];
        levelClock = response['seconds'];
      });
    }
    animationController = AnimationController(vsync: this, duration: Duration(seconds: levelClock));
    animationController!.forward();
  }

  changeIndex(int index) {
    setState(() {
      showQr = false;
      currentIndex = index;
    });
  }

  buildBottomBarItem(icon, text, index) {
    return SizedBox(
      child: Column(
        children: [
          currentIndex == index
              ? getGragientWidget(
                  SvgPicture.asset(
                    icon,
                  ),
                )
              : SvgPicture.asset(
                  icon,
                  color: currentIndex == index ? linkColor : grey,
                ),
          currentIndex == index
              ? getGragientWidget(
                  Text(text),
                )
              : Text(
                  text,
                  style: TextStyle(color: grey),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Stack(
      children: [
        Scaffold(
          key: key,
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: HomeDrawer(
              hideDrawer: () => key.currentState!.closeDrawer(),
            ),
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: currentIndex,
                children: [
                  currentIndex == 0 ? Index(openDrawer: () => key.currentState!.openDrawer()) : Container(),
                  currentIndex == 1 ? const GoogleMapPage() : Container(),
                  currentIndex == 2 ? const Favorite() : Container(),
                  currentIndex == 3 ? const Services() : Container(),
                ],
              ),
              if (showQr)
                BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: gradient,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 390,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              QrImage(
                                data: uuid.toString(),
                                version: QrVersions.auto,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  uuid.toString(),
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Countdown(
                                  animation: StepTween(
                                    begin: levelClock,
                                    end: 0,
                                  ).animate(animationController!),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setShowQr(change: false);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.refresh,
                                    color: green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container()
            ],
          ),
          bottomNavigationBar: SizedBox(
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              clipBehavior: Clip.antiAlias,
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedItemColor: linkColor,
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: changeIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: buildBottomBarItem('images/icons/home.svg', 'Asosiy', 0),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: buildBottomBarItem('images/icons/map.svg', 'Xarita', 1),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: buildBottomBarItem('images/icons/star.svg', 'Sevimlilar', 2),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: buildBottomBarItem('images/icons/category.svg', 'Xizmatlar', 3),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
          // resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: keyboardIsOpened
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    setShowQr();
                  },
                  // elevation: 1,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: gradient,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/scan.png'),
                        Text(
                          'QR',
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          // child: SvgPicture.asset(
          //   'images/icons/scan.svg',
          //   color: currentIndex == 1 ? linkColor : grey,
          // ),
        ),
      ],
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, this.animation}) : super(key: key, listenable: animation!);
  final Animation<int>? animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText = '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: TextStyle(color: green, fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
