import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewDepositPage extends StatefulWidget {
  const NewDepositPage(
      {super.key, required this.accountsRepo, required this.accountId});

  final AccountRepositoryProtocol accountsRepo;
  final String accountId;

  @override
  State<StatefulWidget> createState() => _NewDepositPageState();
}

class _NewDepositPageState extends State<NewDepositPage> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  double deposit = 0;

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
    widget.accountsRepo
        .depositToAccount(int.parse(widget.accountId), deposit)
        .then((_) {
      onPop();
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
                  deposit = double.parse(newValue ?? '0');
                },
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad a depositar';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: onSubmit, child: const Text('Depositar')),
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
              title: const Text('Depositar a la cuenta'),
            ),
            body: SafeArea(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : getFormWidget())));
  }
}
