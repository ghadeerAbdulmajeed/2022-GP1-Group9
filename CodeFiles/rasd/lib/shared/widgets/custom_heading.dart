import 'package:flutter/material.dart';

class CustomHeading extends StatelessWidget {
  const CustomHeading({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: 'Open Sans',
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            subTitle,
            style: TextStyle(
              color: color,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
