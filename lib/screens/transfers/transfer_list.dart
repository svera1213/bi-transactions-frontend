import 'package:bi_transactions_frontend/models/transfer.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransferList extends StatefulWidget {
  const TransferList({super.key, required this.transferRepo});

  final TransferRepositoryProtocol transferRepo;

  @override
  State<StatefulWidget> createState() => _TransferListState();
}

class _TransferListState extends State<TransferList> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');
  final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  Future<List<Transfer>> getTransfers() async {
    var tranfers = await widget.transferRepo.fetchTransfers();
    tranfers.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return tranfers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transacciones'),
      ),
      body: FutureBuilder(
          future: getTransfers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  var transfer = (snapshot.data ?? [])[index];
                  var date = dateFormatter.format(transfer.timestamp);
                  var amount = currencyFormatter.format(transfer.amount);
                  return ListTile(
                    title: Text(date),
                    subtitle: Text(
                        'De: ${transfer.fromAccountNumber} - Para: ${transfer.toAccountNumber}'),
                    trailing: Text(amount),
                    tileColor: Colors.brown[300],
                    leadingAndTrailingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 5,
                    ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/tranfers/new_transfer');
        },
        tooltip: 'Nueva transaccion',
        child: const Icon(Icons.add),
      ),
    );
  }
}
