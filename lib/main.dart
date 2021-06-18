import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:voltzble/cubit/ble_cubit.dart';
import 'package:voltzble/router.dart';

StreamController<List<int>> cont = StreamController<List<int>>.broadcast();
Stream receiveStream = cont.stream;
BluetoothCharacteristic writechar;

String error = 'Logs';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _appRouter.onGeneratedRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 50,
          width: 250,
          child: Center(
              child: Text(
            'Connect device',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          )),
        ),
        Container(
          height: 400,
          width: 250,
          child: BlocProvider.of<BleCubit>(context).listdev == []
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                )
              : ListView(children: BlocProvider.of<BleCubit>(context).listdev),
        ),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.refresh,
            size: 50,
          ),
        )
      ]),
    ));
  }
}
