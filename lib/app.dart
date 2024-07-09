import 'package:flutter/material.dart' hide MaterialPage;

import 'package:go_router/go_router.dart';

import 'package:obedience_chaster/themes.dart';

import 'routes.dart';
import 'widgets/not_found_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = GoRouter(
    routes: routes,
    errorPageBuilder: (_, __) => const MaterialPage(child: NotFoundPage()),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Obedience Chaster Extension',
      theme: Themes.red.getData(true),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
