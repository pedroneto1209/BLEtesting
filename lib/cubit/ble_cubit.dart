import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meta/meta.dart';
import 'package:encrypt/encrypt.dart' as cryp;

part 'ble_state.dart';

class BleCubit extends Cubit<BleState> {
  List<Widget> loglist = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Stream receivestream;
  BluetoothCharacteristic sendChar;

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
        sendChar = characteristic;
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

    receivestream = characteristic.value;

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

  List<int> encrypt(List<int> buffer) {
    final key = cryp.Key.fromUtf8("2020JKM3329bN!93");

    final iv = cryp.IV.fromLength(16);

    final encrypter = cryp.Encrypter(cryp.AES(key, mode: cryp.AESMode.ecb));

    return encrypter.encryptBytes(buffer, iv: iv).bytes;
  }

  void decrypt(List<int> buffer) {
    final key = cryp.Key.fromUtf8("2020JKM3329bN!93");

    final iv = cryp.IV.fromLength(16);

    final encrypter = cryp.Encrypter(cryp.AES(key, mode: cryp.AESMode.ecb));

    print(encrypter.encryptBytes(buffer, iv: iv).bytes);

    //return encrypter.decryptBytes(cryp.Encrypted.fromBase64(buffer), iv: iv);
  }

  void send(String value) async {
    while (true) {
      try {
        int valor = int.parse(value);

        //result

        sendChar.write([
          0xE5,
          0x07,
          0x00,
          0x00,
          0x10,
          0x01,
          0x17,
          0x40,
          0x33,
          valor, //valor,
          0x42, // 66 curve distance
          0x00,
          0x00,
          0x00,
          0x18, //testing 24 destination_num
          0x00
        ]);

        await Future.delayed(Duration(milliseconds: 500));

        sendChar.write([
          0xE5,
          0x07,
          0x00,
          0x00,
          0x1A, //nav4
          0x01,
          0x17,
          0x40,
          0x00, //20 eta hour
          0x00, //21 eta second
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00
        ]);

        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print('insira numero valido');
      }
    }
  }
}
