import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/appRoot.dart';
import '../shared/GlobalColors.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPage createState() => _VerifyEmailPage();
}

class _VerifyEmailPage extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;
  bool arLnag = "resendE".tr == 'Resend Email' ? false : true;

  @override
  void initState() {
    super.initState();

    //user needs to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 30));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      print('Error');
      print(e.toString());
    }
  }

  Widget resendButton() {
    return Container(
      alignment: Alignment.center,
      height: 47,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: canResendEmail
                  ? [
                      GlobalColors.mainColorGreen,
                      GlobalColors.secondaryColorGreen
                    ]
                  : [
                      Color.fromARGB(225, 4, 99, 65).withOpacity(0.4),
                      Color.fromARGB(225, 4, 99, 65).withOpacity(0.4)
                    ]),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: canResendEmail
                  ? Color.fromARGB(225, 4, 99, 65).withOpacity(0.27)
                  : Color.fromARGB(225, 4, 99, 65).withOpacity(0.1),
              blurRadius: 10,
            ),
          ]),
      child: TextButton(
        onPressed: canResendEmail ? sendVerificationEmail : null,
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: arLnag ? 60 : 125,
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
              width: arLnag ? 240 : 100,
              child: Text(
                'resendE'.tr,
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

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? RootApp()
      : Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/logo.png',
                            height: 130, width: 130)),
                    const SizedBox(height: 35),
                    Text(
                      'verfE'.tr,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'checkSpam'.tr,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    resendButton(),
                    const SizedBox(height: 10),
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.transparent,
                          minimumSize: Size.fromHeight(50),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text('cancel'.tr,
                            style: TextStyle(
                                color: GlobalColors.mainColorRed,
                                fontSize: 17))),
                  ],
                ),
              ),
            ),
          ),
        );
}
