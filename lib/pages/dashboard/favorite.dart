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
  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      appBar: AppBar(),
      title: 'Saqlanganlar',
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < 5; i++)
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
                          child: Image.asset('images/index_1.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Text(
                                'Mustang gaz quyis...',
                                style: TextStyle(
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
                              '2km',
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
    );
  }
}
