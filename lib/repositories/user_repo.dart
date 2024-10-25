import 'dart:convert';

import 'package:bi_transactions_frontend/models/user.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:http/http.dart' as http;

abstract class UserRepositoryProtocol {
  Future<bool> login(LoginAccount account);
  Future<bool> signUp(SignUpCredentials credentials);
}

class UserRepository extends UserRepositoryProtocol {
  @override
  Future<bool> login(LoginAccount account) async {
    final response =
        await http.post(Uri.parse('http://0.0.0.0:8080/auth/token'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(account.toJson()));

    if (response.statusCode == 200) {
      print(response.body);
      await SecureStore.instance.storeToken(response.body);
      return true;
    } else {
      throw Exception('Credenciales incorrectas');
    }
  }

  @override
  Future<bool> signUp(SignUpCredentials credentials) async {
    final response =
        await http.post(Uri.parse('http://0.0.0.0:8080/auth/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(credentials.toJson()));
    if (response.statusCode == 200) {
      print(response.body);
      await SecureStore.instance.storeToken(response.body);
      return true;
    } else {
      throw Exception('No se pudo crear su cuenta');
    }
  }
}
