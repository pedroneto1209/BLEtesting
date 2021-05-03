import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:voltzble/router.dart';

StreamController<List<int>> cont = StreamController<List<int>>.broadcast();
Stream receiveStream = cont.stream;

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
  List<Widget> listdev = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    fetchdevices().then((value) {
      setState(() {
        listdev = value;
      });
    });
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
        Container(
          height: 400,
          width: 250,
          child: listdev.isEmpty
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                )
              : ListView(children: listdev),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              listdev = [];
            });
            fetchdevices().then((value) {
              setState(() {
                listdev = value;
              });
            });
          },
          child: Icon(
            Icons.refresh,
            size: 50,
          ),
        )
      ]),
    ));
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

  Future fetchdevices() async {
    List<BluetoothDevice> rawlist = [];
    List<Widget> liquidlist = [];

    await flutterBlue.startScan(timeout: Duration(seconds: 5));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        rawlist.add(r.device);
      }
    });

    await flutterBlue.stopScan();

    rawlist.forEach((element) {
      liquidlist.add(
          bleitem(element.name == '' ? 'Unknown device' : element.name, () {
        connectble(element);
      }));
    });

    if (liquidlist.isEmpty) {
      fetchdevices();
    }

    return liquidlist;
  }

  Future connectble(BluetoothDevice device) async {
    device.disconnect();
    await device.connect(autoConnect: false);

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      if (service.uuid == Guid('6E400001-B5A3-F393-E0A9-E50E24DCCA9E')) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid == Guid('6E400003-B5A3-F393-E0A9-E50E24DCCA9E')) {
            //receber
            setState(() {
              receiveStream = c.value.asBroadcastStream();
              c.setNotifyValue(!c.isNotifying);
            });
          } else if (c.uuid == Guid('6E400002-B5A3-F393-E0A9-E50E24DCCA9E')) {
            //enviar

          }
        }
      }
    });

    Navigator.of(context).pushNamed('/home');
  }
}
