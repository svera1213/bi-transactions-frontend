import 'dart:convert';
import 'dart:io';
import 'package:bi_transactions_frontend/models/user.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:http/http.dart' as http;

abstract class UserRepositoryProtocol {
  Future<bool> login(LoginAccount account);
  Future<bool> signUp(SignUpCredentials credentials);
  Future<bool> getUserNationalId(String email);
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
      await SecureStore.instance.storeToken(response.body);
      await getUserNationalId(account.email);
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
      await SecureStore.instance.storeToken(response.body);
      await SecureStore.instance.storeUserId(credentials.nationalId);
      return true;
    } else {
      throw Exception('No se pudo crear su cuenta');
    }
  }

  @override
  Future<bool> getUserNationalId(String email) async {
    var key = await SecureStore.instance.getToken();
    final response = await http.get(
      Uri.parse('http://0.0.0.0:8080/api/users/email/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $key'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      var nationalId = switch (json) {
        {
          'nationalId': int nationalId,
        } =>
          '$nationalId',
        _ => throw const FormatException('Failed to load album.'),
      };
      await SecureStore.instance.storeUserId(nationalId);
      return true;
    } else {
      throw Exception('No se pudo obtener el id del usuario');
    }
  }
}
