import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'file:///C:/Users/R2D2/Documents/Flutter/mobius_browser/lib/Pages/AppPage.dart';
import 'package:mobius_browser/Models/HistoryModel.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'package:mobius_browser/Transitions/ScaleT.dart';
import '../Database/DatabaseHelper.dart';
import '../constants.dart';

class TabPage extends StatefulWidget {
  final TabModel tabModel;

  TabPage({
    this.tabModel,
  });

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  TabModel _tabModel;
  HistoryModel _historyModel;
  DatabaseHelper _databaseHelper = new DatabaseHelper();
  bool canGoBack = false, canGoForward = false;
  double progress = 0;
  String url = "";
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  TextEditingController _textController = new TextEditingController();

  FocusNode _focusNode = FocusNode();

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<bool> _canGoBack;
  StreamSubscription<bool> _canGoForward;

  void save(String link) async {
    _historyModel =
        new HistoryModel(link, DateTime.now().millisecondsSinceEpoch);
    if (widget.tabModel.id != null) {
      _tabModel = new TabModel.withId(widget.tabModel.id, link);
      await _databaseHelper.update(_tabModel, 1);
    } else {
      _tabModel = new TabModel(link);
      await _databaseHelper.insert(_tabModel, 1);
    }
    await _databaseHelper.insert(_historyModel, 2);
  }

  @override
  void initState() {
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String newUrl) {
      save(newUrl);
      if (mounted) {
        setState(() {
          url = newUrl;
          _textController.text = url;
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double newValue) {
      if (mounted) {
        setState(() {
          progress = newValue;
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        Fluttertoast.showToast(
            msg: "${error.code}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: kGradientEndColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    _canGoForward.cancel();
    _canGoBack.cancel();
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*_canGoBack = flutterWebViewPlugin.canGoBack().asStream().listen((back) {
      if (mounted) {
        setState(() {
          canGoBack = back;
        });
      }
    });
    _canGoForward =
        flutterWebViewPlugin.canGoForward().asStream().listen((forward) {
      if (mounted) {
        setState(() {
          canGoForward = forward;
        });
      }
    });*/
    Size size = MediaQuery.of(context).size;
    return WebviewScaffold(
        withJavascript: true,
        withOverviewMode: true,
        withZoom: true,
        hidden: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kGradientStartColor,
          title: TextField(
            onTap: () {
              _textController.clear();
            },
            autofocus: false,
            focusNode: _focusNode,
            controller: _textController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: null,
            onSubmitted: (value) {
              flutterWebViewPlugin
                  .reloadUrl("https://www.google.com/search?q=$value");
            },
          ),
          bottom: PreferredSize(
              child: Container(
                height: size.height * 0.003,
                child: LinearProgressIndicator(
                  backgroundColor: kGradientStartColor,
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progress < 1 ? Colors.red : kGradientStartColor),
                ),
              ),
              preferredSize: null),
          centerTitle: true,
          elevation: 30,
        ),
        bottomNavigationBar: BottomAppBar(
          color: kGradientEndColor,
          child: Wrap(
            children: <Widget>[
              Container(
                height: size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (await flutterWebViewPlugin.canGoBack()) {
                          flutterWebViewPlugin.goBack();
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: canGoBack ? Colors.white : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _textController.clear();
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.pages,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (progress < 1) {
                          await flutterWebViewPlugin.stopLoading();
                        } else {
                          await flutterWebViewPlugin.reload();
                        }
                      },
                      child: Icon(
                        progress < 1 ? Icons.close : Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await flutterWebViewPlugin.canGoForward()) {
                          flutterWebViewPlugin.goForward();
                        }
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: canGoForward ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: size.height * 0.005,
                color: Colors.grey,
              )
            ],
          ),
        ),
        url: widget.tabModel.link);
  }
}
