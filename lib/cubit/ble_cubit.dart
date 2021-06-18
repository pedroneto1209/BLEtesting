import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meta/meta.dart';

part 'ble_state.dart';

class BleCubit extends Cubit<BleState> {
  List<Widget> loglist = [];

  FlutterBlue flutterBlue = FlutterBlue.instance;

  //loglist.add(Text('${utf8.decode(snapshot.data)}'));

  //writechar.write([
  //                          0x60,
  //                          0xCC,
  //                          0x1B,
  //                          0x8A,
  //                          0x20,
  //                          0x17,
  //                          0xFF,
  //                          0x01,
  //                          0x01,
  //                          0x00,
  //                          0x00,
  //                          0x00,
  //                          0x00,
  //                          0x00,
  //                          0x00,
  //                          0x00
  //                        ]);

  BleCubit() : super(BleInitial());

  void connectDevice(BluetoothDevice device) async {
    await device.connect();
  }

  void scanDevices() async {
    emit(SearchLoading());

    List<ScanResult> listdev = [];
    List<Widget> listdevwidget = [];

    await flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (!listdev.contains(r)) {
          listdev.add(r);
        }
      }
    });

    await Future.delayed(Duration(seconds: 1));

    // Stop scanning
    flutterBlue.stopScan();
    listdev.forEach((element) {
      listdevwidget.add(bleitem(
          element.device.name == '' ? 'Unknown' : element.device.name, () {
        connectDevice(element.device);
      }));
    });

    emit(SearchCompleted(list: listdevwidget));
  }

  Widget bleitem(String name, Function func) {
    return InkWell(
      onTap: func,
      child: Container(
        height: 40,
        child: Center(
          child: Row(
            children: [
              Icon(Icons.bluetooth),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
