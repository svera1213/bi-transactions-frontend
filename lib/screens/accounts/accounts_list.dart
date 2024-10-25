import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountsList extends StatefulWidget {
  const AccountsList({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  Future<List<Account>> getAccounts() {
    return widget.accountsRepo.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: FutureBuilder(
          future: getAccounts(),
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
                var account = (snapshot.data ?? [])[index];
                var amount = currencyFormat.format(account.balance);
                return ListTile(
                  title: Text(account.name),
                  subtitle: Text(account.accountNumber),
                  trailing: Text(amount),
                  tileColor: Colors.blueGrey[300],
                  leadingAndTrailingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
            );
          }),
    );
  }
}
