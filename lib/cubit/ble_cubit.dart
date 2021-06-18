import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'ble_state.dart';

class BleCubit extends Cubit<BleState> {
  List<Widget> loglist = [];
  List<Widget> listdev = [];

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
