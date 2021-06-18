import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:voltzble/cubit/ble_cubit.dart';
import 'package:voltzble/router.dart';

StreamController<List<int>> cont = StreamController<List<int>>.broadcast();
Stream receiveStream = cont.stream;
BluetoothCharacteristic writechar;

String error = 'Logs';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //block horizontal positioning
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
  void initState() {
    BlocProvider.of<BleCubit>(context).scanDevices(context);
    super.initState();
  }

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
        BlocBuilder<BleCubit, BleState>(
          builder: (context, state) {
            if (state is SearchCompleted) {
              return Container(
                height: 400,
                width: 250,
                child: ListView(children: state.list),
              );
            }

            return Container(
                height: 400,
                width: 250,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ));
          },
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<BleCubit>(context).scanDevices(context);
          },
          child: Icon(
            Icons.refresh,
            size: 50,
          ),
        )
      ]),
    ));
  }
}
