import 'package:flutter/material.dart';
import 'package:link_previewer/link_previewer.dart';
import 'package:mobius_browser/Models/HistoryModel.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'package:mobius_browser/Pages/TabPage.dart';
import 'package:mobius_browser/Transitions/SlideT.dart';

Widget historyWidget(HistoryModel historyModel, Size size, onTap, context) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(historyModel.date);

  return GestureDetector(
    onTap: () => Navigator.push(
        context,
        SlideLeftRoute(
            page: TabPage(
          tabModel: TabModel(historyModel.link),
        ))),
    child: Container(
      height: size.height * 0.2,
      width: size.width * 0.8,
      padding: EdgeInsets.all(size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                date.month.toString() +
                    "/" +
                    date.day.toString() +
                    "/" +
                    date.year.toString(),
                style:
                    TextStyle(color: Colors.grey, fontSize: size.height * 0.02),
              ),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          LinkPreviewer(
            link: historyModel.link,
            showTitle: true,
            showBody: true,
            borderColor: Colors.transparent,
            borderRadius: size.height * 0.01,
            direction: ContentDirection.horizontal,
          ),
        ],
      ),
    ),
  );
}
