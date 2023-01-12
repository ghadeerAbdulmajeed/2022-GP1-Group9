import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/shared/widgets/checkbox_state.dart';
import 'package:rasd/shared/padding.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/model/video.dart';
import 'package:video_player/video_player.dart';

String checkedViolation = "";
final _AdditionalInfo = TextEditingController();

class showVideo extends StatefulWidget {
  const showVideo(
      {super.key, required this.reportDocid, required this.userDocid});
  final String reportDocid;
  final String userDocid;
  @override
  State<showVideo> createState() => _showVideoState();
}

class _showVideoState extends State<showVideo> {
  List<CheckBoxState> selecteditems = [];
  VideoPlayerController? _controller;
  String video_url = "";

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("drivers")
        .doc(widget.userDocid)
        .collection("reports")
        .doc(widget.reportDocid)
        .collection("video")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                video_url = doc["video_url"];
                final controller = VideoPlayerController.network(video_url);

                _controller = controller;
                setState(() {});
                controller
                  ..initialize().then((_) {
                    controller.play();
                    setState(() {});
                  });
              })
            });
  }

  Map<String, bool> values1 = {
    'viloation1'.tr: false,
    'viloation4'.tr: false,
    'IDK'.tr: false,
  };
  Map<String, bool> values2 = {
    'viloation3'.tr: false,
    'viloation2'.tr: false,
  };

  var _value = 1; //0 no, 1 yes
  var selectedV1 = "";
  var selectedV2 = "";
  var selectedAll = "";
  //collect all violations type
  void typesV1(String vtitle) {
    selectedV1 += vtitle + ",";
  }

  void typesV2(String vtitle) {
    selectedV2 += vtitle + ",";
  }

  void selectedAllGetter() {
    selectedAll = selectedV1 + "" + selectedV2;
  }

  bool done = false;
  bool delete = false;
  bool arLnag = "showVideoHead".tr == 'Violation Video' ? false : true;

  //show sucessfull
  void _showSucess(String descr, int index) {
    _AdditionalInfo.text = "";
    AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'success'.tr,
        desc: descr,
        btnOkText: 'Ok'.tr,
        btnOkOnPress: () {
          //
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => RootApp(
                        pageIndex: index,
                      )));
        }).show();
  }

  // after clicking confirm
  Future<void> _showMyDialog() async {
    return AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: 'Sure'.tr,
        desc: 'confViolation'.tr,
        btnOkText: "yes".tr,
        btnCancelText: 'C'.tr,
        btnCancelOnPress: () {
          done = false;
        }, // will stay in the same page
        btnOkOnPress: () {
          //confirme it
          done = true;
          if (done) {
            final reportDoc = FirebaseFirestore.instance
                .collection("drivers")
                .doc(widget.userDocid)
                .collection("reports")
                .doc(widget.reportDocid);

            //update specfic fields
            reportDoc.update({
              //  'dashcam_id': dashcam_id_num,
              'v_type': selectedAll,
              'status': 1,
              'addInfo': _AdditionalInfo.text,
            });
            _showSucess('conf'.tr, 2);
          }
        }).show();
  }

  //delete report with the video
  Future<void> _showMyDialogDelete(_misclassifidied) async {
    return AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorRed,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Sure'.tr,
        desc: 'delViolation'.tr,
        btnOkText: "yes".tr,
        btnCancelText: 'C'.tr,
        btnCancelOnPress: () {
          delete = false;
        }, // will stay in the same page
        btnOkOnPress: () async {
          //confirme it
          delete = true;
          if (delete) {
            final reportDoc = FirebaseFirestore.instance
                .collection("drivers")
                .doc(widget.userDocid)
                .collection("reports")
                .doc(widget.reportDocid);

            //get video
            final QuerySnapshot<
                Map<String,
                    dynamic>> VideoDocInReport = await FirebaseFirestore
                .instance
                .collection("drivers")
                .doc(widget.userDocid)
                .collection("reports")
                .doc(widget.reportDocid)
                .collection("video")
                .get(); //get all documents in sub collections (get all reports)
            final List<video> Vid = VideoDocInReport.docs
                .map((Videos) => video.fromSnapShot(Videos))
                .toList();

            String video_url = (Vid[0].video_url); // to save the url
            for (var doc in VideoDocInReport.docs) // delete sub colletcio
            {
              await doc.reference.delete();
            }

            reportDoc.delete(); // delete report
            if (_misclassifidied) {
              //here we want to save the video in another collection for enha model
              final missClassVideo = video(video_url: video_url);
              final docMisV = FirebaseFirestore.instance
                  .collection('missClassifiedVideos')
                  .doc();
              missClassVideo.id = docMisV.id;
              final json = missClassVideo.toJsonD();

              ///create document and write data to firebase
              await docMisV.set(json);
            }
            _showSucess("delConfirmation".tr, 1);
          }
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    // getVidUrl();
    final controller = _controller;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('showVideoHead'.tr),
          centerTitle: true,
          flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.4),
                    end: Alignment.topRight,
                    colors: <Color>[
                      GlobalColors.mainColorGreen,
                      GlobalColors.secondaryColorGreen
                    ]),
              ),
              padding: EdgeInsets.only(
                  top: 30, left: arLnag ? 0 : 350, right: arLnag ? 350 : 0),
              width: spacer,
              height: 500,
              child: Image.asset(
                'assets/images/logoWhite.png',
              )),
        ),
        body:

            //first container after the body
            Container(
          child: Column(
            children: [
              //  Text(video_url),
              SizedBox(
                height: 40,
              ),

              //big white space
              Expanded(
                child: Container(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              //a method to generate vid
                              videoContet(),
                            ],
                          ),
                        ),
                        if (controller != null &&
                            controller.value.isInitialized)
                          Container(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.all(4.0),
                                  alignment: Alignment.centerLeft,
                                  onPressed: () {
                                    setState(() {
                                      controller.value.isPlaying
                                          ? controller.pause()
                                          : controller.play();
                                    });
                                  },
                                  icon: Icon(
                                    //pause isn't working
                                    controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),

                                Expanded(
                                  child: SizedBox(
                                    height: 8,
                                    child: VideoProgressIndicator(
                                      padding: EdgeInsets.only(
                                          top: 2,
                                          left: arLnag ? 13 : 0,
                                          right: 13),
                                      controller,
                                      allowScrubbing: true,
                                    ),
                                  ),
                                ),
                                // ),
                              ],
                            ),
                          ),

                        Expanded(
                          child: Container(
                            child: Scrollbar(
                              thickness: 10,
                              isAlwaysShown: true,
                              child: ListView(children: [
                                Container(
                                  // color: Colors.black,
                                  height: 120,
                                  //*//
                                  padding: EdgeInsets.symmetric(horizontal: 45),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('isViolation'.tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color:
                                                  GlobalColors.mainColorGreen,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        //color: Colors.blue,
                                        child: Row(children: [
                                          Expanded(
                                              flex: 1,
                                              child: Row(children: [
                                                Radio(
                                                  activeColor: GlobalColors
                                                      .mainColorGreen,
                                                  value: 1, //yes
                                                  groupValue: _value,
                                                  onChanged: ((value) {
                                                    setState(() {
                                                      _value = value!;
                                                    });
                                                  }),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      'yes'.tr,
                                                      style: TextStyle(
                                                        color: GlobalColors
                                                            .textColor,
                                                        fontSize: 15,
                                                      ),
                                                    ))
                                              ])),
                                          Expanded(
                                              flex: 1,
                                              child: Row(children: [
                                                Radio(
                                                  activeColor: GlobalColors
                                                      .mainColorGreen,
                                                  value: 0, //no
                                                  groupValue: _value,
                                                  onChanged: ((value) {
                                                    setState(() {
                                                      _value = value!;
                                                    });
                                                  }),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      'no'.tr,
                                                      style: TextStyle(
                                                        color: GlobalColors
                                                            .textColor,
                                                        fontSize: 15,
                                                      ),
                                                    ))
                                              ])),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),

                                //*//
                                SizedBox(
                                  height: 10,
                                ),
                                _value == 1
                                    ? Container(
                                        // color: Colors.green,
                                        // height: 300,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(children: [
                                          Stack(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      28, 0, 28, 0),
                                                  child: Column(
                                                    children: [
                                                      Material(
                                                        elevation: 7.0,
                                                        shadowColor: Colors
                                                            .black
                                                            .withOpacity(0.4),
                                                        child: TextFormField(
                                                          maxLines: 8,
                                                          style: TextStyle(
                                                              color: GlobalColors
                                                                  .mainColorGreen),
                                                          readOnly: true,
                                                          cursorColor:
                                                              GlobalColors
                                                                  .mainColorGreen,
                                                          expands: false,
                                                          decoration:
                                                              InputDecoration(
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .always,
                                                            labelText:
                                                                'violationType'
                                                                    .tr,
                                                            labelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              color: GlobalColors
                                                                  .mainColorGreen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              color: GlobalColors
                                                                  .mainColorGreen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  color: GlobalColors
                                                                      .mainColorGreen),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  color: GlobalColors
                                                                      .mainColorGreen),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Container(
                                                // color: Colors.red,
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                        right: 15,
                                                      )),
                                                      Expanded(
                                                          flex: 10,
                                                          child: Column(
                                                            children: values1
                                                                .keys
                                                                .map((String
                                                                    key) {
                                                              return Transform
                                                                  .scale(
                                                                scale: 0.8,
                                                                child:
                                                                    Container(
                                                                  // color: Colors.red,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: 0,
                                                                  ),
                                                                  child: CheckboxListTile(
                                                                      contentPadding: EdgeInsets.only(right: 0),
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      activeColor: GlobalColors.mainColorGreen,
                                                                      title: Transform.translate(
                                                                        offset: const Offset(
                                                                            -20,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          key,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18.5,
                                                                            height:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      value: values1[key],
                                                                      onChanged: (bool? value) {
                                                                        setState(
                                                                            () {
                                                                          values1[key] =
                                                                              value!;
                                                                          selectedV1 =
                                                                              "";
                                                                          values1.forEach(
                                                                              //*
                                                                              (key, value) {
                                                                            if (value) {
                                                                              // selecteditems.add(
                                                                              //     CheckBoxState(
                                                                              //         value: value,
                                                                              //         title: key));
                                                                              typesV1(key);
                                                                              debugPrint(key);
                                                                            }
                                                                          });
                                                                        });
                                                                      }),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          )),
                                                      Expanded(
                                                          flex: 7,
                                                          child: Column(
                                                            children: values2
                                                                .keys
                                                                .map((String
                                                                    key) {
                                                              return Transform
                                                                  .scale(
                                                                scale: 0.8,
                                                                child:
                                                                    Container(
                                                                  // color: Colors.red,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: 0,
                                                                  ),
                                                                  child: CheckboxListTile(
                                                                      contentPadding: EdgeInsets.only(right: 0),
                                                                      controlAffinity: ListTileControlAffinity.leading,
                                                                      activeColor: GlobalColors.mainColorGreen,
                                                                      title: Transform.translate(
                                                                        offset: const Offset(
                                                                            -20,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          key,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18.5,
                                                                            height:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      value: values2[key],
                                                                      onChanged: (bool? value) {
                                                                        setState(
                                                                            () {
                                                                          values2[key] =
                                                                              value!;
                                                                          selectedV2 =
                                                                              "";
                                                                          values2.forEach((key,
                                                                              value) {
                                                                            if (value) {
                                                                              // selecteditems.add(
                                                                              // CheckBoxState(
                                                                              //     // value: value,
                                                                              //     title: key));
                                                                              typesV2(key);
                                                                              // selectedV = "";

                                                                              debugPrint(key);
                                                                            }
                                                                          });
                                                                        });
                                                                      }),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          )),
                                                    ]),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          ////////////////////text field of the additional info////////////////////////
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  28, 0, 28, 0),
                                              child: Column(
                                                children: [
                                                  Material(
                                                    elevation: 7.0,
                                                    shadowColor: Colors.black
                                                        .withOpacity(0.4),
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: GlobalColors
                                                              .mainColorGreen),
                                                      showCursor: true,
                                                      cursorColor: GlobalColors
                                                          .mainColorGreen,
                                                      expands: false,
                                                      maxLines: null,
                                                      decoration:
                                                          InputDecoration(
                                                        floatingLabelBehavior:
                                                            FloatingLabelBehavior
                                                                .always,
                                                        hintText:
                                                            'optinalAddInfo'.tr,
                                                        hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                        labelText: 'addInfo'.tr,
                                                        labelStyle: TextStyle(
                                                          fontSize: 20,
                                                          color: GlobalColors
                                                              .mainColorGreen,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                          fontSize: 20,
                                                          color: GlobalColors
                                                              .mainColorGreen,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: GlobalColors
                                                                  .mainColorGreen),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              style: BorderStyle
                                                                  .solid,
                                                              color: GlobalColors
                                                                  .mainColorGreen),
                                                        ),
                                                      ),
                                                      controller:
                                                          _AdditionalInfo,
                                                    ),
                                                  ),
                                                ],
                                              )), //end of additional info textfield
                                        ]),
                                      )
                                    : Container(),
                              ]),
                            ), //listview
                          ),
                        ),
                        //expanded after row

                        //containers of buttons
                        Container(
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              top: 20,
                              right: arLnag ? 40 : 30,
                              left: arLnag ? 30 : 40),
                          height:
                              75, // MediaQuery.of(context).size.height * 0.2,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: (_value == 0) ? 100 : 10,
                                    right: 10,
                                    bottom: (_value == 0) ? 0 : 0),
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            GlobalColors.mainColorRed,
                                            GlobalColors.secondaryColorRed
                                          ]),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: GlobalColors.mainColorRed
                                              .withOpacity(0.27),
                                          blurRadius: 10,
                                        ),
                                      ]),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.transparent),
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              GlobalColors.secondaryColorGreen),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      )),
                                    ),
                                    onPressed: () {
                                      _value == 1
                                          ? _showMyDialogDelete(false)
                                          : _showMyDialogDelete(true);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.playlist_remove_outlined,
                                                color: Colors.white,
                                              ),
                                              arLnag
                                                  ? SizedBox(
                                                      width: 5,
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                    ),
                                              Text(
                                                '  delButton  '.tr,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _value == 1
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  GlobalColors.mainColorGreen,
                                                  GlobalColors
                                                      .secondaryColorGreen
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: GlobalColors
                                                    .mainColorGreen
                                                    .withOpacity(0.27),
                                                blurRadius: 10,
                                              ),
                                            ]),
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.transparent),
                                            foregroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    GlobalColors
                                                        .secondaryColorGreen),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            )),
                                          ),
                                          onPressed: () {
                                            selectedAllGetter();
                                            _showMyDialog();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.checklist_rtl,
                                                      color: Colors.white,
                                                      // size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      '  confButton  '.tr,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          //   ],
                          // ),
                        ),
                        //containers of buttons ende
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//the method of intilizing vid
  Widget videoContet() {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width, //*
          height: 200,
          padding: arLnag
              ? EdgeInsets.only(left: 10, right: 10)
              : EdgeInsets.only(left: 10, right: 10),
          child: controller.value.isInitialized
              ? VideoPlayer(controller)
              : Container(),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(
            left: arLnag ? 0 : 150,
            right: arLnag ? 150 : 0,
            bottom: 50,
            top: 50),
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              Container(
                height: 50,
                child: Image.asset(
                  'assets/images/loadingLogoBlack.png', //make it pop up
                  height: 105,
                  width: 105,
                ),
              ),
              Container(
                height: 35,
                width: 35,
                padding: EdgeInsets.only(left: 3),
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ]),
            // Container(
            //   height: 50,
            //   padding: EdgeInsets.only(right: 6, top: 0),
            //   child: Image.asset(
            //     'assets/images/rasdTextBlack.png', //make it pop up
            //     height: 105,
            //     width: 105,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }
  }
}
