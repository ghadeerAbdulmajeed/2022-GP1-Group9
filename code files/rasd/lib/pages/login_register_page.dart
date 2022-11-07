import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rasd/Splash.dart';
import 'package:rasd/pages/forgotPasswordPage.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/shared/textFormGlobal.dart';
import '../auth.dart';
import 'package:rasd/model/driver.dart'; //change later
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKeylogIn = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignUp = GlobalKey<FormState>();
  final TextEditingController emilController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'العربية', 'locale': Locale('ar', 'AE')},
  ];
  String? errorMessageData = '';
  String? errorMessageValid = '';
  bool isDataBasEerrorMessage = true;
  bool isLogin = true;
  bool isArabic = false;
  bool arLnag = "lang".tr == 'English' ? false : true;
  bool showPassClicked = false;
  bool isVisible = true;
  bool showPassClickedConf = false;
  bool isVisibleConf = true;
  bool showPassClickedLogin = false;
  bool isVisibleLogin = true;
  bool ppCheck = false;
  bool agremntClicked = false;
  bool registerClicked = false;
  bool _signUpValid = false;

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Splash()));
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

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: emilController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        print(e.message);
        String passIsNotCorrect =
            'The password is invalid or the user does not have a password.';
        String emailIsNotCorrect =
            'There is no user record corresponding to this identifier. The user may have been deleted.';
        String networkError =
            'A network error (such as timeout, interrupted connection or unreachable host) has occurred.';
        if (e.message == passIsNotCorrect) {
          errorMessageData = 'EmailPassError'.tr;
        } else if (e.message == emailIsNotCorrect) {
          errorMessageData = 'EmailPassError'.tr;
        } else if (e.message == networkError) {
          errorMessageData = 'networkError'.tr;
        } else {
          errorMessageData = e.message;
        }
        _showError(errorMessageData!); //**changed here ******/
      });
    }
  } //signInWithEmailAndPassword

  Future<void> createUserWithEmailAndPassword() async {
    var data = utf8.encode(passwordController.text); // data being hashed
    var hashvalue = sha1.convert(data);
    try {
      await Auth().createUserWithEmailAndPassword(
          email: emilController.text,
          password: passwordController.text,
          driver: Driver(
            Fname: firstNameController.text,
            Lname: lastNameController.text,
            dashcam_id: 'null', //later
            email: emilController.text,
            hash_pass: hashvalue.toString(),
          ));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessageData = e.message; // I think we need to translet this
        _showError(errorMessageData!); //***only here****/
      });
    }
  } //createUserWithEmailAndPassword

  bool checkValidation(GlobalKey<FormState> _formKey) {
    bool Validity = true;
    if (_formKey.currentState!.validate()) {
      isDataBasEerrorMessage = true;
      Validity = true;
    } else {
      isDataBasEerrorMessage = false;
      Validity = false;
    }
    return Validity;
  }

  void _clearControllers() {
    emilController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    passwordController2.clear();
  }

  Widget _CompleteAgreemntMssg() {
    return Visibility(
      visible: !agremntClicked && _signUpValid,
      child: Text(
        "demandPolicy".tr,
        style: TextStyle(color: GlobalColors.mainColorRed, fontSize: 15),
      ),
    );
  }

  showPPAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //Widgets which help to display a list of children widgets are the 'culprit', they make your text widget not know what the maximum width is. In OP's example it is the ButtonBar widget.
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 30,
                  ),
                  Container(
                    alignment: arLnag ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it1".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.mainColorGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // introduction text
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it1text".tr,
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: arLnag ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it2".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.mainColorGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // user info text
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it2text".tr,
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: arLnag ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it3".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.mainColorGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // item three text
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it3text".tr,
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: arLnag ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it4".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.mainColorGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // item three text
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it4text".tr,
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: arLnag ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it5".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.mainColorGreen),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // item three text
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "it5text".tr,
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Container(
                            // padding: EdgeInsets.only(right: 100),
                            padding: arLnag
                                ? EdgeInsets.only(right: 130, bottom: 20)
                                : EdgeInsets.only(left: 140, bottom: 20),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            GlobalColors.mainColorGreen,
                                            GlobalColors.secondaryColorGreen
                                          ]),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(225, 4, 99, 65)
                                              .withOpacity(0.27),
                                          blurRadius: 10,
                                        ),
                                      ]),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "okButton".tr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showError(String message) {
    if (message == '') return;
    AwesomeDialog(
            context: context,
            btnCancelColor: Colors.grey,
            btnOkColor: GlobalColors.secondaryColorGreen,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            dismissOnTouchOutside: false,
            title: 'E'.tr,
            desc: message,
            btnOkText: 'Ok'.tr,
            btnOkOnPress: () {})
        .show();
  }

  Widget langButton() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            buildDialog(context);
          },
          style: TextButton.styleFrom(
            primary: Colors.transparent,
          ),
          child: Container(
            child: isArabic
                ? Row(
                    children: [
                      Text(
                        "lang".tr,
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.language,
                        size: 20,
                        color: GlobalColors.textColor,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 15,
                        color: GlobalColors.textColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "lang".tr,
                        style: TextStyle(
                            color: GlobalColors.textColor, fontSize: 15),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget submitButton() {
    return Container(
      alignment: Alignment.center,
      height: 47,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: (!isLogin && (!_signUpValid || !agremntClicked))
                  ? [
                      const Color.fromARGB(255, 4, 99, 65).withOpacity(0.4),
                      const Color.fromARGB(255, 4, 99, 65).withOpacity(0.4)
                    ]
                  : [
                      GlobalColors.mainColorGreen,
                      GlobalColors.secondaryColorGreen
                    ]),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: (!isLogin && (!_signUpValid || !agremntClicked))
                  ? Color.fromARGB(225, 4, 99, 65).withOpacity(0.1)
                  : Color.fromARGB(255, 4, 99, 65).withOpacity(0.27),
              blurRadius: 10,
            ),
          ]),
      child: TextButton(
        onPressed: (!isLogin && (!_signUpValid || !agremntClicked))
            ? null
            : () {
                bool validated = false;
                if (isLogin) {
                  validated = checkValidation(_formKeylogIn);
                  if (validated) {
                    signInWithEmailAndPassword();
                  } else if (!validated) {
                    setState(() {});
                  }
                } else {
                  setState(() {
                    registerClicked = true;
                  });
                  if (_signUpValid) {
                    if (agremntClicked) {
                      createUserWithEmailAndPassword();
                    }
                  }
                }
              },
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            isLogin ? 'logIn'.tr : 'signUp'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  } //submitButton

  Widget loginOrRegisterButton() {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.transparent,
      ),
      onPressed: () {
        setState(() {
          registerClicked = false;
          isLogin = !isLogin;
          _clearControllers();
          ppCheck = false;
          agremntClicked = false;
          showPassClicked = false;
          isVisible = true;
          showPassClickedConf = false;
          isVisibleConf = true;
          showPassClickedLogin = false;
          isVisibleLogin = true;
          errorMessageData = '';
          errorMessageValid = '';
        });
      },
      child: Text(
        isLogin ? 'signUp'.tr : 'logIn2'.tr,
        style: TextStyle(
          color: GlobalColors.secondaryColorGreen,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  } //loginOrRegisterButton

  Widget ForgotPassword() {
    return GestureDetector(
      child: Text(
        'forogtPass'.tr,
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationThickness: 10,
          color: GlobalColors.secondaryColorGreen,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              //color: Colors.red,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  langButton(),
                  Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/logo.png',
                          height: 120, width: 120)),
                  const SizedBox(height: 13),
                  Text(
                    'creatAcc'.tr,
                    style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Fname input
                  Form(
                      key: _formKeySignUp,
                      onChanged: () {
                        setState(() {
                          _signUpValid = checkValidation(_formKeySignUp);
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 15,
                                  child: TextFormGlobal(
                                    controller: firstNameController,
                                    text: 'FN'.tr,
                                    obsecure: false,
                                    textInputType: TextInputType.text,
                                    isLogin: false,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Lname input
                                Expanded(
                                  flex: 15,
                                  child: TextFormGlobal(
                                    controller: lastNameController,
                                    text: 'LN'.tr,
                                    obsecure: false,
                                    textInputType: TextInputType.text,
                                    isLogin: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Email input
                          TextFormGlobal(
                            controller: emilController,
                            text: 'email'.tr,
                            obsecure: false,
                            textInputType: TextInputType.emailAddress,
                            isLogin: false,
                          ),
                          const SizedBox(height: 15),

                          // Password input
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              showPassClicked
                                  ? TextFormGlobal(
                                      controller: passwordController,
                                      text: 'pass'.tr,
                                      obsecure: false,
                                      textInputType: TextInputType.text,
                                      isLogin: false,
                                    )
                                  : TextFormGlobal(
                                      controller: passwordController,
                                      text: 'pass'.tr,
                                      obsecure: true,
                                      textInputType: TextInputType.text,
                                      isLogin: false,
                                    ),
                              isVisible
                                  ? Positioned(
                                      top: 2,
                                      child: Container(
                                        // color: Colors.amber,
                                        height: 47,
                                        width: 300,
                                        child: arLnag
                                            ? Padding(
                                                //arLnag true?
                                                padding: EdgeInsets.only(
                                                  right: 260,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClicked = true;
                                                      isVisible = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                //arLnag false?
                                                padding: EdgeInsets.only(
                                                  left: 260,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClicked = true;
                                                      isVisible = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  : Positioned(
                                      top: 2,
                                      child: Container(
                                        height: 47,
                                        width: 300,
                                        child: arLnag
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(right: 260),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClicked = false;
                                                      isVisible = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(left: 260),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClicked = false;
                                                      isVisible = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                            ],
                          ),

                          const SizedBox(height: 15),
                          //Password confirmation input
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              showPassClickedConf
                                  ? TextFormGlobal(
                                      controller: passwordController2,
                                      text: 'confPass'.tr,
                                      obsecure: false,
                                      textInputType: TextInputType.text,
                                      isLogin: false,
                                      passController: passwordController,
                                    )
                                  : TextFormGlobal(
                                      controller: passwordController2,
                                      text: 'confPass'.tr,
                                      obsecure: true,
                                      textInputType: TextInputType.text,
                                      isLogin: false,
                                      passController: passwordController,
                                    ),
                              isVisibleConf
                                  ? Positioned(
                                      top: 2,
                                      child: Container(
                                        height: 47,
                                        width: 300,
                                        child: arLnag
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                  right: 260,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClickedConf =
                                                          true;
                                                      isVisibleConf = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                  left: 260,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClickedConf =
                                                          true;
                                                      isVisibleConf = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility_off,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  : Positioned(
                                      top: 2,
                                      child: Container(
                                        height: 47,
                                        width: 300,
                                        child: arLnag
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(right: 260),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClickedConf =
                                                          false;
                                                      isVisibleConf = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(left: 260),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassClickedConf =
                                                          false;
                                                      isVisibleConf = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility,
                                                    size: 20,
                                                    color: GlobalColors
                                                        .mainColorGreen,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 7,
                          // ),

                          arLnag
                              ? Row(
                                  children: [
                                    //icons for pp starts here
                                    ppCheck
                                        ? Container(
                                            padding: const EdgeInsets.all(0.0),
                                            width: 15.0,
                                            child: IconButton(
                                                padding:
                                                    EdgeInsets.only(right: 25),
                                                onPressed: () {
                                                  setState(() {
                                                    ppCheck = false;
                                                    agremntClicked = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check_box,
                                                  color: GlobalColors
                                                      .mainColorGreen,
                                                  size: 17,
                                                )),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(0.0),
                                            width: 15.0,
                                            child: IconButton(
                                                padding:
                                                    EdgeInsets.only(right: 25),
                                                onPressed: () {
                                                  setState(() {
                                                    ppCheck = true;
                                                    agremntClicked = true;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: GlobalColors
                                                      .mainColorGreen,
                                                  size: 17,
                                                )),
                                          ),

                                    ///icons for checking the privacy policy ends here

                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showPPAlert();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 10),
                                        child: Stack(children: [
                                          Text(
                                            "Agreemnt1".tr,
                                            style: TextStyle(
                                                color:
                                                    GlobalColors.mainColorGreen,
                                                fontSize: 13),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: Text(
                                              '\n' + "Agreemnt2".tr,
                                              style: TextStyle(
                                                color:
                                                    GlobalColors.mainColorGreen,
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 10,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  //if arLnag == flase
                                  children: [
                                    //icons for pp starts here
                                    ppCheck
                                        ? Container(
                                            padding: const EdgeInsets.all(0.0),
                                            width: 15.0,
                                            child: IconButton(
                                                padding:
                                                    EdgeInsets.only(right: 25),
                                                onPressed: () {
                                                  setState(() {
                                                    ppCheck = false;
                                                    agremntClicked = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check_box,
                                                  color: GlobalColors
                                                      .mainColorGreen,
                                                  size: 17,
                                                )),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(0.0),
                                            width: 15.0,
                                            child: IconButton(
                                                padding:
                                                    EdgeInsets.only(right: 25),
                                                onPressed: () {
                                                  setState(() {
                                                    ppCheck = true;
                                                    agremntClicked = true;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: GlobalColors
                                                      .mainColorGreen,
                                                  size: 17,
                                                )),
                                          ),

                                    ///icons for checking the privacy policy ends here

                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showPPAlert();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 10),
                                        child: Stack(children: [
                                          Text(
                                            "Agreemnt1".tr,
                                            style: TextStyle(
                                                color:
                                                    GlobalColors.mainColorGreen,
                                                fontSize: 14),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              '\n' + "Agreemnt2".tr,
                                              style: TextStyle(
                                                color:
                                                    GlobalColors.mainColorGreen,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationThickness: 10,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                          _CompleteAgreemntMssg(),
                        ],
                      )),
                  const SizedBox(height: 7),
                  //  _errorMessage(),
                  const SizedBox(height: 5),
                  submitButton(),
                  //const SizedBox(height: 0),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      'alradyAcc'.tr,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    loginOrRegisterButton()
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  langButton(),
                  const SizedBox(height: 30),
                  Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/logo.png',
                          height: 130, width: 130)),
                  const SizedBox(height: 35),
                  Text(
                    'logToAcc'.tr,
                    style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKeylogIn,
                    child: Column(children: [
                      // Email input
                      TextFormGlobal(
                        controller: emilController,
                        text: 'email'.tr,
                        obsecure: false,
                        textInputType: TextInputType.emailAddress,
                        isLogin: true,
                      ),
                      const SizedBox(height: 20),
                      // Password input
                      Stack(alignment: Alignment.center, children: [
                        showPassClickedLogin
                            ? TextFormGlobal(
                                controller: passwordController,
                                text: 'pass'.tr,
                                obsecure: false,
                                textInputType: TextInputType.text,
                                isLogin: true,
                              )
                            : TextFormGlobal(
                                controller: passwordController,
                                text: 'pass'.tr,
                                obsecure: true,
                                textInputType: TextInputType.text,
                                isLogin: true,
                              ),
                        isVisibleLogin
                            ? Positioned(
                                top: 2,
                                child: Container(
                                  //color: Colors.amber,
                                  height: 47,
                                  width: 300,
                                  child: arLnag
                                      ? Padding(
                                          //arLnag true?
                                          padding: EdgeInsets.only(
                                            right: 260,
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassClickedLogin = true;
                                                isVisibleLogin = false;
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_off,
                                              size: 20,
                                              color:
                                                  GlobalColors.mainColorGreen,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          //arLnag false?
                                          padding: EdgeInsets.only(
                                            left: 260,
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassClickedLogin = true;
                                                isVisibleLogin = false;
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility_off,
                                              size: 20,
                                              color:
                                                  GlobalColors.mainColorGreen,
                                            ),
                                          ),
                                        ),
                                ),
                              )
                            : Positioned(
                                top: 2,
                                child: Container(
                                  height: 47,
                                  width: 300,
                                  child: arLnag
                                      ? Padding(
                                          padding: EdgeInsets.only(right: 260),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassClickedLogin = false;
                                                isVisibleLogin = true;
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color:
                                                  GlobalColors.mainColorGreen,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(left: 260),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showPassClickedLogin = false;
                                                isVisibleLogin = true;
                                              });
                                            },
                                            child: Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color:
                                                  GlobalColors.mainColorGreen,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  submitButton(),
                  const SizedBox(height: 15),
                  ForgotPassword(),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      'noAcc'.tr,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    loginOrRegisterButton(),
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
    }
  } //build
}
