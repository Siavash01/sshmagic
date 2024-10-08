import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Color customColor = const Color.fromRGBO(80, 30, 55, 1);

  // text controllers to read input from TextFields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // variables to save the input information
  late String addr, port, username, pass;

  Map<dynamic, dynamic> initialJson = {
    "selected": 0,
    "lastId": 0,
    "profiles": []
  };

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

  bool usernameValid(String username) {
    return RegExp(r"^([0-9]|[A-z]|_|\.|\-|%)+$").hasMatch(username);
  }

  bool passValid(String pass) {
    return RegExp(r"^([0-9]|[A-z]|_|\.|%|!|@|#|\$|\^|&|\*|\(|\)|\+|\-)+$")
        .hasMatch(pass);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    String filePath = await _localPath;
    final file = File('$filePath/profile.json');

    bool fileExists = await file.exists();
    if (!fileExists) {
      Map<dynamic, dynamic> jsonData = initialJson;

      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(jsonData));
    } else {
      final existingJsonData = jsonDecode(await file.readAsString());
      Map<dynamic, dynamic> jsonData = initialJson;
      if (!existingJsonData.containsKey('selected') ||
          !existingJsonData.containsKey('lastId') ||
          !existingJsonData.containsKey('profiles')) {
        await file.writeAsString(jsonEncode(jsonData));
      }
    }
    return file;
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

  // Custom input
  TextField cInput(TextEditingController objController,
      [String? objLabel, String? objHint, bool? objObscureText]) {
    objLabel ??= '';
    objHint ??= '';
    objObscureText ??= false;
    return TextField(
        controller: objController,
        obscureText: objObscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 3),
          ),
          labelText: objLabel,
          hintText: objHint,
        ));
  }

  Widget interface() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          cInput(addressController, 'Address', 'x.x.x.x'),
          cInput(portController, 'Port'),
          cInput(usernameController, 'Username'),
          cInput(passwordController, 'Password', '', true),
        ]);
  }

  void addProfileButtonAction() async {
    addr = addressController.text;
    port = portController.text;
    username = usernameController.text;
    pass = passwordController.text;

    if (addrValid(addr) &&
        portValid(port) &&
        usernameValid(username) &&
        passValid(pass)) {
      Map<dynamic, dynamic> jsonMap = jsonDecode(await readString());
      int lastId = jsonMap['lastId'];
      Map newProfile = {
        "id": lastId + 1,
        "addr": addr,
        "port": port,
        "username": username,
        "pass": pass
      };
      jsonMap["profiles"].add(newProfile);
      jsonMap["lastId"] = jsonMap["lastId"] + 1;
      File jsonFile = await _localFile;
      jsonFile.writeAsString(jsonEncode(jsonMap));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SSH Profiles'),
          backgroundColor: customColor,
        ),
        body: Column(children: <Widget>[
          Flexible(
            child: interface(),
          ),
          // add profile button
          Flexible(
            child: Center(
              child: Ink(
                  decoration: ShapeDecoration(
                      color: customColor, shape: const CircleBorder()),
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () => addProfileButtonAction(),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ]));
  }
}
