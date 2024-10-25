import 'dart:convert';
import 'dart:io';

import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:http/http.dart' as http;

abstract class AccountRepositoryProtocol {
  Future<List<Account>> fetchAccounts();
  Future<void> newAccount(String name);
  Future<void> depositToAccount(int accountId, double value);
}

class AccountRepository extends AccountRepositoryProtocol {
  @override
  Future<List<Account>> fetchAccounts() async {
    var key = await SecureStore.instance.getToken();
    var userId = await SecureStore.instance.getUserId();
    final response = await http.get(
      Uri.parse('http://0.0.0.0:8080/api/accounts/NUI/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $key'
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((account) => Account.fromJson(account as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('No se pudieron cargar sus cuentas');
    }
  }

  @override
  Future<void> newAccount(String name) async {
    var key = await SecureStore.instance.getToken();
    var userId = await SecureStore.instance.getUserId();
    await http.post(Uri.parse('http://0.0.0.0:8080/api/accounts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $key'
        },
        body: jsonEncode(<String, dynamic>{
          'userNationalId': int.parse(userId),
          'accountName': name
        }));
  }

  @override
  Future<void> depositToAccount(int accountId, double value) async {
    var key = await SecureStore.instance.getToken();
    await http.post(Uri.parse('http://0.0.0.0:8080/api/accounts/deposit'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $key'
        },
        body: jsonEncode(
            <String, dynamic>{'accountId': accountId, 'amount': value}));
  }
}
