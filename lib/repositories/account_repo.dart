import 'package:bi_transactions_frontend/models/account.dart';

abstract class AccountRepositoryProtocol {
  Future<List<Account>> fetchAccounts();
  Future<void> newAccount(Account account);
}

class AccountMockRepository extends AccountRepositoryProtocol {
  @override
  Future<List<Account>> fetchAccounts() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    return <Account>[
      Account('12345', 'Banco Pacífico', 200),
      Account('93846', 'Banco Pichincha', 150),
      Account('84920', 'Produbanco', 90)
    ];
  }

  @override
  Future<void> newAccount(Account account) async {
    await Future.delayed(const Duration(milliseconds: 2000));
  }
}
