import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/auth.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/pages/showVideo.dart';
import 'package:video_player/video_player.dart';
import 'package:rasd/shared/padding.dart';
import 'package:rasd/model/report.dart';

class pendingVid extends StatefulWidget {
  const pendingVid({Key? key}) : super(key: key);

  @override
  _pendingVidState createState() => _pendingVidState();
}

class _pendingVidState extends State<pendingVid> {
  bool _playArea = false;
  final User? user = Auth().currentUser;
  List<report> vidListtest = [];

  //retrive all pending reports videos of the user
  Future<List<report>> retrivePending() async {
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
    return allPendingreports;
  }

  void pushVid(report ReporttoPass) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => showVideo(
                  reportDocid: ReporttoPass.id,
                  userDocid: user!.uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: _playArea == false
              ? BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        GlobalColors.mainColorGreen,
                        GlobalColors.secondaryColorGreen
                      ],
                      begin: const FractionalOffset(0.0, 0.4),
                      end: Alignment.topRight),
                )
              : BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        GlobalColors.mainColorGreen,
                        GlobalColors.secondaryColorGreen
                      ],
                      begin: const FractionalOffset(0.0, 0.4),
                      end: Alignment.topRight),
                ),
          child: Column(children: [
            //   _playArea == false
            Container(
              padding: const EdgeInsets.only(top: 18, right: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
                    'PVV'.tr,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Watch".tr + "Select".tr,
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
                  //the big white box is represented by this box
                  Row(),
                  //part of listed videos should start here
                  Expanded(
                    //inside this expanded you should put your page code
                    child: _listView(),
                  )
                ],
              ),
            ))
          ])),
    );
  }

  _listView() {
    retrivePending();
    return vidListtest.length == 0
        ? Container(
            padding: EdgeInsets.only(left: 5),
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
                        Icons.videocam_off_rounded,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "NPV".tr,
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
                          "NPVA".tr,
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
            itemCount: vidListtest.length,
            itemBuilder: (_, int index) {
              return GestureDetector(
                child: _buildCard(index + 1),
              );
            });
  }

  _buildCard(int index) {
    return Container(
      height: 135,
      //color: Colors.red,
      //width was 200
      width: 200,
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {
            pushVid(vidListtest[index - 1]); // changed
          },
          child: Row(
            children: [
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
                    Icons.videocam_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 7),
                  child: Icon(
                    Icons.watch_later_rounded,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ]),
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Text(
                    "VV".tr + " $index",
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
                          width: 2,
                          height: 1,
                        ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
