import 'package:bi_transactions_frontend/models/transfer.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:bi_transactions_frontend/screens/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransfersList extends StatefulWidget {
  const TransfersList(
      {super.key,
      required this.transferRepository,
      required this.accountId,
      required this.balance});

  final TransferRepositoryProtocol transferRepository;

  final int accountId;

  final double balance;

  @override
  State<StatefulWidget> createState() => _TransfersListState();
}

class _TransfersListState extends State<TransfersList> {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  List<Transfer> tranfers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateTranfers();
  }

  void updateTranfers() {
    widget.transferRepository.fetchTransfers(widget.accountId).then((value) {
      setState(() {
        tranfers = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showError(error.toString());
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget getListView() {
    return tranfers.isEmpty
        ? EmptyWidget(
            title: 'No tiene transferencias',
            onRefresh: () async {
              updateTranfers();
            })
        : RefreshIndicator(
            onRefresh: () async {
              updateTranfers();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: tranfers.length,
              itemBuilder: (context, index) {
                var tranfer = tranfers[index];
                var amount = currencyFormat.format(tranfer.amount);
                return ListTile(
                  title: Text(tranfer.originAccount.accountName),
                  subtitle:
                      Text('Para: ${tranfer.destinationAccount.accountName}'),
                  trailing: Text(amount),
                  tileColor: Colors.blueGrey[300],
                  leadingAndTrailingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencias'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.balance > 0) {
            GoRouter.of(context).goNamed('new_transfer',
                pathParameters: {'id': '${widget.accountId}'});
          } else {
            showError('No tiene fondos suficientes');
          }
        },
        tooltip: 'Nueva transaccion',
        child: const Icon(Icons.add),
      ),
    );
  }
}
