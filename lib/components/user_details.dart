import 'dart:convert';

import 'package:body_sch/app_config.dart';
import 'package:body_sch/components/warnings.dart';
import 'package:body_sch/data/Profile.dart';
import 'package:body_sch/data/UserDetailsArguments.dart';
import 'package:body_sch/data/Warning.dart';
import 'package:body_sch/data/WarningsArguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class UserDetails extends StatefulWidget {
  static const routeName = '/userDetails';

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Future<Profile> fetchProfile(String id) async {
    final Uri apiUrl = Uri.http(apiBaseUrl, 'api/v1/users/user/$id');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Faild to load data!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserDetailsArguments args = ModalRoute.of(context).settings.arguments;
    print(args);
    return FutureBuilder<Profile>(
      future: fetchProfile(args.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return  Scaffold(
            appBar: AppBar(
        title: Text('User'),
      ),
            body: Container(
        color: Colors.blueGrey,
        child: Column(
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
            _cardStatus(),
            _warnings(snapshot.data.warnings, snapshot.data.studentCardNumber),
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
  _warnings(List<Warning> warnings, String id) {
      return Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
        child: InkWell(
          onTap:  () async {
            Navigator.pushNamed(
              context,
              Warnings.routeName,
              arguments: WarningsArguments(warnings, id),
            ).then((value) => setState(() {}));
          },
          child: Text(
              "Warnings: ${warnings.length}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.blue[900],
              ),

        // Row(
        //   children: [
            
        //     ),
          
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: warnings.map<Widget>((e) => Text(
            //       e.text,
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 24,
            //       ),
            // //     )).toList(),
            // )
          // ],
        )
        )
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

  _cardStatus() {
    return(
      Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Card status",
            ),
            InkWell(
          onTap:  () async {
            showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('Printed'),
                  ),
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('Gived'),
                  ),
                ],
              )
            );
          },
          child: Text(
              "Aplied",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.blue[900],
              ),
          )
        )
          ],
        ),
      )
    );
  }
}