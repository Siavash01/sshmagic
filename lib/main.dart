import 'package:flutter/material.dart';

void main() => runApp(SMagic());

class SMagic extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                labelText: 'Port',
              )
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () { },
              child: Text('TextButton'),
            ),
            ]
          )
        )
      ),
    );
  }
}
