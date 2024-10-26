import 'package:bi_transactions_frontend/models/user.dart';
import 'package:bi_transactions_frontend/repositories/user_repo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.userRepository});

  final UserRepositoryProtocol userRepository;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var credentials = LoginCredentials();

  bool isLoading = false;

  void onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingrese sus credenciales')));
      return;
    }
    try {
      _formKey.currentState?.save();

      setState(() {
        isLoading = true;
      });

      await widget.userRepository.login(credentials.toLogin());

      goToAccounts();
    } on Exception catch (e) {
      showError(e.toString());

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

  Widget getCardWidget() {
    return Column(
      children: [
        const Spacer(),
        Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Ingreso',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  TextFormField(
                    onSaved: (newValue) => credentials.email = newValue ?? '',
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'El correo ingresado es incorrecto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (newValue) =>
                        credentials.password = newValue ?? '',
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
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
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: onSubmit, child: const Text('Ingresar'))
                ],
              ),
            )),
        GestureDetector(
          child: const Text('¿No tiene cuenta? REGISTRO'),
          onTap: () {
            context.go('/sign_up');
          },
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
              child: Center(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : getCardWidget())),
        ));
  }
}
