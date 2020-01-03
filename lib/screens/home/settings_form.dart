import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DBService(uid: user.uid).userData,
        builder: (context, snapshot) {
          print('Snapshot has data: ${snapshot.hasData}');

          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            _currentName = userData.name;
            _currentSugars = userData.sugars;
            _currentStrength = userData.strength;

            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your Brew Preferences',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: InputDecoration(),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) {
                      setState(() {
                        _currentName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //dropdown
                  DropdownButtonFormField(
                    isExpanded: true,
                    value: _currentSugars, // ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentSugars = val;
                      });
                    },
                  ),
                  //slider
                  Slider(
                    value: (_currentStrength ?? 200)
                        .toDouble(), // ?? userData.strength
                    min: 100,
                    divisions: 8,
                    max: 900,
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    inactiveColor: Colors.brown,
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.toInt();
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Colors.indigo,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DBService(uid: user.uid).updateUserData(
                            _currentSugars, _currentName, _currentStrength);
                      }
                      print(_currentName);
                      print(_currentStrength);
                      print(_currentSugars);
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
