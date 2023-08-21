import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_moment/simple_moment.dart';
import 'dart:ui' as ui;

// Colors

Color black = const Color(0xFF171A1C);
Color grey = const Color(0xFF666666);
Color white = const Color(0xFFFFFFFF);
Color red = const Color(0xFFdc3545);
Color green = const Color(0xFF22AE54);
Color lightGrey = const Color(0xFFFDFDFD);
Color linkColor = const Color(0xFF2995A3);

Color danger = const Color(0xFFf46a6a);

Gradient gradient = const LinearGradient(
  colors: [
    Color(0xFF00AF50),
    Color(0xFF00C3AB),
  ],
  begin: FractionalOffset(0.0, 0.0),
  end: FractionalOffset(1.0, 0.0),
  stops: [0.0, 1.0],
  tileMode: TileMode.clamp,
);

OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: const BorderSide(
    color: Color.fromARGB(255, 216, 216, 216),
    width: 1,
  ),
  borderRadius: BorderRadius.circular(5),
);

OutlineInputBorder inputBorderError = OutlineInputBorder(
  borderSide: BorderSide(
    color: danger,
    width: 1,
  ),
  borderRadius: BorderRadius.circular(5),
);

BoxDecoration iconBorder = BoxDecoration(
  color: white,
  border: Border.all(
    color: const Color(0xFF83B6D5),
    width: 1,
  ),
  borderRadius: BorderRadius.circular(50),
);

// Some variable

const mainUrl = 'https://cabinet.redeem.uz';

// Functions

getGragientWidget(child) {
  if (child == null) {
    return;
  }
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return ui.Gradient.linear(
        const Offset(4.0, 20.0),
        const Offset(20.0, 10.0),
        [
          const Color(0xFF0067C8),
          const Color(0xFF00C3AB),
        ],
        [0.0, 1.0],
        TileMode.clamp,
      );
    },
    child: child,
  );
}

formatDateMonth(date, {format="dd.MM.yyyy"}) {
  Moment rawDate = Moment.parse(date);
  return rawDate.format(format);
}

formatDateHour(date) {
  Moment rawDate = Moment.parse(date);
  return rawDate.format("HH:mm");
}

formatPhone(phone) {
  if (phone.length >= 12) {
    var x = phone.substring(0, 3);
    var y = phone.substring(3, 5);
    var z = phone.substring(5, 8);
    var d = phone.substring(8, 10);
    var q = phone.substring(10, 12);
    return '+' + x + ' ' + y + ' ' + z + ' ' + d + ' ' + q;
  } else {
    return phone;
  }
}

getCurrentDay(list) {
  DateTime date = DateTime.now();
  final day = DateFormat('EEEE').format(date);
  for (var i = 0; i < list.length; i++) {
    list[i]['currentDay'] = false;
    list[i]['workingStartTime'] =
        list[i]['workingStartTime'] != null ? list[i]['workingStartTime'].substring(0, list[i]['workingStartTime'].toString().length - 3) : '-';
    list[i]['workingEndTime'] =
        list[i]['workingEndTime'] != null ? list[i]['workingEndTime'].substring(0, list[i]['workingEndTime'].toString().length - 3) : '-';
    switch (list[i]['days']) {
      case 1:
        list[i]['dayName'] = 'Monday';
        break;
      case 2:
        list[i]['dayName'] = 'Tuesday';
        break;
      case 3:
        list[i]['dayName'] = 'Wednesday';
        break;
      case 4:
        list[i]['dayName'] = 'Thursday';
        break;
      case 5:
        list[i]['dayName'] = 'Friday';
        break;
      case 6:
        list[i]['dayName'] = 'Saturday';
        break;
      case 7:
        list[i]['dayName'] = 'Sunday';
        break;
      default:
    }
    if (list[i]['dayName'] == day) {
      list[i]['currentDay'] = true;
    }
  }
  return list;
}

showSuccessToast(message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF28a745),
      textColor: Colors.white,
      fontSize: 16.0);
}

showErrorToast(message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFFE32F45),
      textColor: Colors.white,
      fontSize: 16.0);
}
