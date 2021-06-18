import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meta/meta.dart';

part 'ble_state.dart';

class BleCubit extends Cubit<BleState> {
  List<Widget> loglist = [];

  FlutterBlue flutterBlue = FlutterBlue.instance;

  BluetoothCharacteristic receivechar;

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

  void connectDevice(BluetoothDevice device, BuildContext context) async {
    await device.disconnect();

    await device.connect(autoConnect: false);
    discoverServc(device, context);
  }

  void discoverServc(BluetoothDevice device, BuildContext context) async {
    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid == Guid('0000FFE5-0000-1000-8000-00805F9B34FB')) {
        discoverChar(service, context);
      }
      if (service.uuid == Guid('0000FFE0-0000-1000-8000-00805F9B34FB')) {
        discoverChar(service, context);
      }
    }
  }

  void discoverChar(BluetoothService service, BuildContext context) {
    List<BluetoothCharacteristic> characteristics = service.characteristics;

    BluetoothCharacteristic char;

    for (BluetoothCharacteristic characteristic in characteristics) {
      print(characteristic);
      if (characteristic.uuid == Guid('0000FFE9-0000-1000-8000-00805F9B34FB')) {
        print('sssssqfqwewefssss');
      }
      if (characteristic.uuid == Guid('0000FFE4-0000-1000-8000-00805F9B34FB')) {
        char = characteristic;
      }
    }

    if (char != null) {
      readChar(char, context);
    }
  }

  void readChar(
      BluetoothCharacteristic characteristic, BuildContext context) async {
    try {
      await characteristic.setNotifyValue(true);
    } catch (e) {
      print(e);
    }

    receivechar = characteristic;

    Navigator.of(context).pushNamed("/home");
  }

  void scanDevices(BuildContext context) async {
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
        connectDevice(element.device, context);
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
