import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:process_run/shell.dart';

// os shell to execute shell command sshuttle
var shell = Shell();

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(SMagic());
}

bool portValid(String port){
  var intPort = 0;
  try {
     intPort = int.parse(port);
  } catch (e) {}
  return intPort == 22 || (1023 < intPort && intPort < 65536);
}
bool addrValid(String addr){
  return RegExp(r"^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$").hasMatch(addr);
}
void connectToShuttle(String addr, String port, String username, String pass) {
  if(addrValid(addr) && portValid(port) && username != '' && pass != '') shell.run('sshuttle --dns --no-latency-control -r $username@$addr:$port 0/0 -x $addr');
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
  TextField CInput(TextEditingController objController, [String? objLabel, String? objHint, bool? objObscureText]) {
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
                        CInput(passwordController, 'password', '',true),
                      ]),
                  ElevatedButton(
                    onPressed: () {
                      // read input on button click
                      addr = addressController.text;
                      port = portController.text;
                      username = usernameController.text;
                      pass = passwordController.text;
                      // TODO check if input is valid before passing to sshuttle
                      // perform sshuttle command (run a proccess)
                      // TODO handle shell exceptios
                      connectToShuttle(addr, port, username, pass);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
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
              ))),
    );
  }
}
