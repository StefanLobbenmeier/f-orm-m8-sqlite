import 'package:example/fragments/health_entry_row.dart';
import 'package:example/main.adapter.g.m8.dart';
import 'package:example/models/independent.g.m8.dart';
import 'package:flutter/material.dart';

class HealthConditionsFragment extends StatefulWidget {
  HealthConditionsFragment();

  _HealthConditionsFragmentState createState() =>
      _HealthConditionsFragmentState();
}

class _HealthConditionsFragmentState extends State<HealthConditionsFragment> {
  List<HealthEntryProxy> healthEntries;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _db = DatabaseHelper();

  @override
  void initState() {
    if (healthEntries == null) {
      print("Init State load is called");
      healthEntries = [];
      _loadAsyncCurrentData().then((result) {
        setState(() {
          print("Loading database result is $result");
        });
      });
    }

    super.initState();
  }

  Future<bool> _loadAsyncCurrentData() async {
    var _dbHealthEntries = await _db.getHealthEntrysAll();
    healthEntries = List<HealthEntryProxy>();

    _dbHealthEntries.forEach(
      (f) {
        healthEntries.add(HealthEntryProxy.fromMap(f));
      },
    );

    return true;
  }

  final _formKey = GlobalKey<FormState>();

  Widget _container() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Health Conditions"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          key: Key('textFormField'),
                          onSaved: (value) {
                            _saveHealthEntry(value);
                            setState(() {});
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            key: Key('button'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: healthEntries.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return HealthEntryRow(
                          healthEntry: healthEntries[index],
                          onPressed: (h) {
                            _deleteHealthEntry(h);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _container();
  }

  Future<void> _saveHealthEntry(String text) async {
    try {
      var tempHealthEntry = HealthEntryProxy();
      tempHealthEntry.description = text;
      tempHealthEntry.diagnosysDate = DateTime.now();
      var newId = await _db.saveHealthEntry(tempHealthEntry);
      tempHealthEntry.id = newId;

      healthEntries.add(tempHealthEntry);

      setState(() {});
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _deleteHealthEntry(HealthEntryProxy h) async {
    try {
      await _db.deleteHealthEntry(h.id);
      healthEntries.remove(h);

      setState(() {});
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Error: $message'),
      duration: Duration(seconds: 10),
    ));
  }
}
