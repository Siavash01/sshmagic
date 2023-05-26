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
  State<HomePage> createState() => _HomePage(storage: ProfileStorage());
}

class _HomePage extends State<HomePage> {
  _HomePage({required this.storage});
  ProfileStorage storage;

  Color customColor = Color.fromRGBO(80, 30, 55, 1);
  bool isConnected = false;

  Icon connectButtonIcon = const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );

  Icon playIcon() {
    return const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );
  }
  
  Icon crossIcon() {
    return const Icon(
      Icons.close,
      size: 40,
      color: Colors.white,
    );
  }

  void connectButtonAction() {
    if (!isConnected) {
      // TODO user should connect to remote server via tunnel

      setState(() {
        connectButtonIcon = crossIcon();
      });
      isConnected = true;
    } else {
      setState(() {
        // TODO user should disconnect from remote server

        connectButtonIcon = playIcon();
        isConnected = false;
      });
    }
  }

  Widget connectButton() {
    return FloatingActionButton(
      onPressed: () => connectButtonAction(),
      backgroundColor: customColor,
      child: connectButtonIcon,
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
  
  dynamic jsonDecode(String source,
          {Object? reviver(Object? key, Object? value)?}) =>
      json.decode(source, reviver: reviver);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Magic'),
        backgroundColor: customColor,
      ),
      body: FutureBuilder<Widget>(
        future: storage.fetchProfiles(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          Widget? child;
          if (snapshot.hasData) {
            child = snapshot.data;
          } else if (snapshot.hasError) {
            child = Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'), // TODO when finishid change to Text("Could not load profiles");
              );
          } else {
            child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              );
          }
          return Center(
            child: child,
            );
        },
      ),
      drawer: customDrawer(context),
      floatingActionButton: connectButton(),
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

