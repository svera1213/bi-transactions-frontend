class Account {
  final int id;
  final String accountName;
  final int userNationalId;
  final double balance;
  final String createdAt;

  Account(this.id, this.accountName, this.userNationalId, this.balance,
      this.createdAt);

  factory Account.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'userNationalId': int userNationalId,
        'accountName': String accountName,
        'balance': double balance,
        'createdAt': String created,
      } =>
        Account(id, accountName, userNationalId, balance, created),
      _ => throw const FormatException('Error al parsear la cuenta'),
    };
  }
}
