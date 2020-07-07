import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobius_browser/Models/FavModel.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'package:mobius_browser/Pages/TabPage.dart';
import 'package:mobius_browser/Transitions/SlideT.dart';
import 'package:random_color/random_color.dart';

Widget bookmarkWidget(Size size, FavModel favModel, onLongPress, context) {
  RandomColor _randomColor = RandomColor();
  return GestureDetector(
    onTap: () => Navigator.push(
        context,
        SlideLeftRoute(
            page: TabPage(
          tabModel: TabModel(favModel.link),
        ))),
    onLongPress: onLongPress,
    child: Container(
      width: size.height * 0.1,
      child: Column(
        children: <Widget>[
          Container(
              width: size.height * 0.07,
              height: size.height * 0.07,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: _randomColor.randomColor()),
              child: Center(
                child: Text(
                  favModel.name.substring(0, 1),
                  style: TextStyle(
                      color: Colors.black, fontSize: size.height * 0.035),
                ),
              )),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            favModel.name,
            maxLines: 1,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    ),
  );
}
