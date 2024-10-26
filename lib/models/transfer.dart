import 'package:bi_transactions_frontend/models/account.dart';

class Transfer {
  final Account originAccount;
  final Account destinationAccount;
  final double amount;

  Transfer(this.originAccount, this.destinationAccount, this.amount);

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(Account.fromJson(json['originAccount']),
        Account.fromJson(json['destinationAccount']), json['amount']);
  }
}
