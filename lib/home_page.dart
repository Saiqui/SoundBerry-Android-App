import 'package:flutter/material.dart';

import 'dart:async';


import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:url_launcher/url_launcher.dart';

import 'wifi_setup.dart';
import 'equalizer.dart';




class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}




class _MyAppState extends State<MyApp> {
  static final TextEditingController _message = new TextEditingController();
  static final TextEditingController _text = new TextEditingController();

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  FlutterBluetoothSerial  get() {
    return bluetooth;
  }
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          setState(() {
            _connected = true;  
            _pressed = false;
          });
          break;
        case FlutterBluetoothSerial.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          // TODO
          print(state);
          break;
      }
    });

    bluetooth.onRead().listen((msg) {
      setState(() {
        print('Read: $msg');
        _text.text += msg;
      });
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  bool _stateMute = false;
  String _commandMute;
  double _minVol = 0;
  double _maxVol = 100;
  double _sliderValue = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[900],
                ),
                child: Center(
                  child: Text("Menu", style: TextStyle(color: Colors.white),),
                ),
              
              ),
              ListTile(
                title: new Text("Wifi Setup"),
                trailing: new Icon(Icons.wifi),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WifiSetup())),
              ),
              ListTile(
                title: new Text("Equalizer"),
                trailing: new Icon(Icons.equalizer),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Equalizer())),
              ),
              ListTile(
                title: new Text("Alexa App"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {_launchAlexa();}
              ),
              Divider(),
              ListTile(
                title: new Text("Close"),
                trailing: Icon(Icons.cancel),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyApp()));
                }
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Flutter Bluetooth Serial'),
          backgroundColor: Colors.deepPurple[900],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value),
                      value: _device,
                    ),
                    RaisedButton(
                      onPressed:
                          _pressed ? null : _connected ? _disconnect : _connect,
                      child: Text(_connected ? 'Disconnect' : 'Connect'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new TextField(
                        controller: _message,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Message:',
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: _connected ? _writeTest : null,
                      child: Text('Send'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.volume_mute, color: Colors.grey,
                  ),
                  Slider(
                    min: _minVol,
                    max: _maxVol,
                    activeColor: Colors.deepPurple[900],
                    inactiveColor: Colors.grey,
                    value: _sliderValue,
                    divisions: 20,
                    label: '${_sliderValue.round()}',
                    onChanged: (double value) {
                      if(_stateMute == false) {
                        null;
                      }
                      else {
                        setState(() {
                          _sliderValue = value;
                          String _volumeCommande = "v" + _sliderValue.round().toString() + "%";
                          bluetooth.write(_volumeCommande);
                        });
                      }
                    },
                  ),
                  Icon(Icons.volume_up, color: Colors.grey,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Mute"),
                  Switch(
                    value: _stateMute,
                    activeColor: Colors.deepPurple[900],
                    onChanged: (bool value) {
                      setState(() {
                        _stateMute = _stateMute ^ true;
                      });
                      if(_stateMute ==  true){
                        _commandMute = "v.u";
                      }
                      else {
                        _commandMute = "v.m";
                      }
                      bluetooth.write(_commandMute);
                    },
                  ),
                  Text("Unmute"),
                ],
                
              )
              
            ],
          ),
        ),
      ),
    );
  }


  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }


  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }


  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }


  void _writeTest() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write(_message.text);
      }
    });
  }


  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}

_launchAlexa() async {
  const url = 'https://play.google.com/store/apps/details?id=com.amazon.dee.app&hl=fr';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}