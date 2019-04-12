import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class Equalizer extends StatefulWidget {
  @override
  _EqualizerState createState() => _EqualizerState();
}

class _EqualizerState extends State<Equalizer> {

  //définition des variables
  double _bassSlider = 0;
  double _mediumSlider = 0;
  double _highSlider = 0;

  @override
  Widget build(BuildContext context) {

    //création de la page
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                    'Equalizer',
                    style: TextStyle(fontFamily: 'Nunito-Black', fontSize: 25),
                  ),
                
              ],
            ),
            //slider pour les basses fréquences
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 100),
              child: Slider(
                min: 0,
                max: 100,
                value: _bassSlider,
                activeColor: Colors.deepPurple[900],
                onChanged: (double value) {
                  setState(() {
                    _bassSlider = value;
                    String _volumeCommand = "0." + _bassSlider.round().toString() + "%";
                    FlutterBluetoothSerial.instance.write(_volumeCommand);
                  });
                },
              ),
            ),
            //slider pour les médiums
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 30),
              child: Slider(
                min: 0,
                max: 100,
                value: _mediumSlider,
                activeColor: Colors.deepPurple[900],
                onChanged: (double value) {
                  setState(() {
                    _mediumSlider = value;
                    String _volumeCommand = "1." + _mediumSlider.round().toString() + "%";
                    FlutterBluetoothSerial.instance.write(_volumeCommand);
                  });
                },
              ),
            ),
            //slider pour les hautes fréquences
            Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 30),
              child: Slider(
                min: 0,
                max: 100,
                value: _highSlider,
                activeColor: Colors.deepPurple[900],
                onChanged: (double value) {
                  setState(() {
                    _highSlider = value;
                    String _volumeCommand = "2." + _highSlider.round().toString() + "%";
                    print('DEBUG ICI');
                    print(_volumeCommand);
                    FlutterBluetoothSerial.instance.write(_volumeCommand);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}