import 'package:flutter/material.dart';

Widget optionWidget(Size size, IconData icon, String text, onTab) {
  return GestureDetector(
    onTap: onTab,
    child: Column(
      children: <Widget>[
        Container(
          width: size.height * 0.07,
          height: size.height * 0.07,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white, width: size.height * 0.0005)),
          child: Center(
              child: Icon(
            icon,
            color: Colors.white,
            size: size.height * 0.03,
          )),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}
