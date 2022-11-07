import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/Splash.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/model/driver.dart';

class account extends StatefulWidget {
  final String uid;

  account({Key? key, required this.uid}) : super(key: key);

  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<account> {
  double screenHeight = 0;
  double screenWidth = 0;
  final GlobalKey<FormState> _formKeySave = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetEmailFormKey = GlobalKey<FormState>();
  String? errorMessageData = '';
  var done = false;
  bool isFormEmpty = true;
  bool arLnag = "acc".tr == 'My Account' ? false : true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldEmailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool validateEmail(value) {
    bool emailValid =
        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
    if (emailValid == true) {
      return true;
    } else {
      return false;
    }
  }

  void _errorMessage(String msg) {
    AwesomeDialog(
            context: context,
            btnCancelColor: Colors.grey,
            btnOkColor: GlobalColors.secondaryColorGreen,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            dismissOnTouchOutside: false,
            title: 'E'.tr,
            desc: msg,
            btnOkOnPress: () {})
        .show();
  }

  void _clearControllers() {
    oldEmailController.clear();
    passController.clear();
  }

  Future<Driver?> readUser(uid) async {
    final docUser = FirebaseFirestore.instance.collection('drivers').doc(uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Driver.fromJsonD(snapshot.data()!);
    }
  }

  //loading page
  Widget _loading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/loadingLogoBlack.png',
              height: 105,
              width: 105,
            ),
            Container(
              padding: EdgeInsets.only(left: 3),
              child: SizedBox(
                height: 43,
                width: 43,
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 140, right: 6),
              child: Image.asset(
                'assets/images/rasdTextBlack.png', //make it pop up
                height: 105,
                width: 105,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Future resetEmail(
      String newEmail, String oldEmail, String pass, docUser) async {
    var message;
    final _firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: oldEmail, password: pass);
      final User? user = result.user!;
      user!.updateEmail(newEmail).then((value) async {
        docUser.update({
          'email': newEmail,
        });
        _showSucess(true);
      }).catchError((onError) {
        if (onError.toString().contains(
            'The email address is already in use by another account.')) {
          setState(() {
            errorMessageData = 'AccountExist'.tr;
          });
          _errorMessage(errorMessageData!);
        }
        print(onError.toString());
      });
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
        _errorMessage(errorMessageData!);
      });
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Splash()));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  //sucess dialog
  void _showSucess(bool isEmail) {
    AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'S'.tr,
        desc: "updateMess".tr,
        btnOkOnPress: () {
          if (isEmail) {
            signOut();
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RootApp(
                          pageIndex: 0,
                        )));
          }
        }).show();
  }

  //sucess dialog
  Future<void> _emailUpdateDialog(String newEmail, docUser) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'changeE'.tr,
            style: TextStyle(color: GlobalColors.mainColorGreen),
          ),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              Form(
                  key: _resetEmailFormKey,
                  child: Column(
                    children: [
                      textField("oldE".tr, 'em'.tr, oldEmailController),
                      SizedBox(
                        height: 5,
                      ),
                      textField("pass".tr, 'pass'.tr, passController),
                    ],
                  ))
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'update'.tr,
                style: TextStyle(color: GlobalColors.mainColorGreen),
              ),
              onPressed: () {
                //change Email
                if (_resetEmailFormKey.currentState!.validate()) {
                  resetEmail(newEmail, oldEmailController.text,
                      passController.text, docUser);
                  _clearControllers();
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              //go back
              child: Text(
                'C'.tr,
                style: TextStyle(color: GlobalColors.mainColorGreen),
              ),
              onPressed: () {
                _clearControllers();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

//confirm dialog
  Future<void> _showMyDialog() async {
    return AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        // barrierColor: GlobalColors.mainColorGreen,
        title: 'Sure'.tr,
        desc: 'AreUSureToSave'.tr,
        btnOkText: "yes".tr,
        btnCancelText: 'C'.tr,
        btnCancelOnPress: () {}, // will stay in the same page
        btnOkOnPress: () async {
          debugPrint("Tap");
          done = true;

          if (done) {
            String firstname = firstNameController.text;
            String lastName = lastNameController.text;
            String email = emailController.text;

            if (_formKeySave.currentState!.validate()) {
              // update made here we have to check if value is empty do not update it

              final docUser = FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(widget.uid);

              //update specfic fields

              if (!firstname.isEmpty) {
                docUser.update({
                  'Fname': firstname,
                });
              }
              // update lastName
              if (!lastName.isEmpty) {
                docUser.update({
                  'Lname': lastName,
                });
              }
              // update email
              if (!email.isEmpty) {
                _emailUpdateDialog(email, docUser);
              }

              if ((!firstname.isEmpty || !lastName.isEmpty) && email.isEmpty) {
                _showSucess(false);
              }
            }
          }
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Container(
            child: Text('acc'.tr,
                style: TextStyle(color: GlobalColors.mainColorGreen)),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 30),
            color: GlobalColors.mainColorGreen,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: FutureBuilder<Driver?>(
          future: readUser(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;

              return user == null
                  ? Center(child: Text('on user'))
                  : buildUser(user);
            } else {
              return _loading();
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    firstNameController.addListener(_getLatestValue);
    lastNameController.addListener(_getLatestValue);
    emailController.addListener(_getLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _getLatestValue() {
    if (firstNameController.text == '' &&
        lastNameController.text == '' &&
        emailController.text == '') {
      isFormEmpty = true;
    } else {
      isFormEmpty = false;
    }
  }

  Widget buildUser(Driver driver) => getBody(driver);

  Widget getBody(Driver driver) {
    _getLatestValue();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "", // there must be a back button
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 39),
            width: 380,
            height: 450,
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
                Form(
                    key: _formKeySave,
                    child: Column(
                      children: [
                        textField(
                            "fname".tr, driver.Fname, firstNameController),
                        const SizedBox(
                          height: 20,
                        ),
                        textField("lname".tr, driver.Lname, lastNameController),
                        const SizedBox(
                          height: 20,
                        ),
                        textField("em".tr, driver.email, emailController),
                      ],
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // _errorMessage(),
          const SizedBox(height: 3),
          Container(
            alignment: Alignment.center,
            height: 47,
            decoration: BoxDecoration(
                color: isFormEmpty
                    ? const Color.fromARGB(255, 4, 99, 65).withOpacity(0.4)
                    : const Color.fromARGB(255, 4, 99, 65),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: isFormEmpty
                        ? const Color.fromARGB(255, 4, 99, 65).withOpacity(0.1)
                        : const Color.fromARGB(255, 4, 99, 65)
                            .withOpacity(0.27),
                    blurRadius: 10,
                  ),
                ]),
            child: TextButton(
              onPressed: isFormEmpty
                  ? null
                  : () async {
                      if (_formKeySave.currentState!.validate())
                        _showMyDialog();
                      setState(() {
                        errorMessageData = '';
                      });
                    }, // this button must be clicked if changed made
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'save'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget textField(
      String title, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: arLnag ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 4,
            ),
            child: Text(
              title,
              style: TextStyle(
                // fontFamily: "NexaBold",
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
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
                    )
                  ]),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 3,
                left: 15,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (title == 'fname'.tr) {
                    if (val!.isEmpty) {
                      return null;
                    } else {
                      if (!RegExp(r"^[\u0621-\u064A ]+$").hasMatch(val) &&
                          (!RegExp(r"^[a-zA-Z ]+$").hasMatch(val))) {
                        if (arLnag == true) {
                          return 'FLValidation1'.tr + "";
                        } else {
                          return 'FLValidation1'.tr;
                        }
                      }
                    }
                  } else if (title == 'em'.tr) {
                    if (val!.isEmpty) {
                      return null;
                    } else if (arLnag == true) {
                      if (!validateEmail(val)) {
                        return 'invalidE2'.tr;
                      }
                    } else if (!validateEmail(val)) {
                      return 'invalidE'.tr;
                    }
                  } else if (title == 'lname'.tr) {
                    if (val!.isEmpty) {
                      return null;
                    } else {
                      if (!RegExp(r"^[\u0621-\u064A ]+$").hasMatch(val) &&
                          (!RegExp(r"^[a-zA-Z ]+$").hasMatch(val))) {
                        if (arLnag == true) {
                          return 'FLValidation1'.tr;
                        } else {
                          return 'FLValidation1'.tr;
                        }
                      }
                    }
                  } else if (title == 'oldE'.tr) {
                    if (val!.isEmpty) {
                      return 'enterE'.tr;
                    } else if (arLnag == true) {
                      if (!validateEmail(val)) {
                        return 'invalidE2'.tr;
                      }
                    } else if (!validateEmail(val)) {
                      return 'invalidE3'.tr;
                    }
                  } else if (title == 'pass'.tr) {
                    if (val!.isEmpty) {
                      return 'enterPass'.tr;
                    }
                  }
                },
                controller: controller,
                cursorColor: Colors.black54,
                obscureText: (title == 'pass'.tr) ? true : false,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                    height: 0,
                    //fontFamily: "NexaBold",
                  ),
                  contentPadding:
                      EdgeInsets.only(bottom: 4, right: arLnag ? 10 : 0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
