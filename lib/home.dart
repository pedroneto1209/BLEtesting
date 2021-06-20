import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voltzble/cubit/ble_cubit.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
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
                          onSubmitted: (_) {
                            BlocProvider.of<BleCubit>(context)
                                .send(intvalue.text);
                            intvalue.clear();
                          },
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
                          BlocProvider.of<BleCubit>(context)
                              .send(intvalue.text);
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
              'Logs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          StreamBuilder(
              stream: BlocProvider.of<BleCubit>(context).receivestream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  ScrollController _scrollController = ScrollController();
                  _scrollToBottom() {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }

                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());

                  BlocProvider.of<BleCubit>(context)
                      .loglist
                      .add(Text('${snapshot.data}'));

                  return Container(
                      height: 250,
                      width: 250,
                      color: Colors.black.withAlpha(50),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            BlocProvider.of<BleCubit>(context).loglist.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: BlocProvider.of<BleCubit>(context)
                                .loglist[index],
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
