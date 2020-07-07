import 'package:flutter/material.dart';
import 'package:link_previewer/link_previewer.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'file:///C:/Users/R2D2/Documents/Flutter/mobius_browser/lib/Pages/TabPage.dart';
import 'package:mobius_browser/Transitions/ScaleT.dart';

Widget tabWidget(
  Size size,
  TabModel tabModel,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () => Navigator.push(
        context,
        ScaleRoute(
          page: TabPage(
            tabModel: tabModel,
          ),
        )),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
      child: Container(
        width: size.width * 0.4,
        height: size.height * 0.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.height * 0.015),
          child: LinkPreviewer(
            link: tabModel.link,
            showTitle: true,
            showBody: true,
            borderColor: Colors.transparent,
            borderRadius: size.height * 0.01,
            direction: ContentDirection.vertical,
          ),
        ),
      ),
    ),
  );
}
/*

ClipRRect(
          borderRadius: BorderRadius.circular(size.height * 0.015),
          child: LinkPreviewer(
            link: url,
            direction: ContentDirection.vertical,
            borderRadius: 0,
            backgroundColor: Colors.white,
            borderColor: kGradientEndColor,
            placeholder: tabPlaceHolderWidget(),
          ),
        )

LinkPreviewer(
          link: link,
          showTitle: false,
          showBody: false,
          borderColor: Colors.transparent,
          borderRadius: size.height * 0.01,
          direction: ContentDirection.vertical,
        ),*/
