import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/foundation.dart';

class WifiSetup extends StatefulWidget {
  @override
  _WifiSetupState createState() => _WifiSetupState();
}

class _WifiSetupState extends State<WifiSetup> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  //définition d'une liste qui recevra les ssid (6 max)
  var menuItems = <String>[
    'Please',
    'Scan',
    'Wifi',
    'On',
    'The',
    'Raspberry',
  ];

  //Définition des différentes variables
  String _password;
  String ssiddropdowm;
  String _wifiData;
  String buffer;
  int _k, _old_k;
  int _ssiddropdowm;

  int _state = 0;

  bool _osbcureTxt = false;

  //Fonction qui change l'état d'un boutton
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text("Wifi Scan");
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[900]),
      );
    } else {
      return Icon(Icons.check, color: Colors.deepPurple[900]);
    }
  }

  //fonction pour l'envoie de la trame bluetooth pour la connexion wifi
  void wifiConnectProcess() {
    setState(() {
      _state = 1;
    });
    FlutterBluetoothSerial.instance.write("w.l");
    FlutterBluetoothSerial.instance.onRead().listen((msg) {
      setState(() {
        _k = 0;
        for (int i = 0; i < menuItems.length; i++) {
          _old_k = _k;
          while (msg[_k] != ':') {
            _k = _k + 1;
          }
          print('_k = $_k');
          print('old_k = $_old_k');
          print('_i = $i');
          menuItems[i] = msg.substring(_old_k, _k);
          _k = _k + 1;
        }
        _state = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    //création de la page
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
              child: Column(
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //bouton pour récuperer les ssid wifi
                      OutlineButton(
                        child: setUpButtonChild(),
                        highlightColor: Colors.deepPurple[900],
                        borderSide: BorderSide(color: Colors.deepPurple[900]),
                        // borderSide: BorderSide(color: Colors.white),
                        padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                        onPressed: () {
                          setState(() {
                            if (_state == 0) {
                              wifiConnectProcess();
                            }
                          });
                        },
                      )
                    ],
                  ),

                  //liste déroulante pour afficher les ssid
                  DropdownButton(
                    value:
                        _ssiddropdowm == null ? null : menuItems[_ssiddropdowm],
                    hint: Text("SSID"),
                    items: menuItems.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: ((String value) {
                      setState(() {
                        _ssiddropdowm = menuItems.indexOf(value);
                        // print(menuItems[_ssiddropdowm]);
                      });
                    }),
                  ),
                  SizedBox(height: 24.0),
                  //champs pour remplir le mot de passe / possibilité de cacher le pass avec des points
                  PasswordField(
                    fieldKey: _passwordFieldKey,
                    helperText: 'Taper le Mot de Passe ici',
                    labelText: 'Mot de Passe',
                    onFieldSubmitted: (String value) {
                      setState(() {
                        _password = value;
                        print(_password);
                      });
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        child: Text("Send"),
                        highlightColor: Colors.deepPurple[900],
                        borderSide: BorderSide(color: Colors.deepPurple[900]),
                        // borderSide: BorderSide(color: Colors.white),
                        padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                        onPressed: () {
                          FlutterBluetoothSerial.instance.write("w.c");

                          _wifiData = menuItems[_ssiddropdowm] +
                              "." +
                              _password.toString();
                          print(_wifiData);

                          // _wifiData = "test";
                          // String msg;

                          FlutterBluetoothSerial.instance
                              .onRead()
                              .listen((msg) {
                            if (msg == 'ok') {
                              FlutterBluetoothSerial.instance.write(_wifiData);
                            }
                          });
                          FlutterBluetoothSerial.instance.write(_wifiData);
                          _wifiData = "";
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      // maxLength: 50,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: UnderlineInputBorder(),
        filled: false,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepPurple[900],
          ),
        ),
      ),
    );
  }
}
