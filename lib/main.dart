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

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  ProfileStorage ps = ProfileStorage();
  // read profles file synchronously. This is done to get last connected profile for default profile
  String jsonString = File('assets/profile.json').readAsStringSync();
  Map<String, dynamic> profileMap = jsonDecode(jsonString);

  runApp(SMagic());
}

// this class is going to be used in ssh profiles page
// pass the class directly to the profiles page Widget
class ProfileStorage {
  // return document directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // returns specified file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/profile.json');
  }

  // returns the contents of the specified file as String
  Future<String> readString() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }
}

dynamic jsonDecode(String source,
        {Object? reviver(Object? key, Object? value)?}) =>
    json.decode(source, reviver: reviver);

// validation
bool portValid(String port) {
  var intPort = 0;
  try {
    intPort = int.parse(port);
  } catch (e) {}
  return intPort == 22 || (1023 < intPort && intPort < 65536);
}

bool addrValid(String addr) {
  return RegExp(r"^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$")
      .hasMatch(addr);
}

// the main UI
class SMagic extends StatelessWidget {
  // text controllers to read input from TextFields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // variables to save the input information
  late String addr, port, username, pass;

  // Custom input
  TextField CInput(TextEditingController objController,
      [String? objLabel, String? objHint, bool? objObscureText]) {
    if (objLabel == null) objLabel = '';
    if (objHint == null) objHint = '';
    if (objObscureText == null) objObscureText = false;
    return TextField(
        controller: objController,
        obscureText: objObscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: objLabel,
          hintText: objHint,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(80, 30, 55, 1),
            title: Text("SSH MAGIC"),
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Container(
                width: 400,
                height: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      // input ssh information from TextFields
                      // TODO add margin to input fiels and connect button
                      // TODO set maximum size for input fiels and connect button
                        children: <Widget>[
                          // vertically show input fiels and connect button
                          CInput(addressController, 'Address', 'x.x.x.x'),
                          SizedBox(height: 10),
                          CInput(portController, 'Port'),
                          SizedBox(height: 10),
                          CInput(usernameController, 'Username'),
                          SizedBox(height: 10),
                          CInput(passwordController, 'password', '', true),
                        ]),
                    ElevatedButton(
                      onPressed: () {
                        // read input on button click
                        addr = addressController.text;
                        port = portController.text;
                        username = usernameController.text;
                        pass = passwordController.text;
                        // TODO user should connect to remote server via tunnel when this button is clicked
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16.0),
                        primary: Colors.blue[600],
                        onPrimary: Colors.white,
                        elevation: 20, // Elevation
                        shadowColor: Colors.black, // Shadow Color
                      ),
                      // connect to sshuttle when this button is clicked
                      child: const Text(
                        'Connect',
                        style: TextStyle(fontSize: 40),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
