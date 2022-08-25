import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/helper.dart';

hide() {}

class HomeDrawer extends StatefulWidget {
  final Function hideDrawer;

  const HomeDrawer({Key? key, this.hideDrawer = hide}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  dynamic user = {};

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('user');
    Get.offAllNamed('/login');
  }

  getUser() async {
    final response = await get('/services/mobile/api/account');
    if (mounted) {
      setState(() {
        user = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  buildCard(icon, text) {
    return GestureDetector(
      onTap: () async {
        if (text == 'Ulashish') {
          Get.toNamed('/change-password');
        }
        if (text == 'Yordam') {
          Get.toNamed('/support');
        }
        if (text == 'Sozlamalar') {
          await Get.toNamed('/profile-setting');
          getUser();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFF2F2F2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    icon,
                    color: black,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8E8E93),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
              leading: Container(),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: black,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          user['imageUrl'] != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF83B6D5),
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      mainUrl + user['imageUrl'],
                                      fit: BoxFit.fill,
                                      width: 72,
                                      height: 72,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 167, 167, 167),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 32,
                                    color: lightGrey,
                                  ),
                                ),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF0E1A23)),
                                ),
                                Text(
                                  user['phone'] != null ? formatPhone(user['phone']) : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0E1A23).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: const Text(
                        'Umumiy',
                        style: TextStyle(
                          color: Color(0xFF3D708F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    buildCard(Icons.share_outlined, 'Ulashish'),
                    buildCard(Icons.error_outline, 'Yordam'),
                    buildCard(Icons.settings_outlined, 'Sozlamalar'),
                    GestureDetector(
                      onTap: () {
                        logout();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(222, 29, 29, 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: const [
                            Center(
                              child: Text(
                                'Chiqish',
                                style: TextStyle(
                                  color: Color(0xFFDE1D1D),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.logout_sharp,
                              color: Color(0xFFDE1D1D),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            spreadRadius: 4,
                            blurRadius: 24,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Agarda qandaydir savolingiz bo’lsa? marhamat!',
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: const Text(
                              '+998 55 500-00-89',
                              style: TextStyle(
                                color: Color(0xFF2995A3),
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: gradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: '+998555000089',
                                );
                                await launchUrl(launchUri);
                              },
                              child: Center(
                                child: Text(
                                  'BIZ BILAN BOG’LANING',
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
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
            top: MediaQuery.of(context).size.height * 0.08,
            left: 24,
            child: GestureDetector(
              onTap: () {
                widget.hideDrawer();
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
      ),
    );
  }
}
