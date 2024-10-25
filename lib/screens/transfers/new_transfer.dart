import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';

class NewTransferWidget extends StatefulWidget {
  const NewTransferWidget({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _NewTransferWidgetState();
}

class _NewTransferWidgetState extends State<NewTransferWidget> {
  final _formKey = GlobalKey<FormState>();
  List<Account> accounts = [];

  bool isLoading = true;
  String fromAccountNumber = '';

  @override
  void initState() {
    super.initState();
    widget.accountsRepo
        .fetchAccounts()
        .then((value) => accounts = value)
        .whenComplete(() {
      setState(() {
        isLoading = false;
        // fromAccountNumber = accounts.first.accountNumber;
      });
    });
  }

  Widget getFormWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Cuenta de origen'),
            const SizedBox(
              height: 5,
            ),
            // DropdownButton<String>(
            //     value: fromAccountNumber,
            //     items: accounts.map<DropdownMenuItem<String>>((account) {
            //       return DropdownMenuItem<String>(
            //         value: account.accountNumber,
            //         child: Text('${account.accountNumber} - ${account.name}'),
            //       );
            //     }).toList(),
            //     onChanged: (value) {
            //       setState(() {
            //         fromAccountNumber = value ?? '';
            //       });
            //     }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Número de cuenta destino'),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el número de la cuenta';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
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
                onPressed: () {}, child: const Text('Enviar transferencia')),
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
