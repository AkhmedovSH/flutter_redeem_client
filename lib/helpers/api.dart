import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './helper.dart';

const hostUrl = "https://cabinet.redeem.uz";

BaseOptions options = BaseOptions(
  baseUrl: hostUrl,
  receiveDataWhenStatusError: true,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
);
var dio = Dio(options);

Future get(String url, {payload, guest = false}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!guest) {
    if (prefs.getString('user') == null) {
      getx.Get.toNamed('/login', arguments: 1);
      return;
    }
  }
  if (prefs.getString('access_token') != null) {
    dio.options.headers["authorization"] = "Bearer ${prefs.getString('access_token')}";
  }
  dio.options.headers["Accept"] = "application/json";
  dio.options.headers["Language"] = "uz-Latn-UZ";
  dio.options.headers["Accept-Language"] = "uz-Latn-UZ";

  try {
    final response = await dio.get(
      hostUrl + url,
      queryParameters: payload,
    );
    return response.data;
  } catch (e) {
    statuscheker(e, prefs: prefs);
  }
}

Future post(String url, dynamic payload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('user') == null) {
    getx.Get.toNamed('/login', arguments: 1);
    return;
  }
  if (prefs.getString('access_token') != null) {
    dio.options.headers["authorization"] = "Bearer ${prefs.getString('access_token')}";
  }
  try {
    final response = await dio.post(
      hostUrl + url,
      data: payload,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString('access_token')}",
          "Language": "uz-Latn-UZ",
          "Accept-Language": "uz-Latn-UZ",
        },
      ),
    );
    return response.data;
  } catch (e) {
    statuscheker(e, prefs: prefs);
  }
}

Future guestGet(String url, {payload}) async {
  try {
    dio.options.headers["authorization"] = "";
    final response = await dio.get(
      hostUrl + url,
      queryParameters: payload,
      options: Options(headers: {
        "Language": "uz-Latn-UZ",
        "Accept-Language": "uz-Latn-UZ",
      }),
    );
    return response.data;
  } catch (e) {
    statuscheker(e);
  }
}

Future guestPost(String url, dynamic payload) async {
  try {
    dio.options.headers["authorization"] = "";
    final response = await dio.post(hostUrl + url, data: payload);
    return response.data;
  } catch (e) {
    statuscheker(e);
  }
}

Future put(String url, dynamic payload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    final response = await dio.put(
      hostUrl + url,
      data: payload,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString('access_token')}",
          "Language": "uz-Latn-UZ",
          "Accept-Language": "uz-Latn-UZ",
        },
      ),
    );
    return response.data;
  } catch (e) {
    statuscheker(e);
  }
}

uploadImage(url, File file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    final response = await dio.post(
      hostUrl + url,
      data: data,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString('access_token')}",
          "Language": "uz-Latn-UZ",
          "Accept-Language": "uz-Latn-UZ",
        },
      ),
    );
    return response.data;
  } catch (e) {
    statuscheker(e);
  }
}

statuscheker(e, {prefs}) async {
  print(e);
  print(e.response);
  if (e.response?.statusCode == 400) {
    String jsonsDataString = e.response.toString();
    final jsonData = jsonDecode(jsonsDataString);
    showErrorToast(jsonData['message']);
  }
  if (e.response?.statusCode == 401) {
    if (prefs != null) {
      if (prefs.getString('user') != null) {
        if (getx.Get.currentRoute != '/login') {
          getx.Get.offAllNamed('/login');
        }
        return;
      }
    }
    showErrorToast('incorrect_login_or_password'.tr);
  }
  if (e.response?.statusCode == 403) {}
  if (e.response?.statusCode == 404) {
    showErrorToast('not_found'.tr);
  }
  if (e.response?.statusCode == 415) {
    showErrorToast('error'.tr);
  }
  if (e.response?.statusCode == 500) {
    String jsonsDataString = e.response.toString();
    final jsonData = jsonDecode(jsonsDataString);
    showErrorToast(jsonData['message']);
  }
}
