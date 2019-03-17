import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/foundation.dart';


class WifiSetup extends StatefulWidget {
  @override
  _WifiSetupState createState() => _WifiSetupState();
}

class _WifiSetupState extends State<WifiSetup> {
   
  static final TextEditingController _text = new TextEditingController();
   
  
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
    new GlobalKey<FormFieldState<String>>();

  var menuItems = <String>[
    'Please','Scan','Wifi','On','The','Raspberry',
  ];
  

  String _password;
  String ssiddropdowm;
  String buffer;
  int _k, _old_k;
  int _ssiddropdowm;

  int _state = 0;

  Widget setUpButtonChild(){
    if(_state == 0){
      return Text("Wifi Scan");
    }
    else if(_state == 1){
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple[900]),
      );
    }
    else {
      return Icon(Icons.check, color: Colors.deepPurple[900]);
    }
  }

  void wifiConnectProcess(){
      setState(() {
        _state = 1;
      });
      FlutterBluetoothSerial.instance.write("w.1");
      Fluttertoast.showToast(
        msg: "Scan Wifi sur le raspberry",
        toastLength: Toast.LENGTH_SHORT,
        );
      FlutterBluetoothSerial.instance.onRead().listen((msg){
        setState(() {
          _k = 0;
          for (int i = 0; i < menuItems.length; i++) {
          _old_k =_k;
          while (msg[_k] != ':') {
            _k = _k+1;
            }
          print('_k = $_k');
          print('old_k = $_old_k');
          print('_i = $i');
          menuItems[i] = msg.substring(_old_k, _k);
          _k = _k+1;
          }
          _state = 2;
                        
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wifi"),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  // child: Text("Scan Wifi"),
                  child: setUpButtonChild(),
                  onPressed: (){
                    setState(() {
                      if(_state == 0){
                        wifiConnectProcess();
                      }
                    });
                    
                  },
                )
              ],
            ),
            DropdownButton(
              value: _ssiddropdowm == null ? null : menuItems[_ssiddropdowm],
              hint: Text("SSID"),
              items: menuItems.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: ((String value){
                setState(() {
                  _ssiddropdowm = menuItems.indexOf(value);
                });
              }),
            ),
            
            SizedBox(
              height: 24.0
            ),
            PasswordField(
              fieldKey: _passwordFieldKey,
              helperText: 'Taper le Mot de Passe ici',
              labelText: 'Mot de Passe',
              onFieldSubmitted: (String value) {
                setState(() {
                  this._password = value;
                });
              },

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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 50,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
              new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}