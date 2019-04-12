import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


import 'settings.dart';
import 'equalizer.dart';
import 'bluetooth.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  Widget SetUpVolumeButton() {
    if (_stateVolume == 0) {
      return Column(
        children: <Widget>[
          Text(
            '${_sliderValue.toInt()}' + ' %',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 32,
              color: (_stateMute ? Colors.deepPurple[900] : Colors.grey),
            ),
          ),
          Text(
            'Volume',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 25,
              color: (_stateMute ? Colors.deepPurple[900] : Colors.grey),
            ),
          ),
        ],
      );
    } else {
      return Icon(
        Icons.clear,
        size: 90,
        color: Colors.grey,
      );
    }
  }

  //Déclaration des variables
  double _sliderValue = 0;
  bool _stateMute = true;
  int _stateVolume = 0;

  String _infoSsid;
  String _infoIp;

  @override
  Widget build(BuildContext context) {
    
    
    //création de la page d'acceuil 
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //boutton qui redirige vers la connexion bluetooth de l'enceinte
                IconButton(
                  icon: Icon(Icons.bluetooth),
                  color: Colors.grey[600],
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BluetoothCo())),
                ),
                Spacer(
                  flex: 40,
                ),
                //boutton qui redirige vers l'equalizer
                IconButton(
                  icon: Icon(Icons.equalizer),
                  color: Colors.grey[600],
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Equalizer())),
                ),
                //boutton qui redirige vers les réglages
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.grey[600],
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Settings())),
                ),
              ],
            ),
            //Widget qui met le nom de l'enceinte centré
            Center(
              child: Text(
                "SoundBerry",
                style: TextStyle(fontFamily: 'Nunito-Black', fontSize: 32.0),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            //slider pour le son, sa taille est défini par le Container()
            Container(
              padding: EdgeInsets.only(right: 50, left: 50),
              child: Slider(
                min: 0.0,
                max: 100.0,
                value: _sliderValue,
                activeColor: Colors.deepPurple[900],
                onChanged: (double value) {
                  setState(() {
                    if (_stateMute) {
                      _sliderValue = value;
                      String _volumeCommande =
                          "v." + _sliderValue.round().toString() + "%";
                      print(_volumeCommande);
                      FlutterBluetoothSerial.instance.write(_volumeCommande);
                      
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            //boutton qui permet d'afficher le volume en % et de muter ou non le son
            FlatButton(
                child: SetUpVolumeButton(),
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _stateMute = !_stateMute;
                    _stateVolume = _stateVolume ^ 1;
                  });
                  if (_stateMute) {
                    bluetooth.write("v.u");
                  } else {
                    bluetooth.write("v.m");
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class MuteState extends StatefulWidget {
  @override
  _MuteStateState createState() => _MuteStateState();
}

class _MuteStateState extends State<MuteState> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
