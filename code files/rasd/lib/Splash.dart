import 'package:flutter/material.dart';
import 'package:rasd/shared/GlobalColors.dart';
import 'package:rasd/widget_tree.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _splashState();
}

class _splashState extends State<Splash> {
  void initState() {
    super.initState();
    _navigatetoTree();
  }

  _navigatetoTree() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WidgetTree()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalColors.mainColorGreen,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  GlobalColors.mainColorGreen,
                  GlobalColors.secondaryColorGreen,
                  GlobalColors.mainColorGreen,
                ]),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoWhite.png', //make it pop up
                height: 150,
                width: 150,
              ),
            ],
          )),
        ));
  }
}
