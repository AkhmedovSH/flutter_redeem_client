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
  connectTimeout: 20 * 1000, // 10 seconds
  receiveTimeout: 20 * 1000, // 10 seconds
);
var dio = Dio(options);

Future get(String url, {payload}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
  } on DioError catch (e) {
    statuscheker(e);
  }
}

Future post(String url, dynamic payload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
  } on DioError catch (e) {
    statuscheker(e);
  }
}

Future guestGet(String url, {payload}) async {
  try {
    final response = await dio.get(
      hostUrl + url,
      queryParameters: payload,
      options: Options(headers: {
        "Language": "uz-Latn-UZ",
        "Accept-Language": "uz-Latn-UZ",
      }),
    );
    return response.data;
  } on DioError catch (e) {
    statuscheker(e);
  }
}

Future guestPost(String url, dynamic payload) async {
  try {
    final response = await dio.post(hostUrl + url, data: payload);
    return response.data;
  } on DioError catch (e) {
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
  } on DioError catch (e) {
    statuscheker(e);
  }
}

Future delete(String url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    final response = await dio.delete(
      hostUrl + url,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString('access_token')}",
          "Language": "uz-Latn-UZ",
          "Accept-Language": "uz-Latn-UZ",
        },
      ),
    );
    return response.data;
  } on DioError catch (e) {
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
  } on DioError catch (e) {
    statuscheker(e);
  }
}

statuscheker(e) async {
  String jsonsDataString = e.response.toString();
  final jsonData = jsonDecode(jsonsDataString);
  if (e.response?.statusCode == 400) {
    showErrorToast(jsonData['message']);
  }
  if (e.response?.statusCode == 401) {
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
    showErrorToast(jsonData['message']);
  }
}
