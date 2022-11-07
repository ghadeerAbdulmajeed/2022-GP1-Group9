import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rasd/Splash.dart';
import 'package:rasd/auth.dart';
import 'package:rasd/pages/login_register_page.dart';
import 'package:rasd/pages/settings/privacy.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/shared/widgets/settings_tile.dart';
import 'package:rasd/pages/settings/account.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'العربية', 'locale': Locale('ar', 'AE')},
  ];

  bool arLnag = "Plang".tr == 'Preferred Language' ? false : true;

  updateLanguage(Locale local) {
    Get.back();
    Get.updateLocale(local);
  }

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text("choosePr".tr),
            content: Container(
              width: 10,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            updateLanguage(locale[index]['locale']);
                            if (locale[index]['name'] == 'Arabic') {
                              arLnag = true;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Splash()));
                            } else {
                              arLnag = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Splash()));
                            }
                          },
                          child: Text(locale[index]['name'])),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: GlobalColors.mainColorGreen,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  // List<bool> _isOpen;
  User? user = Auth().currentUser;
  //for signing out
  Future<void> signOut() async {
    try {
      await Auth().signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Splash()));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  //show diloag before signout
  Future<void> _showMyDialog() async {
    return AwesomeDialog(
      context: context,
      btnCancelColor: Colors.grey,
      btnOkColor: GlobalColors.secondaryColorGreen,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      // barrierColor: GlobalColors.mainColorGreen,
      title: 'Sure'.tr,
      desc: 'AreUSure'.tr,
      btnOkText: 'yes'.tr,
      btnCancelText: 'C'.tr,

      btnCancelOnPress: () {}, // will stay in the same page
      btnOkOnPress: () {
        signOut();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "sitt".tr,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.textColor),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 380,
                height: 199,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (v) {
                          return account(uid: user!.uid);
                        }));
                      },
                      child: SettingsTile(
                        color: GlobalColors.mainColorGreen,
                        icon: Ionicons.person_circle_outline,
                        title: "acc".tr,
                      ),
                      style: TextButton.styleFrom(primary: Colors.transparent),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (v) {
                          return privacy();
                        }));
                      },
                      child: SettingsTile(
                        color: GlobalColors.mainColorGreen,
                        icon: Ionicons.document_lock_outline,
                        title: "PP".tr,
                      ),
                      style: TextButton.styleFrom(primary: Colors.transparent),
                    ),
                    TextButton(
                      onPressed: () async {
                        const url =
                            'https://twitter.com/rasdgp?s=21&t=wSUpQhdTJfIKRsMi9yXcAQ';
                        if (await launch(url)) {
                          await canLaunch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: SettingsTile(
                        color: GlobalColors.mainColorGreen,
                        icon: Ionicons.logo_twitter,
                        title: "contact".tr,
                        //isArabic: arLnag,
                      ),
                      style: TextButton.styleFrom(primary: Colors.transparent),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 380,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ]),
                child: TextButton(
                    onPressed: () {
                      buildDialog(context);
                    },
                    style: TextButton.styleFrom(primary: Colors.transparent),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.translate_outlined,
                            size: 25,
                            color: GlobalColors.mainColorGreen,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(
                            "Plang".tr,
                            style: TextStyle(
                                color: GlobalColors.mainColorGreen,
                                fontSize: 17),
                          ),
                        ),
                        arLnag
                            ? SizedBox(
                                width: 100,
                              )
                            : SizedBox(
                                width: 60,
                              ),
                        Container(
                          child: Text(
                            "lang".tr,
                            style: TextStyle(
                                color: GlobalColors.mainColorGreen,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'v 1.0.0',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 47,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          GlobalColors.mainColorRed,
                          GlobalColors.secondaryColorRed
                        ]),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalColors.mainColorRed.withOpacity(0.27),
                        blurRadius: 10,
                      ),
                    ]),
                child: TextButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.transparent,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'signout'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
