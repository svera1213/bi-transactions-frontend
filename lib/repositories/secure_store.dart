import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  SecureStore._privateConstructor();

  static final SecureStore _instance = SecureStore._privateConstructor();

  static SecureStore get instance => _instance;

  final _storage = const FlutterSecureStorage();

  final String tokenKey = 'TOKEN_KEY';

  final String userIdKey = 'USER_ID_KEY';

  Future<void> storeToken(String token) {
    return _storage.write(key: tokenKey, value: token);
  }

  Future<String> getToken() async {
    return await _storage.read(key: tokenKey) ?? '';
  }

  Future<bool> isUserAuthenticated() async {
    var key = await _storage.read(key: tokenKey);
    return key != null;
  }

  Future<void> logOut() {
    return _storage.deleteAll();
  }

  Future<void> storeUserId(String id) {
    return _storage.write(key: userIdKey, value: id);
  }

  Future<String> getUserId() async {
    return await _storage.read(key: userIdKey) ?? '';
  }
}
