import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/Splash.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/shared/textFormGlobal.dart';
import 'package:rasd/widget_tree.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String? errorMessageData = '';
  String? messageReset = '';
  bool isDataBasEerrorMessage = true;
  bool arLnag = "resetPass".tr == 'Reset Password' ? false : true;
  bool _formValid = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Widget _message() {
    return Text(
      isDataBasEerrorMessage
          ? (errorMessageData == '' ? '' : '$errorMessageData')
          : (messageReset == '' ? '' : '$messageReset'),
      style: TextStyle(
        fontSize: 16,
        color: isDataBasEerrorMessage
            ? GlobalColors.mainColorRed
            : GlobalColors.secondaryColorGreen,
      ),
    );
  } //_errorMessage

  void _showMessage(String Msg, bool success) {
    AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: success ? DialogType.success : DialogType.error,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: success ? 'S'.tr : 'E'.tr,
        desc: Msg,
        btnOkOnPress: () {
          if (success) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Splash()));
          } else {}
        }).show();
  }

  Widget resendButton() {
    return Container(
      alignment: Alignment.center,
      height: 47,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: _formValid
                  ? [
                      GlobalColors.mainColorGreen,
                      GlobalColors.secondaryColorGreen
                    ]
                  : [
                      Color.fromARGB(225, 4, 99, 65).withOpacity(0.4),
                      Color.fromARGB(225, 4, 99, 65).withOpacity(0.4),
                    ]),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: _formValid
                  ? Color.fromARGB(225, 4, 99, 65).withOpacity(0.27)
                  : Color.fromARGB(225, 4, 99, 65).withOpacity(0.1),
              blurRadius: 10,
            ),
          ]),
      child: TextButton(
        onPressed: _formValid
            ? () {
                resetPassword();
              }
            : null,
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: arLnag ? 85 : 115,
              alignment: arLnag ? Alignment.centerLeft : Alignment.centerRight,
              padding: EdgeInsets.only(right: arLnag ? 0 : 10),
              child: Icon(
                Icons.email_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: arLnag ? 10 : 0,
            ),
            Container(
              width: arLnag ? 180 : 150,
              child: Text(
                'resetPass'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      _showMessage('resetPassE'.tr, true);
      setState(() {
        isDataBasEerrorMessage = false;
        messageReset = 'resetPassE'.tr;
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        isDataBasEerrorMessage = true;
        if (e.code == 'user-not-found') {
          errorMessageData = 'noAccountError'.tr;
        } else {
          errorMessageData = e.message;
        }
      });
      _showMessage(errorMessageData!, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WidgetTree()));
                  },
                  child: Icon(Icons.arrow_back_ios_rounded,
                      size: 25, color: GlobalColors.mainColorGreen),
                ),
                const SizedBox(height: 70),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png',
                        height: 130, width: 130)),
                const SizedBox(height: 35),
                Text(
                  'resetPass'.tr,
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'assocE'.tr,
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                    //fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  onChanged: () {
                    setState(() {
                      if (formKey.currentState!.validate()) {
                        _formValid = true;
                      } else {
                        _formValid = false;
                      }
                    });
                  },
                  child: Column(
                    children: [
                      // Email input
                      TextFormGlobal(
                        controller: emailController,
                        text: 'email'.tr,
                        obsecure: false,
                        textInputType: TextInputType.emailAddress,
                        isLogin: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                resendButton(),
                const SizedBox(height: 12),
                //_message(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
