import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/shared/GlobalColors.dart';

class privacy extends StatefulWidget {
  const privacy({Key? key}) : super(key: key);

  @override
  _privacyState createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  bool arLnag = 'RASDPP'.tr == 'RASD Privacy Policy' ? false : true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
              child: Text('RASDPP'.tr,
                  style: TextStyle(color: GlobalColors.mainColorGreen)),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
              ),
              color: GlobalColors.mainColorGreen,
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
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
                    style:
                        TextStyle(fontSize: 16, color: GlobalColors.textColor),
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
                    style:
                        TextStyle(fontSize: 16, color: GlobalColors.textColor),
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
                    style:
                        TextStyle(fontSize: 16, color: GlobalColors.textColor),
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
                    style:
                        TextStyle(fontSize: 16, color: GlobalColors.textColor),
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
                    style:
                        TextStyle(fontSize: 16, color: GlobalColors.textColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
