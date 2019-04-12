import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class InfoWidget extends StatefulWidget {
  @override
  _InfoWidgetState createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  String _infoSsid = "";
  String _infoIp = "";



  @override
  Widget build(BuildContext context) {

    //création de la page
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  'Informations de l\'enceinte',
                  style: TextStyle(fontFamily: 'Nunito-Black', fontSize: 25),
                ),
              ],
            ),
            SizedBox(
              height: 120,
            ),
            Text(
              "Wifi :  $_infoSsid",
              style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
            ),
            Text(
              "Adresse IP : $_infoIp",
              style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
            ),
            Text(
              "Batterie : ",
              style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
            ),
            SizedBox(
              height: 50,
            ),
            //boutton qui récupère les infos sur le rasp
            OutlineButton(
              child: Text("Actualiser", style: TextStyle(fontFamily: 'Nunito')),
              onPressed: () {
                FlutterBluetoothSerial.instance.write('i.a');
                FlutterBluetoothSerial.instance.onRead().listen((msg) {
                  int k = 0;
                  int old_k = 0;
                  for (k = 0; msg[k] != ':'; k++) {}
                  setState(() {
                    _infoSsid = msg.substring(0, k);
                  });

                  old_k = k + 1;
                  for (k = old_k; msg[k] != ':'; k++) {}
                  setState(() {
                    _infoIp = msg.substring(old_k, k);
                  });
                  _infoIp = msg.substring(old_k, k);
                  print(
                      "******************DEBUG ICI ****************************");
                  print(_infoSsid);
                  print(_infoIp);
                });
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
