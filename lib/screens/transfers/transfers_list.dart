import 'package:bi_transactions_frontend/models/transfer.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransfersList extends StatefulWidget {
  const TransfersList(
      {super.key, required this.transferRepository, required this.accountId});

  final TransferRepositoryProtocol transferRepository;

  final int accountId;

  @override
  State<StatefulWidget> createState() => _TransfersListState();
}

class _TransfersListState extends State<TransfersList> {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  bool isLoading = false;

  Future<List<Transfer>> getTransfers() {
    return widget.transferRepository.fetchTransfers(widget.accountId);
  }

  Widget getListView(List<Transfer> tranfers) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: tranfers.length,
      itemBuilder: (context, index) {
        var tranfer = tranfers[index];
        var amount = currencyFormat.format(tranfer.amount);
        return ListTile(
          title: Text(tranfer.originAccount.accountName),
          subtitle: Text('Para: ${tranfer.destinationAccount.accountName}'),
          trailing: Text(amount),
          tileColor: Colors.blueGrey[300],
          leadingAndTrailingTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          onTap: () {},
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencias'),
      ),
      body: FutureBuilder(
          future: getTransfers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                  child: GestureDetector(
                child: const Text(
                  'No tiene transacciones registradas',
                  style: TextStyle(fontSize: 20),
                ),
              ));
            } else {
              return getListView(snapshot.data ?? []);
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed('new_transfer',
              pathParameters: {'id': '${widget.accountId}'});
        },
        tooltip: 'Nueva transaccion',
        child: const Icon(Icons.add),
      ),
    );
  }
}
