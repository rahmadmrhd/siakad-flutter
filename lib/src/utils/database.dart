import 'package:mysql_client/mysql_client.dart';

class MyDb {
  static const String _host = "192.168.95.117";
  static const String _user = "admin";
  static const String _password = "admin";
  static const String _db = "siakad";
  static const int _port = 3307;

  static final pool = MySQLConnectionPool(
    host: _host,
    port: _port,
    userName: _user,
    password: _password,
    databaseName: _db,
    maxConnections: 10,
    timeoutMs: 5000,
  );
}
