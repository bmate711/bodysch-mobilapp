import 'dart:convert';

import 'package:body_sch/components/user_details.dart';
import 'package:body_sch/data/ProfileSearchItem.dart';
import 'package:body_sch/data/UserDetailsArguments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';


class CustomSearchDelegate extends SearchDelegate {
  Future<List<ProfileSearchItem>> fetchSearch(String query) async {
    final Uri apiUrl = Uri.http(apiBaseUrl, 'api/v1/users', {'search': query});
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((profile) => ProfileSearchItem.fromJson(profile)).toList();
    }
    else {
      throw Exception('Faild to load data!');
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

 @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
     return FutureBuilder<List<ProfileSearchItem>>(
      future: fetchSearch(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.length);
          if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                "No result!",
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            children: ListTile.divideTiles(
              tiles: snapshot.data.map<Widget>((user) => ListTile(
                onTap: () => (Navigator.pushNamed(
                    context,
                    UserDetails.routeName,
                    arguments: UserDetailsArguments(
                    user.studentCardNumber
                    ),
                  )),
                title: Text(user.name),
                subtitle: Text(user.studentCardNumber),
                trailing: Wrap(
                  spacing: 24,
                  children: <Widget>[
                    Wrap (spacing: 0, children: <Widget>[
                      Text(
                        '3',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      ),
                      Icon(Icons.warning_amber_rounded, size: 26, color: Colors.red,)
                    ]), // icon-1
                    Icon(Icons.message, size: 24,), // icon-2
                  ],
                ),
              )).toList(),
              context: context,
            ).toList(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

}