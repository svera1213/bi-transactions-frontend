import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => widget.navigationShell.goBranch(index),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: 'Cuentas'),
            BottomNavigationBarItem(
                icon: Icon(Icons.send), label: 'Transacciones'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Ajustes'),
          ]),
    );
  }
}
