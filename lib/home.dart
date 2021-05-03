import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voltzble/main.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> loglist = [];
    TextEditingController intvalue = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 35,
            width: 250,
            child: Text(
              'Test icon:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Container(
            height: 300,
            width: 250,
            child: Column(
              children: [
                Expanded(
                    child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff192436)))),
                      TextField(
                          controller: intvalue,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: 'Type icon int code',
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ],
                  ),
                )),
                Expanded(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: 100.0,
                      height: 100.0,
                      child: new RawMaterialButton(
                        child: Text(
                          'Send',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        fillColor: Colors.black,
                        shape: new CircleBorder(),
                        onPressed: () {
                          intvalue.clear();
                        },
                      )),
                ))
              ],
            ),
          ),
          Container(
            height: 35,
            width: 250,
            child: Text(
              'Logs:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          StreamBuilder(
              stream: receiveStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  ScrollController _scrollController = ScrollController();

                  _scrollToBottom() {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }

                  loglist.add(Text('${utf8.decode(snapshot.data)}'));
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                  return Container(
                      height: 250,
                      width: 250,
                      color: Colors.black.withAlpha(50),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: loglist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: loglist[index],
                          );
                        },
                      ));
                } else {
                  return SizedBox();
                }
              })
        ]),
      ),
    );
  }
}
