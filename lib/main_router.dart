import 'package:bi_transactions_frontend/repositories/account_repo.dart';
import 'package:bi_transactions_frontend/repositories/secure_store.dart';
import 'package:bi_transactions_frontend/repositories/tranfers_repo.dart';
import 'package:bi_transactions_frontend/repositories/user_repo.dart';
import 'package:bi_transactions_frontend/screens/accounts/accounts_list.dart';
import 'package:bi_transactions_frontend/screens/accounts/new_account.dart';
import 'package:bi_transactions_frontend/screens/home/home_tab_bar.dart';
import 'package:bi_transactions_frontend/screens/login/login_screen.dart';
import 'package:bi_transactions_frontend/screens/login/sign_up_screen.dart';
import 'package:bi_transactions_frontend/screens/settings/settings.dart';
import 'package:bi_transactions_frontend/screens/transfers/new_transfer.dart';
import 'package:bi_transactions_frontend/screens/transfers/transfer_list.dart';
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
                  builder: (context, state) => NewAccountPage(
                    accountsRepo: AccountRepository(),
                  ),
                )
              ])
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/tranfers',
              builder: (context, state) =>
                  TransferList(transferRepo: TransferMockRepository()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'new_transfer',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => NewTransferWidget(
                    accountsRepo: AccountRepository(),
                  ),
                )
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
