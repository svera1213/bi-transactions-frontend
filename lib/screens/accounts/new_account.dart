import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewAccountWidget extends StatefulWidget {
  const NewAccountWidget({super.key, required this.accountsRepo});

  final AccountRepositoryProtocol accountsRepo;

  @override
  State<StatefulWidget> createState() => _NewAccountWidgetState();
}

class _NewAccountWidgetState extends State<NewAccountWidget> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String accountName = '';

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      showError('Por favor complete todos los campos');
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      isLoading = true;
    });

    widget.accountsRepo.newAccount(accountName).then((_) {
      onPop();
    }).catchError((error) {
      showError(error.toString());
      setState(() {
        isLoading = false;
      });
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
                  accountName = newValue ?? '';
                },
                decoration: const InputDecoration(labelText: 'Nombre cuenta'),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                onFieldSubmitted: (_) {
                  onSubmit();
                },
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
              ElevatedButton(onPressed: onSubmit, child: const Text('Crear')),
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
              title: const Text('Crear una nueva cuenta'),
            ),
            body: SafeArea(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : getFormWidget())));
  }
}
