import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../helpers/api.dart';
import '../../../helpers/helper.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  dynamic sendData = {
    'phone': '',
    "name": "",
    "carNumber": "",
    "carTypeId": '1',
    "password": "",
    "activationCode": '',
  };
  bool showPassword = true;
  dynamic data = {
    'username': TextEditingController(text: ''),
    'password': TextEditingController(),
    'carNumberController': TextEditingController(),
    'isRemember': false,
  };
  List carTypes = [
    {'name': '', 'id': 1}
  ];

  changeCarType(newValue) {
    print(newValue);
    setState(() {
      sendData['carTypeId'] = newValue;
    });
  }

  registration() async {
    setState(() {
      sendData['phone'] = '998' + maskFormatter.getUnmaskedText();
    });
    final exist = await guestGet('/services/mobile/api/check-login?login=' + sendData['phone']);
    if (exist == null) {
      showErrorToast('phone_exist'.tr);
      return;
    }

    final response = await guestPost('/services/mobile/api/register', sendData);
    if (response != null) {
      if (response['success']) {
        Get.toNamed('/check-code', arguments: sendData);
      }
    }
  }

  getCarTypes() async {
    final response = await get('/services/mobile/api/car-type-helper');
    print(response);
    setState(() {
      sendData['carTypeId'] = response[0]['id'].toString();
      carTypes = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getCarTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          'Ro\'yxatdan o\'tish',
          style: TextStyle(
            color: black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 18),
                padding: const EdgeInsets.only(left: 8),
                width: 36,
                height: 36,
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
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(right: 24, left: 24, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Akkount yarating',
                    style: TextStyle(
                      color: black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    'Quyidagi formalarni to’ldirib Akkount yarating',
                    style: TextStyle(
                      color: grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
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
                    'Telefon',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    inputFormatters: [maskFormatter],
                    controller: data['username'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Majburiy maydon';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      focusedErrorBorder: inputBorderError,
                      errorBorder: inputBorderError,
                      filled: true,
                      fillColor: white,
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
                        padding: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          '+998',
                          style: TextStyle(color: black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                      ),
                      hintText: 'Telefon raqamingizni kiriting',
                      hintStyle: TextStyle(color: grey),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Parol',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    obscureText: showPassword,
                    controller: data['password'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Majburiy maydon';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      sendData['password'] = value;
                    },
                    decoration: InputDecoration(
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder,
                      focusedErrorBorder: inputBorderError,
                      errorBorder: inputBorderError,
                      filled: true,
                      fillColor: white,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? Icon(
                                Icons.visibility_off,
                                color: black,
                              )
                            : Icon(
                                Icons.visibility,
                                color: black,
                              ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Parolingizni kiriting',
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
                    controller: data['carNumberController'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Majburiy maydon';
                      }
                      return null;
                    },
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
                    'Mashina turini tanlang',
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
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
                        value: sendData['carTypeId'],
                        isExpanded: true,
                        hint: Text('${carTypes[0]['name']}'),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 24,
                        iconEnabledColor: black,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF313131)),
                        underline: Container(),
                        onChanged: (newValue) {
                          changeCarType(newValue);
                        },
                        items: carTypes.map((item) {
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
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            registration();
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
            'Tizimga kirish',
            style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
