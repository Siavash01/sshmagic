import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'profilepage.dart';
import 'package:desktop_window/desktop_window.dart' as window_size;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.DesktopWindow.setWindowSize(const Size(400, 600));
    window_size.DesktopWindow.setMinWindowSize(const Size(400, 600));
    window_size.DesktopWindow.setMaxWindowSize(const Size(400, 600));
  }

  runApp(const SMagic());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int selectedProfileId = 0;
  Map? selectedProfile;
  int? shuttlePid;
  final Color customColor = const Color.fromRGBO(80, 30, 55, 1);
  final Color listTileColor = const Color.fromRGBO(80, 30, 55, 0);
  final Color selectedProfileColor = const Color.fromRGBO(94, 90, 89, 1);

  bool isConnected = false;

  Map<dynamic, dynamic> initialJson = {
    "selected": 0,
    "lastId": 0,
    "profiles": []
  };

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
        var result = await Process.start('sshuttle', [
          '--dns',
          '--no-latency-control',
          '-r',
          '${currProf["username"]}:${currProf["pass"]}@${currProf["addr"]}:${currProf["port"]}',
          '0/0',
          '-x',
          '${currProf["addr"]}'
        ]);
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
      hoverColor: const Color.fromRGBO(80, 30, 55, 0.3),
      selected: selectedProfileId == data['id'],
      selectedTileColor: selectedProfileColor,
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // returns specified file. if not exists or corrupted, creates it
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

  Future<Widget> fetchProfiles() async {
    var result = await readString();
    dynamic staticData = await jsonDecode(result)['profiles'];
    // dynamic staticData = await Profiles.data;
    return ListView.builder(
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
              )),
          ListTile(
            title: const Text('SSH Profile'),
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              )
                  .then((e) {
                setState(() {});
              }); // setState for current Class when addProfile is done
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
            child = const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Profiles data corrupted',
                ));
          } else {
            const Padding(
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
  const SMagic({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
