import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  void onLogOut(BuildContext context) async {
    await SecureStore.instance.logOut();
    if (context.mounted) {
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: ElevatedButton(
                onPressed: () => onLogOut(context), child: const Text('Salir')),
          ),
        ],
      ),
    );
  }
}
