import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:bi_transactions_frontend/repositories/user_repo.dart';
import 'package:bi_transactions_frontend/screens/accounts/accounts_list.dart';
import 'package:bi_transactions_frontend/screens/accounts/new_account.dart';
import 'package:bi_transactions_frontend/screens/accounts/new_deposit.dart';
import 'package:bi_transactions_frontend/screens/home/home_tab_bar.dart';
import 'package:bi_transactions_frontend/screens/login/login_screen.dart';
import 'package:bi_transactions_frontend/screens/login/sign_up_screen.dart';
import 'package:bi_transactions_frontend/screens/settings/settings.dart';
import 'package:bi_transactions_frontend/screens/transfers/new_transfer.dart';
import 'package:bi_transactions_frontend/screens/transfers/transfer_list.dart';
import 'package:bi_transactions_frontend/screens/transfers/transfers_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter mainRouter =
    GoRouter(navigatorKey: _rootNavigatorKey, routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) => LoginPage(
            userRepository: UserRepository(),
          ),
      redirect: (context, state) async {
        var isSignedIn = await SecureStore.instance.isUserAuthenticated();
        if (isSignedIn) {
          return '/accounts';
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'sign_up',
          builder: (context, state) => SignUpScreen(
            userRepository: UserRepository(),
          ),
        )
      ]),
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeTabBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/accounts',
              builder: (context, state) =>
                  AccountsList(accountsRepo: AccountRepository()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'new_account',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      NewAccountWidget(accountsRepo: AccountRepository()),
                ),
                GoRoute(
                    path: '/new_deposit/:id',
                    name: 'new_deposit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return NewDepositPage(
                        accountsRepo: AccountRepository(),
                        accountId: id,
                      );
                    })
              ])
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/tranfers',
              builder: (context, state) =>
                  TransferList(accountsRepo: AccountRepository()),
              routes: <RouteBase>[
                GoRoute(
                    path: '/list_transfers/:id/:balance',
                    name: 'list_transfers',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '-1';
                      final balance = state.pathParameters['balance'] ?? '0';
                      return TransfersList(
                        transferRepository: TransferRepository(),
                        accountId: int.parse(id),
                        balance: double.parse(balance),
                      );
                    }),
                GoRoute(
                    path: '/new_transfer/:id',
                    name: 'new_transfer',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return NewTransferWidget(
                        accountRepository: AccountRepository(),
                        transferRepository: TransferRepository(),
                        accountId: int.parse(id),
                      );
                    })
              ])
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsWidget(),
          )
        ])
      ])
]);
