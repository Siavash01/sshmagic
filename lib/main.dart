import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'profile.dart';
import 'profilepage.dart';

void main() {
  runApp(SMagic());
}

class HomePage extends StatefulWidget {
  HomePage( { super.key } );

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int selectedProfileId = 0;
  Map? selectedProfile;
  int? shuttlePid;
  final Color customColor = Color.fromRGBO(80, 30, 55, 1);
  final Color listTileColor = Color.fromRGBO(80, 30, 55, 0);
  final Color selectedProfileColor = Color.fromRGBO(94, 90, 89, 1);
  
  bool isConnected = false;

  Icon connectButtonIcon = const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );

  Icon playIcon() {
    return const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );
  }
  
  Icon squareIcon() {
    return const Icon(
      Icons.square,
      size: 30,
      color: Colors.white,
    );
  }

  bool passValid(String pass) {
    return RegExp(r"^([0-9]|[A-z]|_|\.|%|!|@|#|\$|\^|&|\*|\(|\)|\+)+$")
        .hasMatch(pass);
  }

  void connectButtonAction(BuildContext context) async {
    if (!isConnected) {
      var currProf = selectedProfile;
      if (currProf != null) { 
        setState(() {
          connectButtonIcon = squareIcon();
        });
        isConnected = true;
        var result = await Process.start('sshuttle', ['--dns', '--no-latency-control', '-r', '${currProf["username"]}:${currProf["pass"]}@${currProf["addr"]}:${currProf["port"]}', '0/0', '-x', '${currProf["addr"]}']);
        shuttlePid = result.pid;
        // TODO use result.stdout and result.stderr to check for timeout or catch errors
      }
    } else {
      var tmpId = shuttlePid;
      if (tmpId != null) {
        Process.killPid(tmpId);
      }
      setState(() {
        connectButtonIcon = playIcon();
        isConnected = false;
      });
    }
  }

  Widget connectButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => connectButtonAction(context),
      backgroundColor: customColor,
      child: connectButtonIcon,
    );
  }

  void selectProfile(Map data) {
    // TODO try cache exceptions and errors
    selectedProfile = data;
    setState(() {
      selectedProfileId = data['id'];
    });
    // TODO setState to change ListTile color
  }

  Widget profileListItem(Map data) {
    return ListTile(
      title: Text("${data['username']}"),
      subtitle: Text("${data['addr']}:${data['port']}"),
      leading: CircleAvatar(
          child: Text('${data['id']}'),
      ), 
      onTap: () => selectProfile(data),
      tileColor: listTileColor,
      hoverColor: Color.fromRGBO(80, 30, 55, 0.3),
      selected: selectedProfileId == data['id'],
      selectedTileColor: selectedProfileColor,
    );
  }

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
      body: FutureBuilder<Widget>(
        future: fetchProfiles(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          Widget? child;
          if (snapshot.hasData) {
            child = snapshot.data;
          } else if (snapshot.hasError) {
            child = Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'), // TODO when finishid change to Text("Could not load profiles");
              );
          } else {
            child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              );
          }
          return Center(
            child: child,
            );
        },
      ),
      drawer: customDrawer(context),
      floatingActionButton: connectButton(context),
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

