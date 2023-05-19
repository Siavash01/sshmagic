import 'dart:ffi';

class SProfile {
  final String addr;
  final Int16 port;
  final String username;
  final String pass;

  SProfile(
    this.addr,
    this.port,
    this.username,
    this.pass
  );
}
