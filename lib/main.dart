import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:json_annotation/json_annotation.dart';

// TODO create ssh profile page

import 'profile.dart';
import 'profilepage.dart';

void main() {
  runApp(SMagic());
}

class HomePage extends StatefulWidget {
  HomePage( { super.key } );

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Color customColor = Color.fromRGBO(80, 30, 55, 1);
  String connectButtonText = 'Connect';
  bool isConnected = false;

  void connectButtonAction() {
    if (!isConnected) {
      // TODO user should connect to remote server via tunnel

      setState(() {
        connectButtonText = 'Disconnect';
      });
      isConnected = true;
    } else {
      setState(() {
        // TODO user should disconnect from remote server

        connectButtonText = 'Connect';
        isConnected = false;
      });
    }
  }

  ElevatedButton connectButton() {
    return ElevatedButton(
      onPressed: () {
        connectButtonAction();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16.0),
        primary: customColor,
        onPrimary: Colors.white,
        elevation: 20, // Elevation
        shadowColor: Colors.black, // Shadow Color
      ),
      // connect to sshuttle when this button is clicked
      child: Text(
        connectButtonText,
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Drawer customDrawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures user can scroll
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 64,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(80, 30, 55, 1),
              ),
              child: Text('SSH Magic'),
            )
          ),
          ListTile(
            title: const Text('SSH Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Magic'),
        backgroundColor: customColor,
      ),
      body: Container(),
        drawer: customDrawer(context),
    );
  }
}

class SMagic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

