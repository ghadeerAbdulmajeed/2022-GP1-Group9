import 'package:get/get.dart';
import 'package:rasd/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rasd/pages/settings/settings_screen.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/pages/confirmed.dart';
import 'package:rasd/pages/pendingVideos.dart';

class RootApp extends StatefulWidget {
  int pageIndex;
  RootApp({super.key, this.pageIndex = 0});

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  void getAll() {}

  Widget getBody() {
    List<Widget> pages = [
      HomePage(),
      pendingVid(),
      const confirmed(),
      SettingsScreen(),
    ];
    return IndexedStack(
      index: widget.pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    //list of icons not entered
    List bottomItems = [
      "assets/images/home_icon.svg",
      "assets/images/pendingVideos.svg",
      "assets/images/confirmed_icon.svg",
      "assets/images/settings-svgrepo-com.svg"
    ];
    //list of icons after entered
    List bottomItems2 = [
      "assets/images/home_icon2.svg",
      "assets/images/pendingVideos2.svg",
      "assets/images/confirmed_icon2.svg",
      "assets/images/settings-svgrepo-com2.svg"
    ];
    List textBar = ["Home".tr, "PV".tr, "CR".tr, "More".tr];
    return Container(
      width: size.width,
      height: 85,
      decoration: BoxDecoration(
        color: textWhite,
        boxShadow: [
          BoxShadow(
            color: textBlack.withOpacity(0.12),
            blurRadius: 30.0,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomItems.length, (index) {
              return InkWell(
                  onTap: () {
                    selectedTab(index);
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        widget.pageIndex == index
                            ? bottomItems2[index]
                            : bottomItems[index],
                        height: bottomItems[index] ==
                                "assets/images/pendingVideos.svg"
                            ? 32
                            : 25,
                        width: 30,
                        color: widget.pageIndex == index
                            ? GlobalColors.mainColorGreen
                            : secondary,
                      ),
                      bottomItems[index] == "assets/images/pendingVideos.svg"
                          ? SizedBox(
                              height: 5.0,
                            )
                          : SizedBox(height: 0),
                      Text(
                        textBar[index],
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                    ],
                  ));
            }),
          ),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      widget.pageIndex = index;
    });
  }
}
