import 'dart:async';

import 'package:body_sch/components/edit_user.dart';
import 'package:body_sch/components/user_details.dart';
import 'package:body_sch/data/Warning.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/home.dart';
import 'components/scanner.dart';
import 'components/search.dart';
import 'components/warnings.dart';
import 'data/UserDetailsArguments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'BodySCH'),
      routes: {
        UserDetails.routeName: (context) => UserDetails(),
        Warnings.routeName: (context) => Warnings(),
        '/edit': (context) => EditUser(),
      },
    );
  }
}

class WarningDetails {
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
 final List<Widget> _children = [
   Home(),
   Scanner(),
   Container(color: Colors.green)
 ];

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            }
          )
        ]
      ),
      body: _children[_currentIndex],
      floatingActionButton: _actionButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.amber[800],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Scan'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
            label: 'Approve profiles',
          ),
        ],
      )
    );
  }

  _actionButton() {
    if (_currentIndex == 1) {
      return FloatingActionButton(
        child:Icon(Icons.edit),
        onPressed: () => {
          Navigator.pushNamed(
            context,
            UserDetails.routeName,
            arguments: UserDetailsArguments(
              '1226161032'
            ),
          )
        },
      ) ;
    }
    return null;
  }
}
