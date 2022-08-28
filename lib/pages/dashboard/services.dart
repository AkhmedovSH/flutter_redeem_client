import 'package:flutter/material.dart';

import 'package:control_car_client/components/simple_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:control_car_client/helpers/helper.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  dynamic items = [
    {
      'name': 'Sug’urta',
      'icon': 'images/icons/sugutra.svg',
      'active': false,
    },
    {
      'name': 'Texnik ko’rik',
      'icon': 'images/icons/texnik_korik.svg',
      'active': false,
    },
    {
      'name': 'Moy almashtirish',
      'icon': 'images/icons/moy_almashtirish.svg',
      'active': false,
    },
    {
      'name': 'Tonirovka',
      'icon': 'images/icons/tanirovka.svg',
      'active': false,
    },
    {
      'name': 'Gaz balon',
      'icon': 'images/icons/gas_balon.svg',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleAppBar(
      appBar: AppBar(),
      title: 'Xizmatlar',
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < items.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0XFFE1ECFB),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: SvgPicture.asset(
                            items[i]['icon'],
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                          items[i]['name'],
                          style: TextStyle(
                            color: black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFA1A1A1),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
