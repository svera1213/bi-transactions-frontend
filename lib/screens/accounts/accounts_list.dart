import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AccountsList extends StatefulWidget {
  const AccountsList({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  bool isLoading = false;

  Future<List<Account>> getAccounts() {
    return widget.accountsRepo.fetchAccounts();
  }

  void createAccount() async {
    setState(() {
      isLoading = true;
    });
    await widget.accountsRepo.newAccount();
    setState(() {
      isLoading = false;
    });
  }

  Widget getListView(List<Account> accounts) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        var account = accounts[index];
        var amount = currencyFormat.format(account.balance);
        return ListTile(
          title: const Text('Cuenta bancaria'),
          subtitle: Text('Tipo: ${account.type}'),
          trailing: Text(amount),
          tileColor: Colors.blueGrey[300],
          leadingAndTrailingTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          onTap: () {
            GoRouter.of(context).go('/accounts/new_account');
          },
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
            if (snapshot.data?.isEmpty ?? true) {
              return isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: GestureDetector(
                      onTap: createAccount,
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
            } else {
              return getListView(snapshot.data ?? []);
            }
          }),
    );
  }
}
