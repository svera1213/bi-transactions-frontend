class Transfer {
  final String fromAccountNumber;
  final String toAccountNumber;
  final DateTime timestamp;
  final double amount;

  Transfer(this.fromAccountNumber, this.toAccountNumber, this.amount,
      this.timestamp);
}
