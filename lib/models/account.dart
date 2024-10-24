class Account {
  final String accountNumber;
  final String name;
  final double balance;

  Account(this.accountNumber, this.name, this.balance);
}

class NewAccount {
  String accountNumber = '';
  String name = '';
  double balance = 0;

  Account getAccount() {
    return Account(accountNumber, name, balance);
  }
}
