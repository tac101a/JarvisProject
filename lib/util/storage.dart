import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // save token
  Future<void> saveToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // get token
  Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  // delete token
  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  // delete all
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
