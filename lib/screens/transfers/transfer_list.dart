import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:bi_transactions_frontend/screens/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransferList extends StatefulWidget {
  const TransferList({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _TransferListState();
}

class _TransferListState extends State<TransferList> {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  bool isLoading = false;

  List<Account> accounts = [];

  @override
  void initState() {
    super.initState();
    updateAccounts();
  }

  void updateAccounts() {
    getAccounts().then((value) {
      setState(() {
        accounts = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showError(error.toString());
    });
  }

  Future<List<Account>> getAccounts() {
    return widget.accountsRepo.fetchAccounts();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget getListView() {
    return accounts.isEmpty
        ? EmptyWidget(
            title: 'No tiene cuentas',
            onRefresh: () async {
              updateAccounts();
            })
        : RefreshIndicator(
            onRefresh: () async {
              updateAccounts();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                var account = accounts[index];
                var amount = currencyFormat.format(account.balance);
                return ListTile(
                  title: Text(account.accountName),
                  trailing: Text(amount),
                  tileColor: Colors.blueGrey[300],
                  leadingAndTrailingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  onTap: () {
                    GoRouter.of(context).goNamed('list_transfers',
                        pathParameters: {
                          'id': '${accounts[index].id}',
                          'balance': '${accounts[index].balance}'
                        });
                  },
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
    return FocusDetector(
        onFocusGained: updateAccounts,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transferencias'),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : getListView(),
        ));
  }
}
