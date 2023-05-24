import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatelessWidget {
  // text controllers to read input from TextFields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // variables to save the input information
  late String addr, port, username, pass;

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
    return RegExp(r"^([0-9]|[A-z]|_|\.|%)+$")
        .hasMatch(username);
  }

  bool passValid(String pass) {
    return RegExp(r"^([0-9]|[A-z]|_|\.|%|!|@|#|\$|\^|&|\*|\(|\)|\+)+$")
        .hasMatch(pass);
  }
  
  void insertProfile() {
    // read input on button click
    addr = addressController.text;
    port = portController.text;
    username = usernameController.text;
    pass = passwordController.text;

    if (addrValid(addr) && 
        portValid(port) &&
        usernameValid(username) &&
        passValid(pass)) {}
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Magic'),
      ),
      body: Container(),
    );
  }
}
