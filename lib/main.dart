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

// the main UI
class SMagic extends StatelessWidget {
  // text controllers to read input from TextFields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // variables to save the input information
  late String addr, port, username, pass;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SSH MAGIC"),
        ),
        body: Padding(  
          padding: EdgeInsets.all(15),
          child: Column(
            // input ssh information from TextFields
            // TODO add margin to input fiels and connect button
            // TODO set maximum size for input fiels and connect button
            children: <Widget> [ // vertically show input fiels and connect button
            TextField(
              controller: addressController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
                hintText: 'x.x.x.x',
              ),
            ),
            TextField(
              controller: portController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Port',
              ),
            ),
            TextField(
              controller: usernameController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              )
            ),
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
                shell.run('sshuttle --dns --no-latency-control -r $username@$addr:$port 0/0 -x $addr');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                elevation: 20,  // Elevation
                shadowColor: Colors.black, // Shadow Color
              ),
              // connect to sshuttle when this button is clicked
              child: const Text(
                'Connect',
                style: TextStyle(fontSize: 40),
              ),
            )
            ]
          )
        )
      ),
    );
  }
}
