import 'package:flutter/material.dart';
import 'package:rasd/shared/GlobalColors.dart';

class SettingsTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  const SettingsTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: GlobalColors.mainColorGreen,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, color: GlobalColors.mainColorGreen),
        ),
        const Spacer(),
        InkWell(
          //   onTap: onTap,
          child: Container(
              width: 50,
              height: 50,
              child: Icon(Icons.arrow_forward_ios_rounded,
                  color: GlobalColors.mainColorGreen)),
        ),
      ],
    );
  }
}
