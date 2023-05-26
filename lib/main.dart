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
  // test
  List<Map> staticData = Profiles.data;
  // test

  _HomePage({required this.storage});
  ProfileStorage storage;

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

  Widget getTextWidgets(String jsonString) // TODO cahe errors
  {
    dynamic jsonMap = jsonDecode(jsonString);
    List<Widget> list = <Widget>[];
    for(var i = 0; i <= 10; i++) {
        dynamic info = jsonMap['profiles'][i];
        list.add(
         ListTile(
           title: Text("${info['addr']}"),
           subtitle: Text("${info['username']}"),
           leading: CircleAvatar(
             child: Text(i.toString()),
             ),
           ),
        );
    }
    return Column(
      children: list,
      );
  }

  Widget profileList() {
    List<Map> staticData = Profiles.data;
    return ListView.builder(
      itemBuilder: (builder, index) {
        Map data = staticData[index];
        return ListTile(
          title: Text("${data['username']}"),
          subtitle: Text("${data['addr']}:${data['port']}"),
          leading: CircleAvatar(
              child: Text('${data['id']}'),
          ),
        );
      },
      itemCount: staticData.length,
    );
  }

  // following method might be completely bullwhit
  void test() async {
    await storage.fetchProfiles().then((data) {
      ListView.builder(
        itemBuilder: (builder, index) {
          Map info = data[index];
          return ListTile(
            title: Text("${info['name']}"),
            subtitle: Text("${info['email']}"),
            leading: CircleAvatar(
                child: Text('${info['id']}'),
            ),
          );
        },
        itemCount: staticData.length,
      );
    }, onError: (e) {
      print("Error***********");
      return Container();
    }
    );
  }
  // bullwhit end flag
  
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
      body: profileList(),
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

