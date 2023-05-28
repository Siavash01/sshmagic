import 'package:flutter/material.dart';

class Local extends StatelessWidget {
  final TextEditingController localPassController = TextEditingController();
  final Color customColor = Color.fromRGBO(80, 30, 55, 1);

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
        CInput(localPassController, 'local password'),
        Container(),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('local password'),
        backgroundColor: customColor,
      ),
      body: Column(
        children: <Widget> [
          Flexible(
            child: interface(),
          ),
          Flexible(
            child: Center(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  backgroundColor: MaterialStateProperty.all<Color>(customColor),
                ),
                onPressed: () => { },
                child: Text('Submit'),
              )
          ), 
        )]
      )
    );
  }
}
