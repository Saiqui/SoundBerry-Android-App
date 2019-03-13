import 'package:flutter/material.dart';



class WifiSetup extends StatefulWidget {
  @override
  _WifiSetupState createState() => _WifiSetupState();
}

class _WifiSetupState extends State<WifiSetup> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
    new GlobalKey<FormFieldState<String>>();

  String _password;

  
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                icon: null,
                labelText: 'SSID'
              ),
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