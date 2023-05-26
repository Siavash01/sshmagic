import 'dart:ffi';
// import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
class Profile {
  final String addr;
  final Int16 port;
  final String username;
  final String pass;

  Profile(
    this.addr,
    this.port,
    this.username,
    this.pass
  );

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

class Profiles {
  static List<Map> data = [
    {
      'id': 1,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 2,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 3,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 4,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 5,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 6,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 7,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 8,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
    {
      'id': 9,
      'addr': '127.0.0.0',
      'port': 1234,
      'username': 'user1',
      'pass': 'pass1'
    },
  ];
}
