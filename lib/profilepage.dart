import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// my own modules
import 'profile.dart';

// this class is going to be used in ssh profiles page
// pass the class directly to the profiles page Widget
class ProfileStorage {
  dynamic jsonDecode(String source,
          {Object? reviver(Object? key, Object? value)?}) =>
      json.decode(source, reviver: reviver);

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

  Widget profileListItem(Map data) {
    return ListTile(
      title: Text("${data['username']}"),
      subtitle: Text("${data['addr']}:${data['port']}"),
      leading: CircleAvatar(
          child: Text('${data['id']}'),
      ), 
      onTap: () {
        print("hiiiiiii"); // TODO
      },
    );
  }

  Future<Widget> fetchProfiles() async {
    var result = await readString();
    dynamic staticData = await jsonDecode(result)['profiles'];
    // dynamic staticData = await Profiles.data;
    return await ListView.builder(
      itemBuilder: (builder, index) {
        Map data = staticData[index];
        return profileListItem(data);
      },
      itemCount: staticData.length,
    );
  }
}

class ProfilePage extends StatelessWidget {
  Color customColor = Color.fromRGBO(80, 30, 55, 1);

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
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 3),
          ),
          labelText: objLabel,
          hintText: objHint,
        ));
  }

  Widget interface() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget> [
        Container(),
        CInput(addressController, 'Address', 'x.x.x.x'),
        CInput(portController, 'Port'),
        CInput(usernameController, 'Username'),
        CInput(passwordController, 'Password'),
      ]
    );
  }

  void addProfileButtonAction() {
    addr = addressController.text;
    port = portController.text;
    username = usernameController.text;
    pass = passwordController.text;

    if (addrValid(addr) &&
        portValid(port) &&
        usernameValid(username) &&
        passValid(pass)) {
      // TODO add input data to json file
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH Profiles'),
        backgroundColor: customColor,
      ),
      body: Column(
        children: <Widget> [
          Flexible(
            child: interface(),
          ),
          Flexible(
            child: Center(
              child: Ink(decoration:ShapeDecoration(color: customColor, shape:CircleBorder()),
                child:IconButton(
                iconSize:40,
                onPressed: () => addProfileButtonAction(), 
                icon: Icon(
                  Icons.add,
                  color:Colors.white,
                ),
              )
            ),),
          ), 
        ]
      )
    );
  }
}
