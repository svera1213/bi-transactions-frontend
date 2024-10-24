import 'package:bi_transactions_frontend/models/account.dart';
import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final _formKey = GlobalKey<FormState>();
  var newAccount = NewAccount();
  bool isLoading = false;

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')));
    }
    _formKey.currentState?.save();

    setState(() {
      isLoading = true;
    });
    widget.accountsRepo.newAccount(newAccount.getAccount()).whenComplete(onPop);
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
              TextFormField(
                onSaved: (newValue) {
                  newAccount.name = newValue ?? '';
                },
                decoration:
                    const InputDecoration(labelText: 'Nombre de la cuenta'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de la cuenta';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onSaved: (newValue) {
                  newAccount.accountNumber = newValue ?? '';
                },
                decoration:
                    const InputDecoration(labelText: 'Número de cuenta'),
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
                onSaved: (newValue) {
                  newAccount.balance = double.parse(newValue ?? '0');
                },
                decoration: const InputDecoration(labelText: 'Balance actual'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el balance de la cuenta';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: onSubmit, child: const Text('Agregar cuenta')),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Nueva cuenta'),
            ),
            body: SafeArea(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : getFormWidget())));
  }
}
