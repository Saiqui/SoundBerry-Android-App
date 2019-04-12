import 'package:flutter/material.dart';

import 'wifi_set.dart';
import 'info.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
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
                  'Paramètre de l\'enceinte',
                  style: TextStyle(fontFamily: 'Nunito-Black', fontSize: 25),
                ),
              ],
            ),
            ListTile(
              title: Text("Wifi Setup",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                  )),
              trailing: Icon(Icons.wifi),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WifiSetup())),
            ),
            ListTile(
              title: Text("Informations",
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
              trailing: Icon(Icons.info),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => InfoWidget())),
            ),
          ],
        ),
      ),
    );
  }
}
