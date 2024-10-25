import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bi_transactions_frontend/models/transfer.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:http/http.dart' as http;

abstract class TransferRepositoryProtocol {
  Future<List<Transfer>> fetchTransfers(int accountId);
  Future<bool> newTransfer(int origin, int destiny, double amount);
}

class TransferRepository extends TransferRepositoryProtocol {
  @override
  Future<List<Transfer>> fetchTransfers(int accountId) async {
    var key = await SecureStore.instance.getToken();
    var uri = 'http://0.0.0.0:8080/api/accounts/transactions';
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
      log('   Body: ${response.body}\n-------------------------------------');
      final json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map(
              (transfer) => Transfer.fromJson(transfer as Map<String, dynamic>))
          .toList()
          .where(
            (transfer) => transfer.originAccount.id == accountId,
          )
          .toList();
    } else {
      log('-------------------------------------');
      throw Exception('No se pudieron cargar las transacciones');
    }
  }

  @override
  Future<bool> newTransfer(int origin, int destiny, double amount) async {
    var key = await SecureStore.instance.getToken();
    var uri = 'http://0.0.0.0:8080/api/accounts/transactions/send';
    log('-------------------------------------\n   Calling $uri');
    final response = await http.post(Uri.parse(uri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer 123' //'Bearer $key'
        },
        body: jsonEncode(<String, dynamic>{
          'originAccountId': origin,
          'destinationAccountId': destiny,
          'amount': amount,
        }));
    log('   Status code ${response.statusCode}\n-------------------------------------');
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('No se pudo realizar la transacción');
    }
  }
}
