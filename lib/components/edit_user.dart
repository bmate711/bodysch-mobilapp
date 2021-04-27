import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:body_sch/data/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  final Uri apiUrl = Uri.http(apiBaseUrl, 'api/v1/users/me');
  String _cardNumber = '';
  String _room = '';
  String _role = '';


  Future<Profile> fetchProfile() async {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Faild to load data!');
    }
  }

  Future<bool> updateProfile(Profile profile) async {
      print(profile.roomNumber);
      final body = profile.toJSON();
      print(body);
      final response = await http.put(
        apiUrl,
        body: body,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }
      );
      if (response.statusCode == 204) {
        return true;
      }
      else {
        throw Exception('Faild to load data!');
      }
  }

  _onSave(Profile profile) async {
    if(_room != '')
      profile.roomNumber = int.parse(_room);
    if(_cardNumber != '')
      profile.studentCardNumber = _cardNumber;
    if(_role != '')
      profile.staffMemberText = _role;
    var updated = await updateProfile(profile);
    print(updated);
    setState(() {
      _cardNumber = '';
      _room = '';
      _role = '';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder<Profile>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Scaffold(
            appBar: AppBar(
              title: Text('Edit profile'),
            ),
            body: Container(
            color: Colors.blueGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _textInputWithTitle(snapshot.data.studentCardNumber, 'Student card number', (value) => setState(() => _cardNumber = value) ,''),
                      _textInputWithTitle(snapshot.data.roomNumber.toString(), 'Room', (value) => setState(() => _room = value) ,''),
                      _textInputWithTitle(snapshot.data.staffMemberText, 'Role', (value) => setState(() => _role = value) ,''),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState != null && _formKey.currentState.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Saved")));
                                await _onSave(snapshot.data);
                              }
                            },
                            child: Text('Save'),
                          ),
                        ), 
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
          );
        }
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
      return Center(child: CircularProgressIndicator());
      }
    );
  }

  _textInputWithTitle(String initValue, String title, onChanged, String hintText) {
    return(
      Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: initValue,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: title,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please fill';
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value);
            },)
          ],
        ),
      )
    );
  }
}