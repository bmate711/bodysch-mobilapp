import 'dart:convert';
import 'dart:io';

import 'package:body_sch/data/Warning.dart';
import 'package:body_sch/data/WarningsArguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../app_config.dart';

class Warnings extends StatefulWidget {
  static const routeName = '/warnings';

  @override
  _WarningsState createState() => _WarningsState();
}

class _WarningsState extends State<Warnings> {
  Future<Warning> addWarning(String text, String id) async {
      final response = await http.post(
        Uri.http(apiBaseUrl, 'api/v1/users/user/$id/warnings'),
        body: jsonEncode({"text": text}),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }
      );
      if (response.statusCode == 200) {
        return Warning.fromJson(jsonDecode(response.body));
      }
      else {
        throw Exception('Faild to load data!');
      }
  }

  @override
  Widget build(BuildContext context) {
    final WarningsArguments args = ModalRoute.of(context).settings.arguments;
    return  
      Scaffold(
            appBar: AppBar(
              title: Text('Warnings'),
            ),
            floatingActionButton: _actionButton(),
            body: Container(
            color: Colors.blueGrey,
            child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            children: ListTile.divideTiles(
              tiles: args.warnings.map<Widget>((warning) => ListTile(
                title: Text(warning.text),
                subtitle: Text(DateFormat('yyyy-MM-dd kk:mm').format(warning.date)),
              )).toList(),
              context: context,
            ).toList(),
          )
        )
      );
  }

  _actionButton() {
      final controller = TextEditingController();
      return FloatingActionButton(
        child:Icon(Icons.add),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                controller: controller,
                decoration: InputDecoration(
                    labelText: 'Add warning'
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final WarningsArguments args = ModalRoute.of(context).settings.arguments;
                final warning = await addWarning(controller.text, args.id);
                args.warnings.add(warning);
                Navigator.pop(context);
              })
        ],
      ),
          ).then((value) => setState(() {}));
    },
      ) ;
  }
}