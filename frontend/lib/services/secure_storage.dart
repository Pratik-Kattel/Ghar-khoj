import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _token = 'flutter_auth';

  static Future<void> saveToken(String? value) async {
    await _storage.write(key: _token, value: value);
  }

  static Future<String> readData(String key) async {
    return await _storage.read(key: key) ?? "No data found";
  }

  static Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
