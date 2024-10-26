import 'package:bi_transactions_frontend/models/user.dart';
import 'package:bi_transactions_frontend/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.userRepository});

  final UserRepositoryProtocol userRepository;

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  var credentials = SignUpCredentials();

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')));
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      isLoading = true;
    });

    try {
      await widget.userRepository.signUp(credentials);
      goToAccounts();
    } on Exception catch (error) {
      showError(error.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void goToAccounts() {
    context.go('/accounts');
  }

  Widget getFormWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              onSaved: (newValue) {
                credentials.username = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Usuario'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su usuario';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.nationalId = newValue ?? '';
              },
              decoration:
                  const InputDecoration(labelText: 'Número de identificación'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su cédula de identidad';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.firstName = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Nombre'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su nombre';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.lastName = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Apellido'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su apellido';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.phoneNumber = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Teléfono'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su teléfono';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.email = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su usuario';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onSaved: (newValue) {
                credentials.password = newValue ?? '';
              },
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.none,
              onFieldSubmitted: (_) {
                onSubmit();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: onSubmit, child: const Text('Registrarse')),
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
            title: const Text('Registro'),
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
