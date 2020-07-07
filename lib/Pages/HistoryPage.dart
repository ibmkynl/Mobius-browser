import 'package:flutter/material.dart';
import 'package:mobius_browser/Database/DatabaseHelper.dart';
import 'package:mobius_browser/Models/HistoryModel.dart';
import 'package:mobius_browser/Widgets/historyWidget.dart';
import 'package:mobius_browser/constants.dart';
import 'package:sqflite/sqflite.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  List<HistoryModel> historyList;
  int count = 0;

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<HistoryModel>> tabListFuture =
          _databaseHelper.getHistoryList();
      tabListFuture.then((historyList) {
        setState(() {
          this.historyList = historyList;
          this.count = historyList.length;
        });
      });
    });
  }

  void deleteFromHistory(id) async {
    await _databaseHelper.delete(id, 2);
    updateListView();
  }

  @override
  void initState() {
    if (historyList == null) {
      historyList = List<HistoryModel>();
      updateListView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGradientStartColor,
        title: Text("History"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: kGradientEndColor,
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return historyWidget(historyList[index], size,
                  () => deleteFromHistory(historyList[index].id), context);
            }),
      ),
    );
  }
}
