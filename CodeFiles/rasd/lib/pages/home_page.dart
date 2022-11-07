// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rasd/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rasd/appRoot.dart';
import 'package:rasd/shared/padding.dart';
import 'package:rasd/model/report.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/pages/linkDashCam.dart';
import '../model/driver.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final User? user = Auth().currentUser;
  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  bool arLnag = "greeting".tr == 'Welcome To Rasd' ? false : true;
  bool isLinked = false;
  List<report> vidListtest = []; // this is for pending reports
  List<report> vidListtest2 = []; // this is for confirmed reports
  String dashcamIP = "";

  @override
  // for loading the page
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
              'assets/images/loadingLogoBlack.png', //make it pop up
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

/////////////////////
  Future<Driver?> readUser(uid) async {
    final docUser =
        await FirebaseFirestore.instance.collection('drivers').doc(uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Driver.fromJsonD(snapshot.data()!);
    }
  }

/////////////////
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0x00DE4B4B),
          brightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder<Driver?>(
          future: readUser(user?.uid),
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

  ///############################retrive number of pending###########################################################
  Future<void> retrivePending() async {
    final QuerySnapshot<Map<String, dynamic>> PendingReportsQuery =
        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(user?.uid)
            .collection("reports")
            .where('status', isEqualTo: 0)
            .get(); //get all documents in sub collections (get all reports)
    final List<report> allPendingreports = PendingReportsQuery.docs
        .map((PendingReportsDoc) => report.fromSnapShot(PendingReportsDoc))
        .toList();
    if (mounted) {
      setState(() {
        vidListtest = allPendingreports;
      });
    }
  }

  ///############################retrive number of confirmed###########################################################
  Future<void> retriveConfirmed() async {
    final QuerySnapshot<Map<String, dynamic>> PendingReportsQuery =
        await FirebaseFirestore.instance
            .collection("drivers")
            .doc(user?.uid)
            .collection("reports")
            .where('status', whereIn: [
      1,
      2
    ]).get(); //get all documents in sub collections (get all reports)
    final List<report> allConfrimedreports = PendingReportsQuery.docs
        .map((ConfirmedReportsDoc) => report.fromSnapShot(ConfirmedReportsDoc))
        .toList();
    if (mounted) {
      setState(() {
        vidListtest2 = allConfrimedreports;
      });
    }
  }

  /////////////////////////////////////////////////////
  ///
  Widget buildUser(Driver driver) => getBody(driver);

  Widget getBody(Driver driver) {
    return Container(
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
            padding: const EdgeInsets.only(top: 18, right: 10, left: 20),
            width: MediaQuery.of(context).size.width,
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Container()),
                  Container(
                      padding: EdgeInsets.only(top: 15),
                      width: spacer,
                      child: Image.asset(
                        'assets/images/logoWhite.png',
                      )),
                ]),
                SizedBox(
                  height: 0.2,
                ),
                Padding(
                  padding: arLnag
                      ? const EdgeInsets.only(right: 10.0)
                      : const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arLnag
                            ? "أهلًا " + driver.Fname.capitalize! + "،"
                            : "Hi " + driver.Fname.capitalize! + ",",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "greeting".tr,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
                  height: 5,
                ),
                //the big white box is represented by this row

                Row(),

                //part of listed videos should start here

                Expanded(
                  //inside this expanded you should put your page code
                  child: _listView(driver.dashcam_id),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _listView(String dashID) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: spacer),
      child: Column(children: [
        SizedBox(height: 15),

        //_linkButton(),
        buildLinkingCard(dashID),
        buildPendingCard(),
        buildConfirmedCard(),
        //   _signOutButton()
      ]),
    );
  }

  //The Ip address of the linked dashcam:

//####################################Bulid pending Card#########################################################################
  Padding buildPendingCard() {
    retrivePending();
    int numPending = vidListtest.length;
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 25, left: 25, bottom: 20),
      child: Container(
        // height: 200,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                // left side padding is 40% of total width
                left:
                    arLnag ? 30 : MediaQuery.of(context).size.width * .35, // *
                top: 20,
                right:
                    arLnag ? MediaQuery.of(context).size.width * .35 : 30, //*
              ),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "pendVid".tr,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: GlobalColors.textColor,
                          fontSize: arLnag ? 20 : 25),
                    ),
                    TextSpan(
                      text: numPending == 0
                          ? "noPending".tr
                          : numPending == 1
                              ? "pendVidNum1".tr +
                                  "$numPending" +
                                  "pendVidNum2singular".tr
                              : "pendVidNum1".tr +
                                  "$numPending" +
                                  "pendVidNum2".tr,
                      style: TextStyle(
                        fontSize: 15,
                        color: GlobalColors.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: arLnag ? 27 : 20,
                  top: arLnag ? 0 : 30,
                  left: arLnag ? 0 : 15), //*
              alignment:
                  arLnag ? Alignment.centerRight : Alignment.centerLeft, //*
              child: Stack(alignment: Alignment.center, children: [
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
                    Icons.videocam_rounded,
                    size: 105,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.watch_later_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
            Container(
              alignment:
                  arLnag ? Alignment.bottomLeft : Alignment.bottomRight, // *
              padding: EdgeInsets.only(
                  left: arLnag ? 10 : 0, right: 10, bottom: arLnag ? 5 : 15),
              child: Container(
                //alignment: Alignment.bottomRight,
                //padding: const EdgeInsets.only(left: 0, right: 2),

                height: 35,
                width: 80,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          GlobalColors.mainColorGreen,
                          GlobalColors.secondaryColorGreen
                        ]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(225, 4, 99, 65).withOpacity(0.27),
                        blurRadius: 10,
                      ),
                    ]),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.transparent),
                    foregroundColor: MaterialStatePropertyAll<Color>(
                        GlobalColors.secondaryColorGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RootApp(
                                  pageIndex: 1,
                                )));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          'viewButton'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: arLnag ? 15 : 18,
                              height: 1),
                        ),
                      ), // <-- Text
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        // <-- Icon
                        Icons.arrow_forward_ios_rounded,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //#############################################bliud confirmed card###############################################
  Padding buildConfirmedCard() {
    retriveConfirmed();
    int numConfirmed = vidListtest2.length;
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 25, left: 25, bottom: 20),
      child: Container(
        // height: 200,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                // left side padding is 40% of total width
                left:
                    arLnag ? 30 : MediaQuery.of(context).size.width * .35, // *
                top: 20,
                right:
                    arLnag ? MediaQuery.of(context).size.width * .35 : 30, //*
              ),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "ConfRep".tr,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: GlobalColors.textColor,
                          fontSize: arLnag ? 20 : 22),
                    ),
                    TextSpan(
                      text: numConfirmed == 0
                          ? "noConfirmed".tr
                          : "confRepNum1".tr + " $numConfirmed",
                      style: TextStyle(
                        fontSize: 15,
                        color: GlobalColors.textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  bottom: arLnag ? 30 : 30, top: 0, left: arLnag ? 0 : 15), //*
              alignment:
                  arLnag ? Alignment.centerRight : Alignment.centerLeft, //*
              child: Container(
                child: Stack(alignment: Alignment.center, children: [
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
                      Icons.file_copy,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 0, top: 40),
                    child: Icon(
                      Icons.check_sharp,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              alignment:
                  arLnag ? Alignment.bottomLeft : Alignment.bottomRight, // *
              padding: EdgeInsets.only(
                  left: arLnag ? 10 : 0, right: 10, bottom: arLnag ? 5 : 15),
              child: Container(
                //alignment: Alignment.bottomRight,
                //padding: const EdgeInsets.only(left: 0, right: 2),

                height: 35,
                width: 80,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          GlobalColors.mainColorGreen,
                          GlobalColors.secondaryColorGreen
                        ]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(225, 4, 99, 65).withOpacity(0.27),
                        blurRadius: 10,
                      ),
                    ]),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.transparent),
                    foregroundColor: MaterialStatePropertyAll<Color>(
                        GlobalColors.secondaryColorGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RootApp(
                                  pageIndex: 2,
                                )));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          'viewButton'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: arLnag ? 15 : 18,
                              height: 1),
                        ),
                      ), // <-- Text
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        // <-- Icon
                        Icons.arrow_forward_ios_rounded,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//##########################################bluid linking card ########################################################
  Container buildLinkingCard(String dashID) {
    final uid1 = user!.uid.toString();
    return dashID != 'null'
        ? Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, right: 25, left: 25, bottom: 20),
              child: Container(
                //height: 230,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        // left side padding is 40% of total width
                        left: arLnag
                            ? 30
                            : MediaQuery.of(context).size.width * .35, // *
                        top: 20,
                        right: arLnag
                            ? MediaQuery.of(context).size.width * .35
                            : 30, //*
                      ),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "DLS".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: GlobalColors.textColor,
                                        fontSize: arLnag ? 20 : 20),
                              ),
                              TextSpan(
                                text: "DLSA".tr + " " + dashID, // edit it
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      GlobalColors.textColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      alignment:
                          arLnag ? Alignment.centerRight : Alignment.centerLeft,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
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
                                Icons.linked_camera_outlined,
                                size: 90,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: arLnag
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight, // *
                      padding: EdgeInsets.only(
                          left: arLnag ? 5 : 0,
                          right: 5,
                          bottom: arLnag ? 5 : 5),
                      child: Container(
                        //alignment: Alignment.bottomRight,
                        //padding: const EdgeInsets.only(left: 0, right: 2),
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  GlobalColors.mainColorGreen,
                                  GlobalColors.secondaryColorGreen
                                ]),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(225, 4, 99, 65)
                                    .withOpacity(0.27),
                                blurRadius: 10,
                              ),
                            ]),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.transparent),
                            foregroundColor: MaterialStatePropertyAll<Color>(
                                GlobalColors.secondaryColorGreen),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LinkPage(
                                          linked: true,
                                          uid: uid1,
                                        )));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  'editLink'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: arLnag ? 15 : 18,
                                      height: 1),
                                ),
                              ), // <-- Text
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                // <-- Icon
                                Icons.arrow_forward_ios_rounded,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, right: 25, left: 25, bottom: 20),
              child: Container(
                //height: 230,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        // left side padding is 40% of total width
                        left: arLnag
                            ? 30
                            : MediaQuery.of(context).size.width * .35, // *
                        top: 20,
                        right: arLnag
                            ? MediaQuery.of(context).size.width * .35
                            : 30, //*
                      ),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "LD".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: GlobalColors.textColor,
                                        fontSize: arLnag ? 20 : 25),
                              ),
                              TextSpan(
                                text: "LDA".tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      GlobalColors.textColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      alignment:
                          arLnag ? Alignment.centerRight : Alignment.centerLeft,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
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
                                Icons.linked_camera_outlined,
                                size: 90,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: arLnag
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight, // *
                      padding: EdgeInsets.only(
                          left: arLnag ? 10 : 0,
                          right: 10,
                          bottom: arLnag ? 5 : 15),
                      child: Container(
                        //alignment: Alignment.bottomRight,
                        //padding: const EdgeInsets.only(left: 0, right: 2),
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  GlobalColors.mainColorGreen,
                                  GlobalColors.secondaryColorGreen
                                ]),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(225, 4, 99, 65)
                                    .withOpacity(0.27),
                                blurRadius: 10,
                              ),
                            ]),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.transparent),
                            foregroundColor: MaterialStatePropertyAll<Color>(
                                GlobalColors.secondaryColorGreen),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LinkPage(
                                          linked: false,
                                          uid: uid1,
                                        )));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  'L'.tr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: arLnag ? 15 : 18,
                                      height: 1),
                                ),
                              ), // <-- Text
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                // <-- Icon
                                Icons.arrow_forward_ios_rounded,
                                size: 15.0,
                                color: Colors.white,
                              ),
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
}
