import 'dart:ffi';
// import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
class Profile {
  final String addr;
  final Int16 port;
  final String username;
  final String pass;

  Profile(this.addr, this.port, this.username, this.pass);

  Profile.fromJson(Map<String, dynamic> json)
      : addr = json['addr'],
        port = json['port'],
        username = json['username'],
        pass = json['pass'];

  Map<String, dynamic> toJson() => {
        'addr': addr,
        'port': port,
        'username': username,
        'pass': pass,
      };
}
