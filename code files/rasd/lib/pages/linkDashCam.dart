import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/shared/textFormGlobal.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LinkPage extends StatefulWidget {
  @override
  final String uid;
  final bool linked;

  const LinkPage({super.key, required this.uid, required this.linked});

  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  final GlobalKey<FormState> _formKeyLink = GlobalKey<FormState>();
  final TextEditingController Dashcam_id = TextEditingController();
  String? errorMessage = '';
  bool isLogin = true;
  String dashcam_id_num = "";
  String? errorMessageData = '';
  String? errorMessageValid = '';
  bool isDataBasEerrorMessage = true;
  bool arLnag = "IP".tr == 'Enter your dashcam IP' ? false : true;

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Humm ? $errorMessage',
      style: TextStyle(
        color: GlobalColors.textColor,
      ),
    );
  } //_errorMessage

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

  Widget toolTip() {
    return IconButton(
      icon: Icon(
        Icons.info_outline_rounded,
        color: GlobalColors.secondaryColorGreen,
        size: 15,
      ),
      onPressed: () {
        AwesomeDialog(
                context: context,
                btnCancelColor: Colors.grey,
                btnOkColor: GlobalColors.secondaryColorGreen,
                dialogType: DialogType.noHeader,
                animType: AnimType.scale,
                dismissOnTouchOutside: false,
                title: "IP: ",
                desc: 'DashCamtoolTip'.tr,
                btnOkText: 'Ok'.tr,
                btnOkOnPress: () {})
            .show();
      },
    );
  }

  //################## link/edit  button ##################
  Widget submitButton(String str) {
    return widget.linked // check if it is already link ,
        // if linked --> show edit page , if not linked --> show link page
        ?
        //edit container
        Container(
            alignment: Alignment.center,
            height: 47,
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
                    color:
                        const Color.fromARGB(225, 4, 99, 65).withOpacity(0.27),
                    blurRadius: 10,
                  ),
                ]),
            child: TextButton(
              //clicking on link
              onPressed: () {
                bool validate = checkValidation(_formKeyLink);

                if (validate) {
                  // after clicking on link the user must confirm --> call confirmation dialog
                  _showMyDialog('editMess'.tr);
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    str,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        :
        //link container
        Container(
            alignment: Alignment.center,
            height: 47,
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
                    color:
                        const Color.fromARGB(225, 4, 99, 65).withOpacity(0.27),
                    blurRadius: 10,
                  ),
                ]),
            child: TextButton(
              onPressed: () {
                bool validate = checkValidation(_formKeyLink);
                if (validate) {
                  _showMyDialog('linkMess'.tr);
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.transparent,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    str,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
  } //submitButton

  //################## sucess dialog ##################
  void _showSucess() {
    AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'S'.tr,
        desc: 'descS'.tr,
        btnOkText: 'Ok'.tr,
        btnOkOnPress: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => RootApp(
                        pageIndex: 0,
                      )));
        }).show();
  }

  //################## confirmation dialog ##################
  Future<void> _showMyDialog(String desctr) async {
    return AwesomeDialog(
      context: context,
      btnCancelColor: Colors.grey,
      btnOkColor: GlobalColors.secondaryColorGreen,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Sure'.tr,
      desc: desctr,
      btnOkText: 'yes'.tr,
      btnCancelText: 'C'.tr,

      btnCancelOnPress: () {}, // will stay in the same page
      btnOkOnPress: () {
        //################## check  dashcam IP is in the right form ##################
        bool validate = checkValidation(_formKeyLink);
        if (validate) {
          dashcam_id_num = Dashcam_id.text; //
          final docUser =
              FirebaseFirestore.instance.collection('drivers').doc(widget.uid);
          //################## now add dashcam IP after validation ##################
          //update specfic fields
          docUser.update({
            'dashcam_id': dashcam_id_num,
          });

          //############### Add dummy data (add 2 pending videos) for new users ##################
          if (widget.linked == false) {
            for (int i = 0; i < 2; i++) {
              // loop to add 2 reports
              final docRepID = docUser.collection('reports').add(
                {'status': 0, 'v_type': "null", 'id': ''},
              ) //add pending report
                  .then((value) {
                //updating id to be the same as docID
                docUser
                    .collection('reports')
                    .doc(value.id)
                    .update({'id': value.id.toString()});
                //add video
                docUser
                    .collection('reports')
                    .doc(value.id)
                    .collection('video')
                    .add(
                  {
                    'video_url': i == 0
                        ? "https://firebasestorage.googleapis.com/v0/b/rasd-23356.appspot.com/o/videos%2FDashcamksa1-1210158521297391616-20191226_142049-vid1.mp4?alt=media&token=25723901-1cc7-4700-bc55-d6145dad5ae3" //video number 1
                        : 'https://firebasestorage.googleapis.com/v0/b/rasd-23356.appspot.com/o/videos%2FDashcamksa1-1211035288631496708-20191229_002447-vid1.mp4?alt=media&token=a65e5fcd-73ae-4a9a-8455-8e7d53956af3', //video number 2
                    'id': ''
                  }, //add video inside it
                ).then((value2) => docUser
                        .collection('reports')
                        .doc(value.id)
                        .collection('video')
                        .doc(value2.id)
                        .update({'id': value2.id.toString()}));
              });
            }
          }

          _showSucess();
        } else {
          setState(() {
            errorMessageValid = 'errorLink'.tr;
          });
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 30,
            ),
            color: GlobalColors.mainColorGreen,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: widget.linked ? edit() : Link(),
    );
  }

  Widget Link() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
            //color: Colors.brown,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png',
                        height: 130, width: 130)),
                const SizedBox(height: 40),

                Text(
                  'LTOAPP'.tr,
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                // Fname input
                Form(
                    key: _formKeyLink,
                    child: Column(
                      children: [
                        TextFormGlobal(
                          controller: Dashcam_id,
                          text: 'IP'.tr,
                          obsecure: false,
                          textInputType: TextInputType.text,
                          isLogin: true,
                        ),
                      ],
                    )),
                const SizedBox(height: 0),
                Center(
                  child: Row(
                    children: [
                      toolTip(),
                      Text(
                        "How".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0),
                submitButton("Link".tr),
              ],
            )),
      ),
    );
  }

  Widget edit() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
            //color: Colors.brown,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png',
                        height: 130, width: 130)),
                const SizedBox(height: 40),

                Text(
                  'editDashCam'.tr,
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                // Fname input
                Form(
                    key: _formKeyLink,
                    child: Column(
                      children: [
                        TextFormGlobal(
                          controller: Dashcam_id,
                          text: 'IP'.tr,
                          obsecure: false,
                          textInputType: TextInputType.text,
                          isLogin: true,
                        ),
                      ],
                    )),
                const SizedBox(height: 0),
                Center(
                  child: Row(
                    children: [
                      toolTip(),
                      Text(
                        "How".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0),
                submitButton("editLink".tr),
              ],
            )),
      ),
    );
  }
} //build