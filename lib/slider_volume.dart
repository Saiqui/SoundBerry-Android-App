import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'dart:async';



class sliderVolume extends StatefulWidget {
  @override
  _sliderVolumeState createState() => _sliderVolumeState();
}



class _sliderVolumeState extends State<sliderVolume> {
  double _minVol = 0;
  double _maxVol = 100;
  double _sliderValue = 0;
  String _volumeCommande ="";
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.volume_mute, color: Colors.grey[500],
        ),
        Slider(
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.grey[400],
          value: _sliderValue,
          min: _minVol,
          max: _maxVol,
          divisions: 20,
          onChanged: (double value){
            
            setState(() {
              _sliderValue=value;
              debugPrint(_volumeCommande);
              _volumeCommande = "v." + _sliderValue.round().toString() + "%";
              FlutterBluetoothSerial.instance.write(_volumeCommande);
            });
          },
        ),
        Icon(Icons.volume_up, color: Colors.grey[500],
        ),
      ],
    );
  }
}