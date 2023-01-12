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

import '../model/report.dart';

//final _AdditionalInfo = TextEditingController();

class EditFile extends StatefulWidget {
  // const showVideo({Key? key}) : super(key: key);

  const EditFile(
      {super.key, required this.reportDocid, required this.userDocid});
  final String reportDocid;
  final String userDocid;
  @override
  State<EditFile> createState() => _showVideoState();
}

class _showVideoState extends State<EditFile> {
  List<CheckBoxState> selecteditems = [];
  VideoPlayerController? _controller;
  String video_url = "";

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  final TextEditingController _EditAddInfoController =
      new TextEditingController();
  String editAddInfoText = "";

  @override
  void initState() {
    //to retrive additional information & violation type
    retriveInfo();
    retriveTypes();
    _EditAddInfoController.text = editAddInfoText;
    super.initState();
    // this is for retriving video url
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
                // video_url =
                //     'https://firebasestorage.googleapis.com/v0/b/rasd-d3906.appspot.com/o/Videos%2F3la_altreq-1262081362107998209-20200517_210339-vid1.mp4?alt=media&token=b5b68317-d098-476f-88a5-259d61a93b2b';
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

  //violation types ( check boxes )
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

  //collect all violations type
  var selectedV1 = "";
  var selectedV2 = "";
  var selectedAll = "";
  void typesV1(String vtitle) {
    selectedV1 += vtitle + ",";
  }

  void typesV2(String vtitle) {
    selectedV2 += vtitle + ",";
  }

  void selectedAllGetter() {
    selectedAll = selectedV1 + "" + selectedV2;
  }
  //////////////////////////////////

  bool done = false;
  bool delete = false;
  //to know the language
  bool arLnag = "showVideoHead".tr == 'Violation Video' ? false : true;
  //List of the violation types selected by the driver (Before editing)
  List<String> VolationTypesBeforeEditing = [];

  String AddInfoBefore = "";

  //show sucessfull (done trans)
  void _showSucess(String descr, int index) {
    //   _AdditionalInfo.text = "";
    AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'success'.tr,
        desc: 'successEditing'.tr,
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

  // after clicking confirm (done trans)
  Future<void> _showMyDialog() async {
    return AwesomeDialog(
        context: context,
        btnCancelColor: Colors.grey,
        btnOkColor: GlobalColors.secondaryColorGreen,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: 'Sure'.tr,
        desc: 'confEdit'.tr,
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
              'addInfo':
                  editAddInfoText, //update database with new addtional information
            });
            _showSucess('conf'.tr, 2); //*** Edit here to go pdf********/
          }
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    // getVidUrl();
    //retriveInfo();
    debugPrint(values1.values.toString());
    _EditAddInfoController.text =
        editAddInfoText; // this is to show the additional info on the interface
    //thid is for the crouser to be at the end of the text
    _EditAddInfoController.selection = TextSelection.fromPosition(
        TextPosition(offset: _EditAddInfoController.text.length));
    print("-----------------------");
    print(_EditAddInfoController.text.length);

    debugPrint(AddInfoBefore);
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
              //goes to pdf
              Navigator.pop(context);
            },
          ),
          title: Text('EditReportHead'.tr),
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
                                //*//
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  // color: Colors.green,
                                  // height: 300,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(children: [
                                    // Text('violationType'.tr,
                                    //     textAlign: TextAlign.start,
                                    //     style: TextStyle(
                                    //         color:
                                    //             GlobalColors.mainColorGreen,
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.w500)),
                                    Stack(
                                      children: [
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
                                                    maxLines: 8,
                                                    style: TextStyle(
                                                        color: GlobalColors
                                                            .mainColorGreen),
                                                    showCursor: true,
                                                    cursorColor: GlobalColors
                                                        .mainColorGreen,
                                                    expands: false,
                                                    decoration: InputDecoration(
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .always,
                                                      labelText:
                                                          'violationType'.tr,
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
                                                    //   controller: _AdditionalInfo,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          // color: Colors.red,
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  right: 15,
                                                )),
                                                Expanded(
                                                    flex: 10,
                                                    child: Column(
                                                      children: values1.keys
                                                          .map((String key) {
                                                        return Transform.scale(
                                                          scale: 0.8,
                                                          child: Container(
                                                            // color: Colors.red,
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 0,
                                                            ),
                                                            child:

                                                                ///*****check boxes of violation types *******///
                                                                CheckboxListTile(
                                                                    contentPadding:
                                                                        EdgeInsets.only(
                                                                            right:
                                                                                0),
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .leading,
                                                                    activeColor:
                                                                        GlobalColors
                                                                            .mainColorGreen,
                                                                    title: Transform
                                                                        .translate(
                                                                      offset:
                                                                          const Offset(
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
                                                                    value:
                                                                        values1[
                                                                            key],
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
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
                                                      children: values2.keys
                                                          .map((String key) {
                                                        return Transform.scale(
                                                          scale: 0.8,
                                                          child: Container(
                                                            // color: Colors.red,
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 0,
                                                            ),
                                                            child:
                                                                CheckboxListTile(
                                                                    contentPadding:
                                                                        EdgeInsets.only(
                                                                            right:
                                                                                0),
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .leading,
                                                                    activeColor:
                                                                        GlobalColors
                                                                            .mainColorGreen,
                                                                    title: Transform
                                                                        .translate(
                                                                      offset:
                                                                          const Offset(
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
                                                                    value:
                                                                        values2[
                                                                            key],
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        values2[key] =
                                                                            value!;
                                                                        selectedV2 =
                                                                            "";
                                                                        values2.forEach((key,
                                                                            value) {
                                                                          if (value) {
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
                                        padding:
                                            EdgeInsets.fromLTRB(28, 0, 28, 0),
                                        child: Column(
                                          children: [
                                            Material(
                                              elevation: 7.0,
                                              shadowColor:
                                                  Colors.black.withOpacity(0.4),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                                child: TextField(
                                                  // initialValue: 'sarah',
                                                  style: TextStyle(
                                                      color: GlobalColors
                                                          .mainColorGreen),
                                                  showCursor: true,
                                                  cursorColor: GlobalColors
                                                      .mainColorGreen,
                                                  expands: false,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
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
                                                          style:
                                                              BorderStyle.solid,
                                                          color: GlobalColors
                                                              .mainColorGreen),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          style:
                                                              BorderStyle.solid,
                                                          color: GlobalColors
                                                              .mainColorGreen),
                                                    ),
                                                  ),
                                                  controller:
                                                      _EditAddInfoController,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )), //end of additional info textfield
                                  ]),
                                )
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
                              _value == 1
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                          left: 80, right: 0),
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
                                            setState(() {
                                              // to save the new value of additional information in varible infotest
                                              editAddInfoText =
                                                  _EditAddInfoController.text;
                                            });
                                            selectedAllGetter();
                                            _showMyDialog();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Row(
                                                  children: [
                                                    // Icon(
                                                    //   Icons.checklist_rtl,
                                                    //   color: Colors.white,
                                                    //   // size: 15,
                                                    // ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      'editLink'.tr,
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

  //retrive information before editing
  Future<void> retriveInfo() async {
    report r;
    final docReport = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(widget.userDocid) // here we got the document of the driver
        .collection("reports")
        .doc(widget
            .reportDocid) // here we got the document of the specfied report
        .get() // this is used to get the fields
        .then((docReport) {
      // then means
      //  debugPrint(docReport.exists.toString());
      r = report.fromJsonD(docReport
          .data()!); // we convert the data from json to report object (to get access to the attrubites )
      editAddInfoText = r.addInfo; // addInfoBefore
    });
  }

// this is for Violation types
  Future<void> retriveTypes() async {
    report r;
    final docReport = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(widget.userDocid)
        .collection("reports")
        .doc(widget.reportDocid)
        .get()
        .then((docReport) {
      //  debugPrint(docReport.exists.toString());
      r = report.fromJsonD(docReport.data()!);

      String tmp = r.v_type; //store all violation types as string
      VolationTypesBeforeEditing =
          tmp.split(","); // store the violation types as list
      debugPrint(VolationTypesBeforeEditing.toString());
      // make the checkboxes checked (Before editing)
      for (int i = 0; i < VolationTypesBeforeEditing.length; i++) {
        // check values
        (values1).forEach((key, value) {
          debugPrint(key);
          if (key == VolationTypesBeforeEditing[i]) {
            print(values1);
            values1[key] = !value;
            typesV1(key);
          }
        });
        debugPrint("////////");

        (values2).forEach((key, value) {
          if (key == VolationTypesBeforeEditing[i]) {
            values2[key] = !value;
            typesV2(key);
          }
        });
      }
    });
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
