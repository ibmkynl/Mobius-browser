import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobius_browser/Database/DatabaseHelper.dart';
import 'package:mobius_browser/Models/FavModel.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'package:mobius_browser/Pages/HistoryPage.dart';
import 'package:sqflite/sqflite.dart';
import 'TabPage.dart';
import '../Transitions/SlideT.dart';
import '../Widgets/bookmarkWidget.dart';
import '../Widgets/optionWidget.dart';
import '../Widgets/tabWidget.dart';
import '../constants.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

Size size;

class _AppPageState extends State<AppPage> {
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  TabModel _tabModel;
  FavModel _favModel;
  List<TabModel> tabList;
  List<FavModel> favList;
  int newPageId;
  int count = 0, favCount = 0;

  TextEditingController _textEditingController = new TextEditingController();
  TextEditingController _favName = new TextEditingController();
  TextEditingController _favLink = new TextEditingController();
  bool selected = false;

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TabModel>> tabListFuture = _databaseHelper.getTabList();
      tabListFuture.then((tabList) {
        setState(() {
          this.tabList = tabList;
          this.count = tabList.length;
          if (tabList.isNotEmpty) newPageId = this.tabList.last.id;
        });
      });
    });
  }

  void getFavList() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FavModel>> favListFuture = _databaseHelper.getFavList();
      favListFuture.then((favList) {
        setState(() {
          this.favList = favList;
          this.favCount = favList.length;
        });
      });
    });
  }

  void saveFav(FavModel favModel) {
    _favModel = favModel;
    _databaseHelper.insert(_favModel, 3);
    getFavList();
  }

  void updateFav(FavModel favModel) {
    _favModel = favModel;
    _databaseHelper.update(_favModel, 3);
    getFavList();
  }

  void deleteFav(id) {
    _databaseHelper.delete(id, 3);
    getFavList();
  }

  void save(String link) {
    _tabModel = new TabModel(link);
    _databaseHelper.insert(_tabModel, 1);
    updateListView();
  }

  void closeAll() {
    // _databaseHelper.deleteTab(newPageId);
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      database.delete("tab_table");
    });
    updateListView();
  } /*optionWidget(size, Icons.add, "Add new", () => _simpleDialog())*/

  Widget _addNewBookmark() =>
      optionWidget(size, Icons.add, "Add new", () => _simpleDialog());

  Future _simpleDialog() async => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: kGradientEndColor,
            title: Text(
              "Add to bookmarks",
              style: TextStyle(color: Colors.white),
            ),
            content: Wrap(
              children: <Widget>[
                TextField(
                  controller: _favName,
                ),
                TextField(
                  controller: _favLink,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () {
                    saveFav(FavModel(_favLink.text, _favName.text));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ));

  Future popUp() async {}

  Widget _simplePopup(id) => PopupMenuButton<int>(
        color: Colors.transparent,
        onSelected: (value) {
          value == 1 ? _simpleDialog() : deleteFav(id);
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 1,
              child: Icon(
                Icons.edit,
                color: Colors.green,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Icon(
                Icons.clear,
                color: Colors.red,
              ),
            )
          ];
        },
      );
  @override
  void initState() {
    if (tabList == null) {
      tabList = List<TabModel>();

      updateListView();
    }
    favList = List<FavModel>();
    getFavList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: kGradientEndColor,
        statusBarColor: kGradientStartColor));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: kGradientStartColor),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: size.height * 0.29,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              pinned: true,
              floating: false,
              snap: false,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/Logo.png",
                    scale: 1.7,
                  ),
                ),
                title: Container(
                  width: size.width * 0.6,
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: selected ? Colors.black : Colors.black26,
                          blurRadius:
                              5, // has the effect of softening the shadow
                          spreadRadius:
                              3, // has the effect of extending the shadow
                          offset: Offset(
                            5.0, // horizontal, move right 10
                            5.0, // vertical, move down 10
                          ),
                        ),
                        /* BoxShadow(
                          color: selected
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.transparent,
                          blurRadius:
                              50, // has the effect of softening the shadow
                          spreadRadius: size
                              .height, // has the effect of extending the shadow
                          offset: Offset(
                            0.0, // horizontal, move right 10
                            0.0, // vertical, move down 10
                          ),
                        )*/
                      ],
                      color: selected
                          ? kSearchBarColor
                          : kSearchBarColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(size.height * 0.05)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.015),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                          size: size.height * 0.02,
                        ),
                      ),
                      Expanded(
                          child: TextField(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.015),
                              controller: _textEditingController,
                              onTap: () {
                                setState(() {
                                  selected = true;
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  selected = false;
                                });

                                save(
                                    "https://yandex.com.tr/search/?text=$value");

                                Navigator.push(
                                    context,
                                    SlideLeftRoute(
                                        page: TabPage(
                                      tabModel: TabModel.withId(newPageId,
                                          "https://yandex.com.tr/search/?text=$value"),
                                    )));
                                _textEditingController.clear();
                              },
                              maxLines: 1,
                              decoration: null))
                    ],
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Container(
                  decoration: BoxDecoration(color: kGradientStartColor),
                  child: Column(
                    children: <Widget>[
                      //history - new incognito mode - new tab -
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            optionWidget(
                                size,
                                Icons.history,
                                "History",
                                () => Navigator.push(context,
                                    SlideLeftRoute(page: HistoryPage()))),
                            optionWidget(
                                size,
                                Icons.add,
                                "New tab",
                                () => save(
                                    "https://www.google.com.tr/search?q=")),
                            optionWidget(size, FontAwesomeIcons.userSecret,
                                "Incognito", () {}),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        height: tabList.isNotEmpty ? size.height * 0.375 : 0,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn,
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    width: size.width / 2 - size.width * 0.143,
                                  ),
                                  Text(
                                    "Tabs",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: size.height * 0.03),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.2,
                                  ),
                                  GestureDetector(
                                    onTap: () => closeAll(),
                                    child: Text(
                                      "Close all",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: size.height * 0.02,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.09),
                              height: size.height * 0.3,
                              width: size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.all(0),
                                  itemCount: count,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return tabWidget(
                                        size, this.tabList[index], context);
                                  }),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.02),
                        child: Text(
                          "Bookmarks",
                          style: TextStyle(
                              color: Colors.grey, fontSize: size.height * 0.03),
                        ),
                      ),
                      _addNewBookmark(),
                    ],
                  ),
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return bookmarkWidget(size, favList[index],
                    () => _simplePopup(favList[index].id), context);
              }, childCount: favCount),
            )
          ],
        ),
      ),
    );
  }
}
/*SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return bookmarkWidget(size, favList[index],
                    () => _simplePopup(favList[index].id), context);
              }, childCount: favCount),
            )*/
