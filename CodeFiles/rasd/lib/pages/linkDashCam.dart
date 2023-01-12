import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/shared/textFormGlobal.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:rasd/streamStatucCheck.dart';
import 'package:rasd/streamVidLink.dart';

class LinkPage extends StatefulWidget {
  @override
  final String uid;
  final bool linked;

  const LinkPage({super.key, required this.uid, required this.linked});

  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  final GlobalKey<FormState> _formKeyLink =
      GlobalKey<FormState>(); //for ip only
  final GlobalKey<FormState> _formKeyLink2 =
      GlobalKey<FormState>(); //for ip,admin, and pass
  final TextEditingController Dashcam_id = TextEditingController();
  final TextEditingController Dashcam_username = TextEditingController();
  final TextEditingController Dashcam_pass = TextEditingController();

  String? errorMessage = '';
  bool isLogin = true;
  String dashcam_id_num = "";
  String dashcam_un = "";
  String dashcam_ps = "";
  String? errorMessageData = '';
  String? errorMessageValid = '';
  bool isDataBasEerrorMessage = true;
  bool arLnag = "IP".tr == 'Enter your dashcam IP' ? false : true;
  String url = "http://127.0.0.1:5000/dashcam_id_num";
  String RTSPurl = '';
  var ipOnly = 1; //0 no, 1 yes
  bool? live;
  Timer? streamUpdate;

  @override
  void dispose() {
    streamUpdate?.cancel();
    super.dispose();
  }

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
                bool validate =
                    checkValidation(ipOnly == 1 ? _formKeyLink : _formKeyLink2);
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
                bool validate =
                    checkValidation(ipOnly == 1 ? _formKeyLink : _formKeyLink2);
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
  Future<void> _showSucess() async {
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
  Future<void> _showMyDialog(String desctr) {
    var ip = Dashcam_id.text;
    var username = Dashcam_username.text;
    var pass = Dashcam_pass.text;
    var data = utf8.encode(pass); // data being hashed (dashcam password)
    var hashvalue = sha1.convert(data);
    if (ipOnly == 1) {
      RTSPurl = 'rtsp://$ip:554/livestream/12';
    } else {
      RTSPurl = 'rtsp://$username:$pass@$ip:554';
    }
    print(RTSPurl);
    streamUpdate = Timer.periodic(Duration(seconds: 1), (_) {
      live = streamCheck.statCheckLink.value;
      print('Live---------$live');
    });

    return AwesomeDialog(
      context: context,
      body: Builder(builder: (context) {
        return Center(
            child: Column(children: [
          const Center(
              child: Text(
            'Can you see the stream?',
            style: TextStyle(
              fontSize: 15,
            ),
          )),
          Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              height: 90,
              width: 163,
              child: LiveStreamScreenLink(
                url: RTSPurl,
                uid: widget.uid,
                recordStream: false,
              ))
        ]));
      }),
      btnCancelColor: Colors.grey,
      btnOkColor: GlobalColors.secondaryColorGreen,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      //title: 'Sure'.tr,
      //desc: desctr,
      btnOkText: 'yes'.tr,
      btnCancelText: 'No'.tr,
      btnCancelOnPress: () {}, // will stay in the same page
      btnOkOnPress: () {
        print('Live---------$live');
        if (!live!) {
          //if stream is not avialable
          AwesomeDialog(
                  context: context,
                  btnCancelColor: Colors.grey,
                  btnOkColor: GlobalColors.secondaryColorGreen,
                  dialogType: DialogType.error,
                  animType: AnimType.scale,
                  dismissOnTouchOutside: false,
                  title: 'Error',
                  desc:
                      'an error happened while retrieving the stream from the dashcam, please make sure of the entered information',
                  btnOkText: 'Ok'.tr,
                  btnOkOnPress: () {})
              .show();
          streamUpdate!.cancel();
        } else {
          //if the stream is availabe
          //################## check  dashcam IP is in the right form ##################
          bool validate =
              checkValidation(ipOnly == 1 ? _formKeyLink : _formKeyLink2);
          if (validate) {
            dashcam_id_num = Dashcam_id.text;
            if (ipOnly == 0) {
              dashcam_un = Dashcam_username.text;
              dashcam_ps = hashvalue.toString();
            }
            final docUser = FirebaseFirestore.instance
                .collection('drivers')
                .doc(widget.uid);
            //################## now add dashcam IP after validation ##################
            //update specfic fields
            docUser.update({
              'dashcam_id': dashcam_id_num,
              'rtsp_url': RTSPurl,
            });
            if (ipOnly == 0) {
              docUser.update({
                'dashcam_username': dashcam_un,
                'dashcam_pass': dashcam_ps,
              });
            }
            // //############### Add dummy data (add 2 pending videos) for new users ##################
            // if (widget.linked == false) {
            //   for (int i = 0; i < 2; i++) {
            //     // loop to add 2 reports
            //     final docRepID = docUser.collection('reports').add(
            //       {'status': 0, 'v_type': "null", 'addInfo': "null", 'id': ''},
            //     ) //add pending report
            //         .then((value) {
            //       //updating id to be the same as docID
            //       docUser
            //           .collection('reports')
            //           .doc(value.id)
            //           .update({'id': value.id.toString()});
            //       //add video
            //       docUser
            //           .collection('reports')
            //           .doc(value.id)
            //           .collection('video')
            //           .add(
            //         {
            //           'video_url': i == 0
            //               ? 'https://firebasestorage.googleapis.com/v0/b/rasd-d3906.appspot.com/o/Videos%2F3la_altreq-1262081362107998209-20200517_210339-vid1.mp4?alt=media&token=b5b68317-d098-476f-88a5-259d61a93b2b' //video number 1
            //               : 'https://firebasestorage.googleapis.com/v0/b/rasd-d3906.appspot.com/o/Videos%2FAnwsanws-1542158155622268928-20220629_174850-vid1.mp4?alt=media&token=996f0025-745a-45ba-93da-7b543f287e72', //video number 2
            //           'id': ''
            //         }, //add video inside it
            //       ).then((value2) => docUser
            //               .collection('reports')
            //               .doc(value.id)
            //               .collection('video')
            //               .doc(value2.id)
            //               .update({'id': value2.id.toString()}));
            //     });
            //   }
            // }
            //#####################pass it to python#################
            _showSucess();
            streamUpdate!.cancel();
          } else {
            setState(() {
              errorMessageValid = 'errorLink'.tr;
              streamUpdate!.cancel();
            });
          }
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            child: Text(
                widget.linked ? 'Edit your Dashcam IP' : 'Link your Dashcam',
                style: TextStyle(color: GlobalColors.mainColorGreen)),
          ),
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
      body: ValueListenableBuilder(
        valueListenable: streamCheck.statCheckLink,
        builder: (context, value, child) {
          return widget.linked ? edit() : Link();
        },
      ),
    );
  }

  Widget Link() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ipOnly == 1 ? 80 : 40),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png',
                        height: 130, width: 130)),
                const SizedBox(height: 40),
                Text(
                  'What type of RTSP link your dashcam provides?',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Row(children: [
                          Radio(
                            activeColor: GlobalColors.mainColorGreen,
                            value: 1, //IP only
                            groupValue: ipOnly,
                            onChanged: ((value) {
                              setState(() {
                                ipOnly = value!;
                                Dashcam_id.clear();
                              });
                            }),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'IP only',
                                style: TextStyle(
                                  color: GlobalColors.textColor,
                                  fontSize: 15,
                                ),
                              ))
                        ])),
                    Expanded(
                        flex: 5,
                        child: Row(children: [
                          Radio(
                            activeColor: GlobalColors.mainColorGreen,
                            value: 0, //IP, Admin, Pass
                            groupValue: ipOnly,
                            onChanged: ((value) {
                              setState(() {
                                ipOnly = value!;
                                Dashcam_id.clear();
                              });
                            }),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'IP, username, and \npassword required',
                                style: TextStyle(
                                  color: GlobalColors.textColor,
                                  fontSize: 15,
                                ),
                              ))
                        ])),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ipOnly == 1
                    ? Form(
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
                        ))
                    : Form(
                        key: _formKeyLink2,
                        child: Column(
                          children: [
                            TextFormGlobal(
                              controller: Dashcam_id,
                              text: 'IP'.tr,
                              obsecure: false,
                              textInputType: TextInputType.text,
                              isLogin: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormGlobal(
                              controller: Dashcam_username,
                              text: 'Enter your dashcam Username',
                              obsecure: false,
                              textInputType: TextInputType.text,
                              isLogin: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormGlobal(
                              controller: Dashcam_pass,
                              text: 'Enter your dashcam Password',
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
                SizedBox(height: ipOnly == 1 ? 80 : 40),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/logo.png',
                        height: 130, width: 130)),
                const SizedBox(height: 40),
                Text(
                  'What type of RTSP link your dashcam provides?',
                  style: TextStyle(
                    color: GlobalColors.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  child: Row(children: [
                    Expanded(
                        flex: 3,
                        child: Row(children: [
                          Radio(
                            activeColor: GlobalColors.mainColorGreen,
                            value: 1, //IP only
                            groupValue: ipOnly,
                            onChanged: ((value) {
                              setState(() {
                                ipOnly = value!;
                                Dashcam_id.clear();
                              });
                            }),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'IP only',
                                style: TextStyle(
                                  color: GlobalColors.textColor,
                                  fontSize: 15,
                                ),
                              ))
                        ])),
                    Expanded(
                        flex: 5,
                        child: Row(children: [
                          Radio(
                            activeColor: GlobalColors.mainColorGreen,
                            value: 0, //IP, Admin, Pass
                            groupValue: ipOnly,
                            onChanged: ((value) {
                              setState(() {
                                ipOnly = value!;
                                Dashcam_id.clear();
                              });
                            }),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'IP, username, and \npassword required',
                                style: TextStyle(
                                  color: GlobalColors.textColor,
                                  fontSize: 15,
                                ),
                              ))
                        ])),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                ipOnly == 1
                    ? Form(
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
                        ))
                    : Form(
                        key: _formKeyLink2,
                        child: Column(
                          children: [
                            TextFormGlobal(
                              controller: Dashcam_id,
                              text: 'IP'.tr,
                              obsecure: false,
                              textInputType: TextInputType.text,
                              isLogin: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormGlobal(
                              controller: Dashcam_username,
                              text: 'Enter your dashcam Username',
                              obsecure: false,
                              textInputType: TextInputType.text,
                              isLogin: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormGlobal(
                              controller: Dashcam_pass,
                              text: 'Enter your dashcam Password',
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