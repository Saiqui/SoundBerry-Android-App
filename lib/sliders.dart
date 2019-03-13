import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class SliderVolume extends StatefulWidget {
  @override
  _SliderVolumeState createState() => _SliderVolumeState();
}



class _SliderVolumeState extends State<SliderVolume> {
  double _minVol = 0;
  double _maxVol = 100;
  double _sliderValue = 0;
  String _volumeCommande ="";

  //TODO
  //Récuperer la valeur du rasp par le bluetooth
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
          label: '${_sliderValue.round()}',
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