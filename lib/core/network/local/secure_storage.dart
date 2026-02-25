import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();
  static SecureStorage get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _locale;

  Future<void> init() async {
    _locale = await _storage.read(key: 'locale');
  }

  String? get locale => _locale;

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
    if (key == 'locale') _locale = value;
  }

  Future<String?> read({required String key}) async {
    if (key == 'locale') return _locale;
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
    if (key == 'locale') _locale = null;
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
