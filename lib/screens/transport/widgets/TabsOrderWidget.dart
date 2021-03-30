import 'dart:async';

import 'package:flutter/material.dart';

class TabOrderSupport {
  int index;
  String text;
  bool selected;

  TabOrderSupport({this.index, this.text, this.selected});

  List<TabOrderSupport> initTabs() {
    List<TabOrderSupport> data = List();

    /// Given
    TabOrderSupport tabGiven = TabOrderSupport();
    tabGiven.index = 0;
    tabGiven.text = 'Đã bàn giao';
    tabGiven.selected = true;
    data.add(tabGiven);

    /// Un given
    TabOrderSupport tabUnGiven = TabOrderSupport();
    tabUnGiven.index = 1;
    tabUnGiven.text = 'Chưa bàn giao';
    tabUnGiven.selected = false;
    data.add(tabUnGiven);

    /// Draft
    TabOrderSupport tabDraft = TabOrderSupport();
    tabDraft.index = 2;
    tabDraft.text = 'ĐH nháp';
    tabDraft.selected = false;
    data.add(tabDraft);

    return data;
  }
}

class TabsOrderWidget extends StatefulWidget {
  final Function(TabOrderSupport value) callback;
  final StreamController refreshStream;

  TabsOrderWidget({this.callback, this.refreshStream});

  @override
  State<StatefulWidget> createState() => _TabsOrderWidgetState();
}

class _TabsOrderWidgetState extends State<TabsOrderWidget> {
  List<TabOrderSupport> supports = TabOrderSupport().initTabs();
  TabOrderSupport _tracking;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _tracking = supports.first;

    /// Listen stream
    _listenStream();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  _listenStream() {
    _subscription = widget.refreshStream.stream.listen((event) {
      if (event == null) {
        return;
      }

      _tracking.selected = false;
      _tracking = supports.first;
      _tracking.selected = true;

      /// Update new status
      setState(() {});
    });
  }

  _handleTabCallback(TabOrderSupport value) {
    _tracking.selected = false;
    value.selected = true;
    _tracking = value;
    if (!mounted) {
      return;
    }

    /// Update new tab
    setState(() {});

    /// Callback
    widget.callback(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        children: supports.map<Widget>((element) {
          return tabItemWidget(element, tabCallback: (TabOrderSupport value) {
            /**
             * Handle tab callback
             */
            _handleTabCallback(value);
          });
        }).toList(),
      ),
    );
  }

  Widget tabItemWidget(TabOrderSupport support,
      {Function(TabOrderSupport support) tabCallback}) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              tabCallback(support);
            },
            child:

                /// selected
                support.selected
                    ? Column(
                        children: <Widget>[
                          Text(support.text,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 10, left: 10),
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)))),
                        ],
                      )
                    :

                    /// Unselected
                    Column(
                        children: <Widget>[
                          Text(support.text,
                              style: TextStyle(
                                  color: Color(0xff4A667C),
                                  fontWeight: FontWeight.bold)),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 10, left: 10),
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)))),
                        ],
                      )));
  }
}
