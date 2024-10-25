import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewTransferWidget extends StatefulWidget {
  const NewTransferWidget(
      {super.key,
      required this.accountRepository,
      required this.transferRepository,
      required this.accountId});

  final AccountRepositoryProtocol accountRepository;

  final TransferRepositoryProtocol transferRepository;

  final int accountId;

  @override
  State<StatefulWidget> createState() => _NewTransferWidgetState();
}

class _NewTransferWidgetState extends State<NewTransferWidget> {
  final _formKey = GlobalKey<FormState>();
  List<Account> accounts = [];

  bool isLoading = false;

  double amount = 0;

  Account? toAccount;

  @override
  void initState() {
    super.initState();
    widget.accountRepository.fetchAccounts().then((value) {
      var aux = value
          .where(
            (element) => element.id != widget.accountId,
          )
          .toList();
      setState(() {
        accounts = aux;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
        toAccount = accounts.first;
      });
    });
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')));
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      isLoading = true;
    });

    widget.transferRepository
        .newTransfer(widget.accountId, toAccount!.id, amount)
        .then((_) {
      onPop();
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showError(error.toString());
    });
  }

  void onPop() {
    GoRouter.of(context).pop();
  }

  Widget getFormWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Cuenta destino'),
            const SizedBox(
              height: 5,
            ),
            DropdownButton<Account>(
                value: toAccount,
                items: accounts.map<DropdownMenuItem<Account>>((account) {
                  return DropdownMenuItem<Account>(
                    value: account,
                    child: Text(account.accountName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    toAccount = value;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                setState(() {
                  amount = double.parse(newValue ?? '0');
                });
              },
              decoration: const InputDecoration(labelText: 'Valor a enviar'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el valor de la transferencia';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: onSubmit, child: const Text('Enviar transferencia')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Enviar transferencia'),
          ),
          body: SafeArea(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : getFormWidget()),
        ));
  }
}
