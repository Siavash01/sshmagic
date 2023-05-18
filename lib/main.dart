import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io'; 
import 'package:process_run/shell.dart';

var shell = Shell();

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(SMagic());
}

class SMagic extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
            children: <Widget> [
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
                addr = addressController.text;
                port = portController.text;
                username = usernameController.text;
                pass = passwordController.text;
                shell.run('sshuttle --dns --no-latency-control -r $username@$addr:$port 0/0 -x $addr');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                elevation: 20,  // Elevation
                shadowColor: Colors.black, // Shadow Color
              ),
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
