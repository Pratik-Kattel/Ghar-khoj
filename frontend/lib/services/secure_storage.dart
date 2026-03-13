import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _token = 'flutter_auth';

  static Future<void> saveToken(String? value) async {
    await _storage.write(key: _token, value: value);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _token);
  }
}
