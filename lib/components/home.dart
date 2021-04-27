import 'dart:convert';

import 'package:body_sch/data/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';
class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Profile> fetchProfile() async {
    final Uri apiUrl = Uri.http(apiBaseUrl, 'api/v1/users/me');
    final response = await http.get(apiUrl);
    print('fetchProfile');
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Faild to load data!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder<Profile>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  Container(
            color: Colors.blueGrey,
            child: 
              Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(height: 124, color: Colors.black87),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child:  CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1189&q=80'),
                              ),
                            ), 
                          )
                        ],
                      ),
                      _textWithTitle('Name', snapshot.data.name),
                      _textWithTitle('Student ID', snapshot.data.studentCardNumber),
                      _textWithTitle('Email', snapshot.data.email),
                      _textWithTitle('Room', snapshot.data.roomNumber.toString()),
                      _textWithTitle('Role', snapshot.data.staffMemberText),
                    ],
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      child:Icon(Icons.edit),
                      onPressed:  () async {
                        Navigator.pushNamed(
                          context,
                          '/edit',
                        ).then((value) => setState(() {}));
                      },
                    )
                  )
                ]
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

  _textWithTitle(String title, String text) {
    return(
      Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      )
    );
  }
}