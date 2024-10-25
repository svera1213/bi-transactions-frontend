class Account {
  final int id;
  final String type;
  final int userNationalId;
  final double balance;
  final String createdAt;

  Account(
      this.id, this.type, this.userNationalId, this.balance, this.createdAt);

  factory Account.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'userNationalId': int userNationalId,
        'type': String type,
        'balance': double balance,
        'createdAt': String created,
      } =>
        Account(id, type, userNationalId, balance, created),
      _ => throw const FormatException('Error al parsear la cuenta'),
    };
  }
}
