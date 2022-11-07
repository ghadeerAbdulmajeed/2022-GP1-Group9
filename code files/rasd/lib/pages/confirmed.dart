import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/auth.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/model/driver.dart';
import 'package:rasd/shared/padding.dart';
import 'package:rasd/model/video.dart';
import 'package:rasd/model/report.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rasd/shared/widgets/url_tex.dart';

class confirmed extends StatefulWidget {
  const confirmed({Key? key}) : super(key: key);

  @override
  _confirmedWidgetState createState() => _confirmedWidgetState();
}

class _confirmedWidgetState extends State<confirmed> {
  bool _playArea = false;
  bool arLnag = 'CVR'.tr == 'Confirmed Violation Reports' ? false : true;

  final User? user = Auth().currentUser;
  List<report> reportListTest = [];

  //###############################retrive all reports of the user#####################################
  Future<List<report>> retriveConfirmed() async {
    final QuerySnapshot<Map<String, dynamic>> ConfirmedReportsQuery =
        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(user?.uid)
            .collection("reports")
            .where('status', whereIn: [
      1,
      2
    ]).get(); //get all documents in sub collections (get all reports)
    final List<report> allConfirmedreports = ConfirmedReportsQuery.docs
        .map((ConfirmedReportsDoc) => report.fromSnapShot(ConfirmedReportsDoc))
        .toList();
    if (mounted) {
      setState(() {
        reportListTest = allConfirmedreports;
      });
    }
    return allConfirmedreports;
  }

  //###############################Display  a single report in pdf #####################################

  void pushReports(report report) {
    arLnag ? _displayPdf(report, user!.uid) : _displayPdfen(report, user!.uid);
  }

  //####################################################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //first container after the body
          Container(
        //the green background
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            GlobalColors.mainColorGreen,
            GlobalColors.secondaryColorGreen
          ], begin: const FractionalOffset(0.0, 0.4), end: Alignment.topRight),
        ),
        child: Column(
          children: [
            Container(
              //for elemnts on the top
              padding: const EdgeInsets.only(top: 18, right: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => WidgetTree()));
                      //   },
                      //   child: Icon(Icons.arrow_back_ios_rounded,
                      //       size: 30, color: Colors.white),
                      // ),
                      Expanded(child: Container()),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          width: spacer,
                          child: Image.asset(
                            'assets/images/logoWhite.png',
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 0.2,
                  ),
                  Text(
                    "CVR".tr,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Send".tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: const Offset(
                        3.0,
                        8.0,
                      ), //Offset
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  //the big white box is represented by this row

                  Row(),

                  //part of listed videos should start here
                  Expanded(
                    //inside this expanded you should put your page code
                    child: _listView(),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

//###################################display cards (reports) ##########################################
  _listView() {
    //List<report> reportList = retriveConfirmed() as List<report>;
    retriveConfirmed();
    return reportListTest.length == 0
        ? Container(
            padding: EdgeInsets.only(
              left: 5,
            ),
            child: Column(children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          GlobalColors.mainColorGreen,
                          GlobalColors.secondaryColorGreen,
                        ],
                        tileMode: TileMode.clamp,
                      ).createShader(bounds),
                      child: Icon(
                        Icons.file_copy_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 35, left: 10),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            GlobalColors.mainColorGreen,
                            GlobalColors.secondaryColorGreen,
                          ],
                          tileMode: TileMode.clamp,
                        ).createShader(bounds),
                        child: Icon(
                          Icons.close_rounded,
                          size: 33,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "NVR".tr,
                        style: TextStyle(
                            color: GlobalColors.secondaryColorGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        child: Text(
                          "NVRA".tr,
                          style: TextStyle(
                              color: GlobalColors.textColor, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            itemCount: reportListTest.length,
            itemBuilder: (_, int index) {
              return GestureDetector(
                child: _buildCard(index + 1),
              );
            });
  }

  //######################################this is for the single card############################################

  _buildCard(int index) {
    return Container(
      height: 135,
      //color: Colors.red,
      width: 200,
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {
            pushReports(reportListTest[index - 1]);
          },
          child: Row(
            children: [
              Icon(
                Icons.file_copy_outlined,
                size: 40,
                color: GlobalColors.mainColorGreen,
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Text(
                    "VR".tr + " $index",
                    style: TextStyle(
                        color: GlobalColors.mainColorGreen,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
            ),
            Row(
              children: [
                for (int i = 0; i < 125; i++)
                  i.isEven
                      ? Container(
                          width: 2,
                          height: 1,
                          decoration: BoxDecoration(
                            color: GlobalColors.mainColorRed,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      : Container(
                          width: (MediaQuery.of(context).size.width /
                                  MediaQuery.of(context).size.height) *
                              4,
                          height: 1,
                        ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  /// display a pdf document. // my work
  //#####################################display a pdf document (arabic version) ###############################################
  void _displayPdf(report reportDoc, String userDocid) async {
    var now = DateTime.now();
    var formatter = DateFormat.yMd('en_US').add_jm();
    String formattedDate = formatter.format(now);

    //Retrive URL
    // retrive all documents from video
    final QuerySnapshot<Map<String, dynamic>> docVideo = await FirebaseFirestore
        .instance
        .collection("drivers")
        .doc(user!.uid)
        .collection("reports")
        .doc(reportDoc.id)
        .collection("video")
        .get();
    // convert from snapshot to list of documents then get the first documnet then get the video url
    var video_url = docVideo.docs
        .map((reportVid) => video.fromSnapShot(reportVid))
        .toList()[0]
        .video_url;

    //Retrive Driver's Name
    Driver d;
    final docUser = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(user!.uid)
        .get();
    String name = '';
    if (docUser.exists) {
      d = Driver.fromJsonD(docUser.data()!);
      name = d.Fname.capitalize! + ' ' + d.Lname.capitalize!;
    }

    //Retrive Email
    String email = '';
    email = user!.email!;

    //Retrive Violation Type
    report r;
    final docReport = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(user!.uid)
        .collection("reports")
        .doc(reportDoc.id)
        .get();
    String v_type = '';
    if (docReport.exists) {
      r = report.fromJsonD(docReport.data()!);

      v_type = r.v_type;
      if (v_type == "") {
        // if the user did not select any violation type
        v_type = "NotSelected".tr;
      } else {
        //if the user select a violation type
        v_type = v_type.substring(0, v_type.length - 1);
      }
    }

    final rasdLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logoWhite.png'))
            .buffer
            .asUint8List());
    final wave = pw.MemoryImage(
        (await rootBundle.load('assets/images/wave5.png'))
            .buffer
            .asUint8List());
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Tajawal-Medium.ttf"));
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        margin: pw.EdgeInsets.symmetric(
          horizontal: 1,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: 595,
                height: 120,
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#045341'),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 10),
                      child: pw.Expanded(
                        flex: 1,
                        child: pw.SizedBox(
                          height: 100,
                          width: 150,
                          child: pw.Image(rasdLogo),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 20),
                      child: pw.Expanded(
                        flex: 1,
                        child: pw.Directionality(
                          textDirection: pw.TextDirection.rtl,
                          child: pw.Text(
                            textAlign: pw.TextAlign.right,
                            "ViolationRep".tr,
                            style: pw.TextStyle(
                              fontSize: 26,
                              color: PdfColors.white,
                              // fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(
                height: 30,
              ),
              pw.Container(
                padding: pw.EdgeInsets.only(right: 20),
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Text(
                      textAlign: pw.TextAlign.right,
                      'des'.tr,
                      style: pw.TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Divider(
                color: PdfColors.black,
              ),
              pw.SizedBox(
                height: 93,
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 10, right: 10),
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    style: pw.BorderStyle.solid,
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            color: PdfColor.fromHex('#045341'),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    'email'.tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            color: PdfColor.fromHex('#045341'),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.right,
                                    "name".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(
                                  textAlign: pw.TextAlign.left,
                                  email,
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    name,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 10, right: 10),
                child: pw.Table(
                  columnWidths: {
                    0: pw.FractionColumnWidth(.6),
                    1: pw.FractionColumnWidth(.4),
                  },
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    style: pw.BorderStyle.solid,
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    formattedDate,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "VTime".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                UrlText('Violation Video Link', video_url),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "link".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 80,
                            padding: pw.EdgeInsets.only(left: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    v_type,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 80,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "viotype".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 45),
              pw.Container(
                width: 1000,
                height: 200,
                child: pw.Row(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(
                        top: 4,
                        left: 0,
                        bottom: 0,
                        // right: 10,
                      ),
                      child: pw.Image(
                        wave,
                        width: 800,
                      ),
                    )
                  ],
                ),
              ),
              // ),
            ],
          );
        },
      ),
    );

    /// open Preview Screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
            // **I changed here because i need reportID and userID for delete report
            doc: pdf,
            ReportdocID: reportDoc.id,
            ReportStatus: reportDoc.status,
            UserdocID: userDocid,
          ),
        ));
  }

  //#####################################display a pdf document (english version) ###############################################

  void _displayPdfen(report reportDoc, String userDocid) async {
    var now = DateTime.now();
    var formatter = DateFormat.yMd('en_US').add_jm();
    String formattedDate = formatter.format(now);
    //Retrive URL
    // retrive all documents from video
    final QuerySnapshot<Map<String, dynamic>> docVideo = await FirebaseFirestore
        .instance
        .collection("drivers")
        .doc(user!.uid)
        .collection("reports")
        .doc(reportDoc.id)
        .collection("video")
        .get();
    // convert from snapshot to list of documents then get the first documnet then get the video url
    var video_url = docVideo.docs
        .map((reportVid) => video.fromSnapShot(reportVid))
        .toList()[0]
        .video_url;

    //Retrive Driver's Name
    Driver d;
    final docUser = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(user!.uid)
        .get();
    String name = '';
    if (docUser.exists) {
      d = Driver.fromJsonD(docUser.data()!);
      name = d.Fname.capitalize! + ' ' + d.Lname.capitalize!;
    }

    //Retrive Email
    String email = '';
    email = user!.email!;

    //Retrive Violation Type
    report r;
    final docReport = await FirebaseFirestore.instance
        .collection("drivers")
        .doc(user!.uid)
        .collection("reports")
        .doc(reportDoc.id)
        .get();
    String v_type = '';
    if (docReport.exists) {
      r = report.fromJsonD(docReport.data()!);
      v_type = r.v_type;
      if (v_type == "") {
        // if the user did not select any violation type
        v_type = "NotSelected".tr;
      } else {
        // if the user  select any violation type
        v_type = v_type.substring(0, v_type.length - 1);
      }
    }

    final rasdLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logoWhite.png'))
            .buffer
            .asUint8List());
    final wave = pw.MemoryImage(
        (await rootBundle.load('assets/images/wave5.png'))
            .buffer
            .asUint8List());
    var arabicFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Tajawal-Medium.ttf'));
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        margin: pw.EdgeInsets.symmetric(
          horizontal: 1,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: 595,
                height: 120,
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#045341'),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(left: 20),
                      child: pw.Expanded(
                        flex: 1,
                        child: pw.Directionality(
                          textDirection: pw.TextDirection.rtl,
                          child: pw.Text(
                            "ViolationRep".tr,
                            style: pw.TextStyle(
                              fontSize: 24,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 10),
                      child: pw.Expanded(
                        flex: 1,
                        child: pw.SizedBox(
                          height: 100,
                          width: 150,
                          child: pw.Image(rasdLogo),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(
                height: 30,
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    textAlign: pw.TextAlign.left,
                    'des'.tr,
                    style: pw.TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Divider(
                color: PdfColors.black,
              ),
              pw.SizedBox(
                height: 93,
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 10, right: 10),
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    style: pw.BorderStyle.solid,
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            color: PdfColor.fromHex('#045341'),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "name".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            color: PdfColor.fromHex('#045341'),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    'email'.tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            height: 45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    name,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 45,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(
                                  textAlign: pw.TextAlign.left,
                                  email,
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 10, right: 10),
                child: pw.Table(
                  columnWidths: {
                    0: pw.FractionColumnWidth(.4),
                    1: pw.FractionColumnWidth(.6),
                  },
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    style: pw.BorderStyle.solid,
                    width: 2,
                  ),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "VTime".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    formattedDate,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "link".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 50,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                UrlText('Violation Video Link', video_url),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            color: PdfColor.fromHex('#045341'),
                            height: 80,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    "viotype".tr,
                                    style: pw.TextStyle(
                                      fontSize: 22,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 80,
                            padding: pw.EdgeInsets.only(left: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    textAlign: pw.TextAlign.left,
                                    v_type,
                                    style: pw.TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Container(
                width: 1000,
                height: 200,
                // color: PdfColors.black,
                child: pw.Row(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(
                        top: 4,
                        left: 0,
                        bottom: 0,
                        // right: 10,
                      ),
                      child: pw.Image(
                        wave,
                        width: 800,
                      ),
                    )
                  ],
                ),
              ),
              // ),
            ],
          );
        },
      ),
    );

    /// open Preview Screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(
              // **I changed here because i need reportID and userID for delete report
              doc: pdf,
              ReportdocID: reportDoc.id,
              ReportStatus: reportDoc.status,
              UserdocID: userDocid),
        ));
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;
  final String ReportdocID;
  final String UserdocID;
  final int ReportStatus;

  const PreviewScreen({
    Key? key,
    // **I changed here because i need reportID and userID for delete report
    required this.doc,
    required this.ReportdocID,
    required this.UserdocID,
    required this.ReportStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //##########################################################changes are made here################################
    bool delete = false;
    //############################################show sucess dialog (After deletion) #################################
    void _showSucess() {
      AwesomeDialog(
          context: context,
          btnCancelColor: Colors.grey,
          btnOkColor: GlobalColors.secondaryColorGreen,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          title: 'success'.tr,
          desc: 'Rdelete'.tr,
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RootApp(
                          pageIndex: 2,
                        )));
          }).show();
    }

    //delete report with the video
    //############################################show delete dialog (before deletion) #################################

    Future<void> _showMyDialogDelete() async {
      return AwesomeDialog(
          context: context,
          btnCancelColor: Colors.grey,
          btnOkColor: GlobalColors.secondaryColorRed,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          // barrierColor: GlobalColors.mainColorGreen,
          title: 'Sure'.tr,
          desc: 'delConfreport'.tr,
          btnOkText: "yes".tr,
          btnCancelOnPress: () {
            delete = false;
          }, // will stay in the same page
          btnOkOnPress: () async {
            //he/she wants to delete it
            delete = true;
            if (delete) {
              //############################################delete report after pressing yes #################################

              final reportDoc = FirebaseFirestore.instance
                  .collection("drivers")
                  .doc(UserdocID)
                  .collection("reports")
                  .doc(ReportdocID);

              //get video
              final QuerySnapshot<
                  Map<String,
                      dynamic>> VideoDocInReport = await FirebaseFirestore
                  .instance
                  .collection("drivers")
                  .doc(UserdocID)
                  .collection("reports")
                  .doc(ReportdocID)
                  .collection("video")
                  .get(); //get all documents in sub collections (get all videos)
              final List<video> Vid = VideoDocInReport.docs
                  .map((Videos) => video.fromSnapShot(Videos))
                  .toList();

              //   String video_url = (Vid[0].video_url); // to save the url
              for (var doc in VideoDocInReport.docs) // delete sub colletcio
              {
                await doc.reference.delete();
              }

              reportDoc.delete(); // delete report

              _showSucess();
            }
          }).show();
    }

//#######################this for disabling share button
    bool isSent = false;
    Future<void> UpdateStatus() async {
      report r;

      final docReport = await FirebaseFirestore.instance
          .collection("drivers")
          .doc(UserdocID)
          .collection("reports")
          .doc(ReportdocID)
          .update({'status': 2});

      // int status = 1;
      // if (docReport.exists) {
      //   r = report.fromJsonD(docReport.data()!);
      //   status = r.status;
      //   if (status == 1) {
      //     isSent = false;
      //   } else {
      //     isSent = true;
      //   }
      // }

      //  return isSent;
    }

    //  bool status = getStatus() as bool;
    ///////////////////////////////till here///////////////////////////////////////////////
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
        ),
        title: Text('Preview'.tr),
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
        ),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: false,
        allowPrinting: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "filename".tr + ".pdf",
        //##########################################################changes are made here################################
        actions: [
          PdfShareAction(
            body: 'body'.tr,
            emails: ['group9.gp1444@gmail.com'],
            filename: "filename".tr + ".pdf",
            subject: 'subject'.tr,
            onShared: () {
              UpdateStatus();
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: GestureDetector(
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30,
              ),
              onTap: () async {
                _showMyDialogDelete();
              },
            ),
          ),
        ],
        //loading
        loadingWidget: Container(
          padding: EdgeInsets.only(bottom: 50, top: 50),
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
              Container(
                height: 50,
                padding: EdgeInsets.only(right: 6, top: 0),
                child: Image.asset(
                  'assets/images/rasdTextBlack.png', //make it pop up
                  height: 105,
                  width: 105,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        ///////////////////////////////till here///////////////////////////////////////////////
      ),
    );
  }
}
