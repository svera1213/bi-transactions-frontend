import 'package:bi_transactions_frontend/models/transfer.dart';

abstract class TransferRepositoryProtocol {
  Future<List<Transfer>> fetchTransfers();
}

class TransferMockRepository extends TransferRepositoryProtocol {
  @override
  Future<List<Transfer>> fetchTransfers() async {
    await Future.delayed(const Duration(microseconds: 2000));
    return <Transfer>[
      Transfer('12345', '9456349', 12.3, DateTime.utc(2024, 10, 23, 10, 40, 0)),
      Transfer('93846', '23414', 400, DateTime.utc(2024, 10, 18, 15, 05, 0)),
      Transfer('84920', '12345', 23.76, DateTime.utc(2024, 10, 22, 22, 40, 0)),
      Transfer('12345', '64590', 1989.6, DateTime.utc(2024, 10, 15, 10, 04, 0)),
      Transfer('93846', '93846', 2.3, DateTime.utc(2024, 10, 24, 08, 33, 0)),
    ];
  }
}
