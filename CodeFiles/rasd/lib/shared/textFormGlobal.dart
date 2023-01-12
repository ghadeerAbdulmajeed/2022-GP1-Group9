import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:regexed_validator/regexed_validator.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal({
    Key? key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obsecure,
    required this.isLogin,
    this.passController,
  }) : super(key: key);
  final TextEditingController controller;
  final TextEditingController? passController;
  final String text;
  final TextInputType textInputType;
  final bool obsecure;
  final bool isLogin;
  bool validateEmail(value) {
    bool emailValid =
        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
    if (emailValid == true) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePassword(value) {
    bool passwordValid = RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[.!@#\$&**~_|\\/-]).{8,}$")
        .hasMatch(value);
    if (passwordValid == true) {
      return true;
    } else {
      return false;
    }
  }

// need more vaildtion
  bool validatePhoneNumber(value) {
    final phoneRegExp = RegExp(r"^\+?05[0-9]{8}$");
    return phoneRegExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final bool? arLnag =
        "enterDIP".tr == 'Enter your dashcam IP' ? false : true;
    final bool? arLnag2 = "email".tr == 'Email' ? false : true;
    return Stack(
      children: [
        Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ])),
        Container(
          padding: const EdgeInsets.only(top: 3, left: 15),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) {
              if (text == 'email'.tr) {
                if (val!.isEmpty) {
                  return 'enterE'.tr;
                } else if (!validateEmail(val)) {
                  return 'invalidE'.tr;
                }
              } else if (text == 'pass'.tr && isLogin) {
                if (val!.isEmpty) {
                  return 'enterPass'.tr;
                }
              } else if (text == 'FN'.tr) {
                if (val!.isEmpty) {
                  return 'enterFN0'.tr;
                } else {
                  if (!RegExp(r"^[\u0621-\u064A ]+$").hasMatch(val) &&
                      (!RegExp(r"^[a-zA-Z ]+$").hasMatch(val))) {
                    if (arLnag2 == true) {
                      return 'FLValidation'.tr + "";
                    } else {
                      return 'FLValidation'.tr;
                    }
                  }
                }
              } //fname

              else if (text == 'LN'.tr) {
                if (val!.isEmpty) {
                  return 'enterLN0'.tr;
                } else {
                  if (!RegExp(r"^[\u0621-\u064A ]+$").hasMatch(val) &&
                      (!RegExp(r"^[a-zA-Z ]+$").hasMatch(val))) {
                    if (arLnag2 == true) {
                      return 'FLValidation'.tr;
                    } else {
                      return 'FLValidation'.tr;
                    }
                  }
                }
              } else if (text == 'pass'.tr && !isLogin) {
                if (val!.isEmpty) {
                  return 'enterPass'.tr;
                } else if (!validatePassword(val)) {
                  return '8charactersValidation'.tr;
                }
              } else if (text == 'confPass'.tr && !isLogin) {
                if (val!.isEmpty) {
                  return 'enterPass'.tr;
                } else if (val != passController!.text) {
                  return 'noMatchPass'.tr;
                }
              } else if (text == 'enterDIP'.tr) {
                if (val!.isEmpty) {
                  return 'enterDIP'.tr;
                } else if (!validator.ip(val)) {
                  return 'ipForm'.tr;
                }
              } else if (text == 'Enter your dashcam Password') {
                if (val!.isEmpty) {
                  return 'Enter your dashcam Password';
                }
              } else if (text == 'Enter your dashcam Username') {
                if (val!.isEmpty) {
                  return 'Enter your dashcam Username';
                }
              } //phone number vailditionkk
              else if (text == 'Phone Number') {
                if (val!.isEmpty) {
                  return 'Enter your phone number';
                } else if (!validatePhoneNumber(val)) {
                  return 'invalid phone number';
                }
              }
            },
            controller: controller,
            keyboardType: textInputType,
            obscureText: obsecure,
            decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: GlobalColors.mainColorRed,
                    fontSize: isLogin ? 15.0 : 15.0),
                hintText: text,
                border: InputBorder.none,
                contentPadding: arLnag! || arLnag2!
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.all(0),
                hintStyle: const TextStyle(
                  height: 1,
                )),
          ),
        ),
      ],
    );
  }
}
