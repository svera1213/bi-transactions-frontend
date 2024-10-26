import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:http/http.dart' as http;

abstract class AccountRepositoryProtocol {
  Future<List<Account>> fetchAccounts();
  Future<bool> newAccount(String name);
  Future<bool> depositToAccount(int accountId, double value);
}

class AccountRepository extends AccountRepositoryProtocol {
  @override
  Future<List<Account>> fetchAccounts() async {
    var key = await SecureStore.instance.getToken();
    var userId = await SecureStore.instance.getUserId();
    var uri = 'http://0.0.0.0:8080/api/accounts/NUI/$userId';
    log('-------------------------------------\n   Calling $uri');
    final response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $key'
      },
    );
    log('   Status code ${response.statusCode}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      log('   Body: ${response.body}\n-------------------------------------');
      return json
          .map((account) => Account.fromJson(account as Map<String, dynamic>))
          .toList();
    } else {
      log('-------------------------------------');
      throw Exception('No se pudieron cargar sus cuentas');
    }
  }

  @override
  Future<bool> newAccount(String name) async {
    var key = await SecureStore.instance.getToken();
    var userId = await SecureStore.instance.getUserId();
    var uri = 'http://0.0.0.0:8080/api/accounts';
    log('-------------------------------------\n   Calling $uri');
    final response = await http.post(Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $key'
        },
        body: jsonEncode(<String, dynamic>{
          'userNationalId': int.parse(userId),
          'accountName': name
        }));
    log('   Status code ${response.statusCode}\n-------------------------------------');
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('No se pudo crear la nueva cuenta');
    }
  }

  @override
  Future<bool> depositToAccount(int accountId, double value) async {
    var key = await SecureStore.instance.getToken();
    var uri = 'http://0.0.0.0:8080/api/accounts/deposit';
    log('-------------------------------------\n   Calling $uri');
    final response = await http.post(Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $key'
        },
        body: jsonEncode(
            <String, dynamic>{'accountId': accountId, 'amount': value}));
    log('   Status code ${response.statusCode}\n-------------------------------------');
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('No se pudo realizar el deposito');
    }
  }
}
