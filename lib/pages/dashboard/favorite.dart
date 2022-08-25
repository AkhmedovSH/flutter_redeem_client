import 'package:control_car_client/helpers/api.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:control_car_client/components/simple_app_bar.dart';

import '../../../helpers/helper.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  dynamic poses = [];

  getFavorite() async {
    final response = await get('/services/mobile/api/pos-by-favorite-pageList', payload: {
      'search': '',
      'pointX': '',
      'pointY': '',
    });
    setState(() {
      poses = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      appBar: AppBar(),
      title: 'Saqlanganlar',
      body: Container(
        padding: poses.length == 0 ? const EdgeInsets.only(bottom: 50) : EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = 0; i < poses.length; i++)
                Container(
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
                                  poses[i]['name'] ?? '',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // SvgPicture.asset('images/icons/star.svg'),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: SvgPicture.asset('images/icons/star_active.svg'),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: SvgPicture.asset('images/icons/waves.svg'),
                              ),
                              Text(
                                '${poses[i]['distance'] ?? ''}km',
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
            ],
          ),
        ),
      ),
    );
  }
}
