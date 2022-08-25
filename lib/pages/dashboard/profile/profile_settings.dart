import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:control_car_client/helpers/api.dart';
import 'package:control_car_client/helpers/helper.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  dynamic sendData = {
    "name": "",
    "carNumber": "",
    "carTypeId": 1,
    "gender": 1,
    "regionId": '1',
    "cityId": '1',
    "imageUrl": "",
    "birthDate": "",
  };

  dynamic data = {
    "nameController": TextEditingController(),
    "carNumberController": TextEditingController(),
    "birthDateController": TextEditingController(),
    'genderController': TextEditingController(),
  };

  List regions = [
    {'name': '', 'id': '1'}
  ];

  List cities = [
    {'name': '', 'id': '1'}
  ];

  updateAccount() async {
    print(sendData);
    final response = await put('/services/mobile/api/account', sendData);
    if (response != null) {
      if (response['success']) {
        // showSuccessToast('Muvaffaqiyatli');
      }
    }
    Get.back();
  }

  getUser() async {
    final response = await get('/services/mobile/api/account');
    print(response);
    setState(() {
      data['nameController'].text = response['name'].toString() != 'null' ? response['name'].toString() : '';
      data['carNumberController'].text = response['carNumber'].toString() != 'null' ? response['carNumber'].toString() : '';
      data['birthDateController'].text = response['birthDate'].toString() != 'null' ? response['birthDate'].toString() : '';
      data['genderController'].text = response['gender'].toString() != 'null'
          ? response['gender'].toString() == '0'
              ? 'Erkak'
              : 'Ayol'
          : '';
      selectedButton = response['gender'].toString();
      sendData['imageUrl'] = response['imageUrl'] ?? '';
      sendData['phone'] = response['phone'];
      sendData['name'] = response['name'];
      sendData['carNumber'] = response['carNumber'];
      sendData['carTypeId'] = response['carTypeId'];
      sendData['gender'] = response['gender'];
      sendData['birthDate'] = response['birthDate'];

      // sendData.removeWhere((key, value) => key == "regionId");
      // sendData.removeWhere((key, value) => key == "cityId");
      // sendData = response;
    });
  }

  Future pickImage() async {
    final source = await showImageSource(context);
    if (source == null) return;
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final response = await uploadImage('/services/mobile/api/upload/image', File(img.path));
      if (response != null) {
        setState(() {
          sendData['imageUrl'] = response['url'];
        });
      } else {
        // showErrorToast('Xato');
      }
    } on PlatformException catch (e) {
      print('ERROR: $e');
    }
  }

  getRegions() async {
    final response = await get('/services/mobile/api/region-helper');
    getCities(response[0]['id']);
    setState(() {
      regions = response;
      sendData['regionId'] = response[0]['id'].toString();
    });
  }

  getCities(id) async {
    final response = await get('/services/mobile/api/city-helper/$id');
    setState(() {
      cities = response;
      sendData['cityId'] = response[0]['id'].toString();
    });
  }

  getData() async {
    getUser();
    getRegions();
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 45),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              sendData['imageUrl'] != null && sendData['imageUrl'] != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFF83B6D5),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          mainUrl + sendData['imageUrl'],
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
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2995A3),
                                      border: Border.all(
                                        color: const Color(0xFFFEFEFE),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SizedBox(
                                      child: SvgPicture.asset(
                                        'images/icons/camera.svg',
                                        height: 16,
                                        width: 16,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sendData['name'] ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF0E1A23)),
                                ),
                                Text(
                                  sendData['phone'] != null ? formatPhone(sendData['phone']) : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0E1A23).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Ism-sharifingiz',
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        controller: data['nameController'],
                        onChanged: (value) {
                          sendData['name'] = value;
                        },
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          focusedErrorBorder: inputBorderError,
                          errorBorder: inputBorderError,
                          filled: true,
                          fillColor: white,
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'To’liq ismingizni yozing',
                          hintStyle: TextStyle(color: grey),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Mashina davlat raqami',
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Majburiy maydon';
                          }
                          return null;
                        },
                        controller: data['carNumberController'],
                        onChanged: (value) {
                          setState(() {
                            data['carNumberController'].text = value.toUpperCase();
                            data['carNumberController'].selection = TextSelection.fromPosition(
                              TextPosition(offset: data['carNumberController'].text.length),
                            );
                            sendData['carNumber'] = value.toUpperCase();
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
                          hintText: 'Davlat raqamini kiriting',
                          hintStyle: TextStyle(color: grey),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Tugilgan kuningiz',
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: GestureDetector(
                        onTap: () {
                          selectDate(context);
                        },
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: red,
                                ),
                          ),
                          child: TextFormField(
                            controller: data['birthDateController'],
                            validator: (_) {
                              if (data['birthDateController'].text == '') {
                                return 'Majburiy maydon';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_month_outlined),
                              enabled: false,
                              enabledBorder: inputBorder,
                              disabledBorder: inputBorder,
                              focusedBorder: inputBorder,
                              focusedErrorBorder: inputBorderError,
                              errorBorder: inputBorderError,
                              filled: true,
                              fillColor: white,
                              contentPadding: const EdgeInsets.all(16),
                              hintText: 'Tugilgan kuningiz',
                              hintStyle: TextStyle(color: grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Jinsingiz',
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: GestureDetector(
                        onTap: () {
                          showSelectGenger();
                        },
                        child: TextFormField(
                          controller: data['genderController'],
                          validator: (_) {
                            if (data['genderController'].text == '') {
                              return 'Majburiy maydon';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 28,
                            ),
                            enabled: false,
                            enabledBorder: inputBorder,
                            disabledBorder: inputBorder,
                            focusedBorder: inputBorder,
                            focusedErrorBorder: inputBorderError,
                            errorBorder: inputBorderError,
                            filled: true,
                            fillColor: white,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Jinsingiz',
                            hintStyle: TextStyle(color: grey),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFECF1F6),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: sendData['regionId'].isNotEmpty ? sendData['regionId'] : null,
                            isExpanded: true,
                            hint: Text('${regions[0]['name']}'),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 28,
                            ),
                            iconSize: 24,
                            iconEnabledColor: grey,
                            elevation: 16,
                            style: const TextStyle(color: Color(0xFF313131)),
                            underline: Container(),
                            onChanged: (newValue) {
                              setState(() {
                                sendData['regionId'] = newValue;
                              });
                              getCities(newValue);
                            },
                            items: regions.map((item) {
                              return DropdownMenuItem<String>(
                                value: '${item['id']}',
                                child: Text(item['name']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFECF1F6),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: sendData['cityId'].isNotEmpty ? sendData['cityId'] : null,
                            isExpanded: true,
                            hint: Text('${cities[0]['name']}'),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 28,
                            ),
                            iconSize: 24,
                            iconEnabledColor: grey,
                            elevation: 16,
                            style: const TextStyle(color: Color(0xFF313131)),
                            underline: Container(),
                            onChanged: (newValue) {
                              setState(() {
                                sendData['cityId'] = newValue;
                              });
                            },
                            items: cities.map((item) {
                              return DropdownMenuItem<String>(
                                value: '${item['id']}',
                                child: Text(item['name']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                updateAccount();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 32),
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
                  color: const Color(0xFFF2F2F5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF151517),
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
                  'Mening prifilim',
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

  dynamic selectedButton = '0';

  showSelectGenger() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: ((context, genderSetState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   child: Row(
                //     children: [
                //       Radio(
                //         value: sendData['gender'] == '0',
                //         groupValue: SingingCharacter.lafayette,
                //         onChanged: (value) {},
                //       )
                //     ],
                //   ),
                // ),
                ListTile(
                  leading: Radio(
                    value: '0',
                    groupValue: selectedButton,
                    onChanged: (value) {
                      genderSetState(() {
                        selectedButton = '0';
                        sendData['gender'] = '0';
                        data['genderController'].text = 'Erkak';
                        Get.back();
                      });
                    },
                    activeColor: green,
                  ),
                  title: const Text('Erkak'),
                  onTap: () => genderSetState(() {
                    selectedButton = '0';
                    sendData['gender'] = '0';
                    data['genderController'].text = 'Erkak';
                    Get.back();
                  }),
                ),
                ListTile(
                  leading: Radio(
                    value: '1',
                    groupValue: selectedButton,
                    onChanged: (value) {
                      genderSetState(() {
                        selectedButton = '1';
                        sendData['gender'] = '1';
                        data['genderController'].text = 'Ayol';
                        Get.back();
                      });
                    },
                    activeColor: green,
                  ),
                  title: const Text('Ayol'),
                  onTap: () => genderSetState(() {
                    selectedButton = '1';
                    sendData['gender'] = '1';
                    data['genderController'].text = 'Ayol';
                    Get.back();
                  }),
                ),
              ],
            )),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final year = DateFormat('yyyy').format(date);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(int.parse(year) + 1),
      // locale: const Locale("fr", "FR"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: green,
            colorScheme: ColorScheme.light(primary: green),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        data['birthDateController'].text = DateFormat('yyyy-MM-dd').format(picked);
        sendData['birthDate'] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.camera), child: Text('kamera'.tr)),
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.gallery), child: Text('galereya'.tr))
          ],
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('kamera'.tr),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text('galereya'.tr),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    }
  }
}
